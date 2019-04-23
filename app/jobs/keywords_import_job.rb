class KeywordsImportJob < ApplicationJob
  queue_as :default

  def perform(url:, header_lines_to_skip:, date:)
    url = URI.encode(url)
    result = Keywords::Import.call(
      url: url,
      header_lines_to_skip: header_lines_to_skip,
      date: Date.parse(date)
    )
    puts "#{date} #{result.success? ? "success" : "failure"} #{result.error}"
  end
end
