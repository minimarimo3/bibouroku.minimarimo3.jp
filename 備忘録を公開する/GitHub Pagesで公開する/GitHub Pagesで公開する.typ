#import "/book.typ": book-page, media, cross-link, heading-reference

#show: book-page

= 公開用コード

このブログで使ってるコードです。

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
          # https://docs.github.com/ja/actions/using-github-hosted-runners/using-github-hosted-runners/customizing-github-hosted-runners#:~:text=%E5%B8%B8%E3%81%AB%E5%AE%9F%E8%A1%8C%E3%81%97%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84
          sudo apt -qq update
          sudo apt -qq install -y fonts-noto-cjk

      - name: 最新の shiroa をダウンロード
        run: |
          wget -q https://github.com/Myriad-Dreamin/shiroa/releases/latest/download/shiroa-x86_64-unknown-linux-gnu.tar.gz
          tar --totals -xzf shiroa-x86_64-unknown-linux-gnu.tar.gz
          sudo mv shiroa-x86_64-unknown-linux-gnu/shiroa /usr/local/bin/

      - name: book.typ ファイルの検索と処理
        run: |
          find . -name book.typ -execdir bash -c '
            parent_dir=$(basename $(pwd))
            shiroa build --allowed-url-source ".*" --path-to-root "/$parent_dir/";
            echo ".minimarimo3-embed-YT{position: absolute ; z-index: 2;}" >> dist/theme/css/general.css;
            rm -rf "../public/$parent_dir";
            mkdir -p "../public/$parent_dir";
            mv dist/* "../public/$parent_dir/";
          ' bash {} \;

      - name: Pythonのセットアップ
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'  # https://github.com/actions/runner-images/issues/10636#:~:text=Python 3.13はキャッシュされていないため、3.12を使用
          cache: 'pip'

      # キャッシュが確実に効くようにバージョンを指定
      - run: pip install -r requirements.txt

      - name: トップページ生成
        run: python3 generator.py

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
