module Keywords
  class GetCSV
    include Interactor

    def call
      context.fail!(error: "No url given") if context.url.blank?

      context.csv_file = File.open("/tmp/keywords_import_#{Time.now.to_i}.csv", "wb") do |f| 
        f.write HTTParty.get(context.url).body
        f
      end
    rescue => exception
      puts exception
      context.fail!(error: "Couldn't fetch CSV file")
    end
  end
end
