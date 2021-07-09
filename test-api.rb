require 'dotenv/load'
require 'dropbox_api'
require "fileutils"

client = DropboxApi::Client.new
INPUT_DIR = "input_files/"

# begin
#   client.create_folder("/hoge")
# rescue DropboxApi::Errors::FolderConflictError => exception
#   pp 'folder exsist. continue.'
# end


Dir.chdir(INPUT_DIR)
Dir.glob("**/*") do |item|
  pp "find [ #{item} ]"
  if FileTest.directory?(item)
    begin
      client.create_folder("/#{item}")
      pp "folder [ #{item} ] create."
    rescue DropboxApi::Errors::FolderConflictError => exception
      pp "folder [ #{item} ] exsist. continue."
    end
  else

  end
end
