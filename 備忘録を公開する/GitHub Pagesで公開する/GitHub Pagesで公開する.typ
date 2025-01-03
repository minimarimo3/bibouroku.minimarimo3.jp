#import "/book.typ": book-page, media, cross-link, heading-reference

#show: book-page

= 公開用コード

このブログで使ってるコードからPythonの設定等を捨てたものです。

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main  # メインブランチへのプッシュ時に実行
  workflow_dispatch:  # 手動実行を許可

permissions:
  pages: write  # GitHub Pagesへの書き込み権限
  id-token: write  # OIDCトークンの権限（`deploy-pages`用）

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: リポジトリのチェックアウト
        uses: actions/checkout@v3

      - name: 必要なツールのインストール
        run: |
          sudo apt-get update -qq
          sudo apt-get install -y fonts-noto-cjk

      - name: 最新の shiroa をダウンロード
        run: |
          wget https://github.com/Myriad-Dreamin/shiroa/releases/latest/download/shiroa-x86_64-unknown-linux-gnu.tar.gz
          tar -xzf shiroa-x86_64-unknown-linux-gnu.tar.gz
          sudo mv shiroa-x86_64-unknown-linux-gnu/shiroa /usr/local/bin/

      - name: book.typ ファイルの検索と処理
        run: |
          find . -name book.typ -execdir bash -c '
            parent_dir=$(basename $(pwd))
            shiroa build --allowed-url-source ".*" --path-to-root "/$parent_dir/";
            echo ".minimarimo3-embed-YT{position: absolute ; z-index: 2;}" >> dist/theme/css/general.css;
            mkdir -p "../public/$parent_dir";
            mv dist/* "../public/$parent_dir/";
          ' bash {} \;

      - name: GitHub Pages 用の設定
        run: |
          touch public/.nojekyll

      - name: upload to GitHub Pages
        uses: actions/upload-pages-artifact@v3
        with:
            path: ./public
    
  deploy:
    needs: build
    runs-on: ubuntu-latest

    steps:
    - name: Deploy to GitHub Pages
      uses: actions/deploy-pages@v4
```
