require 'google/apis/drive_v3'

class DriveService
  attr_reader :drive

  def initialize
    @drive = ::Google::Apis::DriveV3::DriveService.new
    @drive.authorization = ::Google::Auth::ServiceAccountCredentials.make_creds(
      scope: 'https://www.googleapis.com/auth/drive'
    )
  end

  def get_files(folder_name:, mime_type:)
    folder = drive.list_files(q: "name contains '#{folder_name}'").files.first
    drive.list_files(q: "mimeType contains '#{mime_type}' and '#{folder.id}' in parents").files
  end

  def download_file(file_id:, destination:)
    drive.get_file(file_id, download_dest: destination)
  end
end
