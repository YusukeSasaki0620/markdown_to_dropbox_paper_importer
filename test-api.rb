require 'dotenv/load'
require 'dropbox_api'

client = DropboxApi::Client.new
binding.irb
client.create_folder("/hoge")
