require 'dotenv/load'
require 'dropbox_api'
require "fileutils"

client = DropboxApi::Client.new
INPUT_DIR = "input_files/"
PAPER_EXT = ".paper"

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
    peper_path = Pathname(item).sub_ext(PAPER_EXT)
    pp "create #{peper_path}"
    File.open(item) do |file|
      client.paper_create("/#{peper_path}", file, import_format: :markdown )
    end
  end
end
