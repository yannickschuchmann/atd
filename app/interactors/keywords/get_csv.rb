module Keywords
  class GetCSV
    include Interactor

    def call
      context.fail!(error: "No drive_file_id or url given") if (context.drive_file_id || context.url).blank?

      file = Tempfile.new("keywords_import_#{Time.now.to_i}.csv")
      file.binmode

      if context.drive_file_id.present?
        drive = DriveService.new
        io = StringIO.new

        drive.download_file(file_id: context.drive_file_id, destination: io)
        io.rewind
        file.write(io.read)
      else
        file.write(HTTParty.get(context.url).body)
      end

      context.csv_file = file
    rescue => exception
      puts exception
      context.fail!(error: "Couldn't fetch CSV file")
    end
  end
end
