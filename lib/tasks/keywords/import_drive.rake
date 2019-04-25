require 'httparty'

include ActionView::Helpers::AssetUrlHelper

FOLDER_NAME = 'keywords_atd'
MIME_TYPE = 'csv'

namespace :keywords do
  task import: :environment do
    begin
      drive = DriveService.new

      begin_new_amazon_format = Date.parse("2017-11-01")

      files = drive.get_files(folder_name: FOLDER_NAME, mime_type: MIME_TYPE)
      jobs = files.map do |file|
        name = file.name
        date = Date.parse("#{name[0..6]}-01")
        header_lines_to_skip = date < begin_new_amazon_format ? 1 : 2
        
        KeywordsImportJob.perform_later(
          drive_file_id: file.id,
          header_lines_to_skip: header_lines_to_skip,
          date: date.to_s
        )
      end

      exit 0
    rescue => exception
      puts exception
      exit 1
    end
  end
end
