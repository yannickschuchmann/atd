require 'httparty'

include ActionView::Helpers::AssetUrlHelper

namespace :keywords do
  task import: :environment do
    begin
      host = Rails.application.config.action_controller.asset_host
      begin_new_amazon_format = Date.parse("2017-11-01")

      files = Dir[Rails.root.join('public', 'small', '*.csv')]
      jobs = files.map do |file|
        name = File.basename(file)
        date = Date.parse("#{name[0..6]}-01")
        header_lines_to_skip = date < begin_new_amazon_format ? 1 : 2
        url = asset_url("small/#{name}", skip_pipeline: true, host: host)
        
        KeywordsImportJob.perform_later(
          url: url,
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
