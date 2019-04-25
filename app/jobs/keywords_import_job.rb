class KeywordsImportJob < ApplicationJob
  queue_as :default

  def perform(drive_file_id: nil, url: nil, header_lines_to_skip:, date:)
    result = Keywords::Import.call(
      drive_file_id: drive_file_id,
      url: (URI.encode(url) if url.present?),
      header_lines_to_skip: header_lines_to_skip,
      date: Date.parse(date)
    )
    puts "#{date} #{result.success? ? "success" : "failure"} #{result.error}"
  end
end
