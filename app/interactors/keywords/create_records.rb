module Keywords
  class CreateRecords
    include Interactor

    def call
      context.fail!(error: "No date given") if context.date.blank?
      context.fail!(error: "No csv_file given") if context.csv_file.blank?
      context.fail!(error: "No skip_header_lines given") if context.skip_header_lines.blank?

      options = {encoding: "utf-8", liberal_parsing: true}
      CSV.foreach(context.csv_file.path, options).with_index do |row, index|
        next if index < context.skip_header_lines
        
        ActiveRecord::Base.transaction do
          data = build_from_row(row, index - rank_correction_subtrahend)
          keyword = Keyword.find_or_create_by(data[:keyword])
          keyword.ranks.find_or_create_by(data[:keyword_rank])

          data[:products_ordered].each_with_index do |product_data|
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
      end
    end
    
    private

    def rank_correction_subtrahend 
      @rank_correction_subtrahend ||= (context.skip_header_lines || 1) - 1
    end

    def build_from_row(row, index)
      {
        keyword: {
          department: row[0],
          value: row[1]
        },
        keyword_rank: {
          position: index,
          valued_at: Date.parse(context.date)
        },
        products_ordered: 3.times.map do |i|
          offset = i * 4
          {
            asin: row[offset + 3],
            title: row[offset + 4],
            click_through_rate: BigDecimal.new(align_separator(row[offset + 5])),
            conversion_rate: BigDecimal.new(align_separator(row[offset + 6])),
            valued_at: Date.parse(context.date)
          }
        end
      }
    end

    def align_separator(value)
      value.gsub(',', '.')
    end
  end
end
