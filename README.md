# markdown to dropbox paper importer
ローカルのmdテキストファイルをDropboxPaperとしてアップロードするツール

## 準備
- [dropbox app Console](https://www.dropbox.com/developers/apps)でアプリを作成
  - `access type`は`Full Dropbox` (2021/07/17現在paper_create_apiが[AppFolder権限未対応](https://www.dropbox.com/developers/documentation/http/documentation#files-paper-create)のため)
- `permissions` -> `files.content.write` をチェック -> `Generated access token`
- `.env` に トークンをセット

## 動作

### input
- `input_files`ディレクトリ配下にimportしたいmdテキストを配置
- ディレクトリ構造をそのままdropboxへインポートできる

### 実行
```
bundle exec ruby md2paper_import.rb
```

### output
- console
  - infoログが流れる
  - 気長に待ってください
- `logs/errorlog.csv`
  - エラーが発生したら記録される
- `done_files`配下
  - 作成完了したinput_filesがこの配下に移動
  - 作成失敗したものは移動しないのでerrorlog見て修正し再実行

## 備考
- 連続でpostしているとpaper作成に失敗することがある（400エラー、通信状況？）
  - 再実行すると成功する
- 同名ファイルを再実行すると別名ファイルとしてpaperが作成されるので注意
  - 2021/07/17現在[folder_create_api](https://www.dropbox.com/developers/documentation/http/documentation#files-create_folder)の`autorename`オプションのようなものが無いため
  - フォルダは上記オプションにより、重複作成せずスキップする
- 並列実行で高速化できるのでは？
  - 2021/07/17時点2並列ですらAPI実行時にエラーにとなることを確認、気長に実行してください
  - 並列数分アクセストークンを発行すればいけるかも？
