require 'dotenv/load'
require 'dropbox_api'
require "fileutils"
require 'csv'

client = DropboxApi::Client.new
INPUT_DIR = "input_files/"
PAPER_EXT = ".paper"
FileUtils.mkdir_p('logs')
CSV.open('logs/errorlog.csv', 'w', encoding: 'UTF-8') do |log_csv|
  log_csv << ['text', 'exception']
end
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
    begin
      raise Error
      File.open(item) do |file|
        client.paper_create("/#{peper_path}", file, import_format: :markdown )
      end
    rescue => exception
      CSV.open('../logs/errorlog.csv', 'a', encoding: 'UTF-8') do |log_csv|
        log_csv << ["create #{peper_path}", exception.to_s]
      end
    end
  end
end
