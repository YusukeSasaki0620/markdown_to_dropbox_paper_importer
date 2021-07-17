require 'dotenv/load'
require 'dropbox_api'
require "fileutils"
require 'csv'
require 'thread'

client = DropboxApi::Client.new
INPUT_DIR = "input_files/"
FileUtils.mkdir_p(INPUT_DIR)
PAPER_EXT = ".paper"
FileUtils.mkdir_p('logs')
CSV.open('logs/errorlog.csv', 'w', encoding: 'UTF-8') do |log_csv|
  log_csv << ['text', 'exception']
end

dirs = []
md_files = []

Dir.chdir(INPUT_DIR)
Dir.glob("**/*") do |item|
  pp "find [ #{item} ]"
  if FileTest.directory?(item)
    dirs << "/#{item}"
  else
    md_files << item
  end
end

pp "dirs_count: #{dirs.size}"

dirs.each_with_index do |dir_path, i|
  begin
    FileUtils.mkdir_p("../done_files#{dir_path}")
    client.create_folder(dir_path)
    pp "#{i} : folder [ #{dir_path} ] create."
  rescue DropboxApi::Errors::FolderConflictError => exception
    pp "#{i} : folder [ #{dir_path} ] exsist. continue."
  end
end

pp "md_files_count: #{md_files.size}"

md_files.each_with_index do |md_file, i|
  peper_path = Pathname(md_file).sub_ext(PAPER_EXT)

  begin
    File.open(md_file) do |file|
      client.paper_create("/#{peper_path}", file, import_format: :markdown )
    end
    FileUtils.mv(md_file, "../done_files/#{md_file}")
    pp "#{i} : create #{peper_path}"
  rescue => exception
    CSV.open('../logs/errorlog.csv', 'a', encoding: 'UTF-8') do |log_csv|
      log_csv << ["create #{peper_path}", exception.to_s]
    end
    pp "#{i} : failed #{peper_path}"
  end
end

pp "finish"
