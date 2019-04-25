module Keywords
  class CreateRecords
    include Interactor

    def call
      context.fail!(error: "No date given") if context.date.blank?
      context.fail!(error: "No csv_file given") if context.csv_file.blank?
      context.fail!(error: "No header_lines_to_skip given") if context.header_lines_to_skip.blank?

      begin
        options = {
          encoding: "utf-8", 
          liberal_parsing: true,
          col_sep: ","
        }
        file = context.csv_file
        file.rewind
        file.each_line.with_index do |line, index|
          next if index < context.header_lines_to_skip

          row = CSV.parse_line(line.scrub(""), options)
          process_row(row, index)
        end
      ensure
        file.close
        file.unlink
      end
    end
    
    private

    def rank_correction_subtrahend 
      @rank_correction_subtrahend ||= (context.header_lines_to_skip || 1) - 1
    end

    def process_row(row, index)
      ActiveRecord::Base.transaction do
        data = build_from_row(row, index - rank_correction_subtrahend)
        keyword = Keyword.find_or_create_by(data[:keyword])
        keyword.ranks.find_or_create_by(data[:keyword_rank])

        data[:products].each do |product_data|
          product = Product.find_or_create_by(asin: product_data[:asin]) do |record|
            record.title = product_data[:title]
          end

          ProductPerformance.find_or_create_by(
            keyword: keyword, 
            product: product, 
            click_through_rate: product_data[:click_through_rate],
            conversion_rate: product_data[:conversion_rate],
            valued_at: product_data[:valued_at]
          )
        end
      end
    rescue => exception
      puts exception
      puts "Error"
      puts index
      puts row
    end

    def build_from_row(row, index)
      {
        keyword: {
          department: row[0],
          value: row[1]
        },
        keyword_rank: {
          position: index,
          valued_at: context.date
        },
        products: 3.times.map do |i|
          offset = i * 4

          asin = row[offset + 3]
          next if asin.blank?

          click_through_rate = to_decimal(row[offset + 5])
          conversion_rate = to_decimal(row[offset + 6])
          {
            asin: row[offset + 3],
            title: row[offset + 4],
            click_through_rate: click_through_rate,
            conversion_rate: click_through_rate,
            valued_at: context.date
          }
        end.compact
      }
    end

    def to_decimal(value)
      BigDecimal.new(align_separator(value))
    rescue
      nil
    end

    def align_separator(value)
      value.gsub(',', '.') if value.present?
    end
  end
end
