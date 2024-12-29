#import "/book.typ": book-page

#show: book-page.with(title: "Typst公式のHTML出力機能")

= 調査対象

なんらかの形で最終的にHTMLへの出力ができるツールを探します。

変換対象のコードとして @変換対象のTypstコード を使用します。

#figure(caption: [変換対象のTypstコード(tmp.typ)],
  ```typ 
  #set text(11pt, lang: "ja")

  = neko

  *Hello World!*

  _hogefuga_

  #figure(caption: [figure test],
          image("tmp.png", alt: "tmp")
  ) <tmp_png>

  @tmp_png だよん。

  == tako

  $(v · ∇)v$
  ```
) <変換対象のTypstコード>

= 調査結果

+ Typst(開発中機能)

  未実装だがロードマップに登録されており @Typst_Roadmap_Typst_Documentation 、Tracking issueからもわかるように現在実装に向けて動いているようです @Typst_Tracking_issue_HTML_export 。
  一応 @TypstでHTMLエクスポート のようにして自分でビルドしてやれば使うことができます。
  ただ実行時に開発中の機能だぞと念押しされるのでリリースにはまだしばらくかかりそう。

  #figure(caption: [TypstでHTMLエクスポート],
    ```sh
    git clone https://github.com/typst/typst
    cd typst
    cargo build --release
    ./target/release/typst compile tmp.typ --features html --format html
    ```
  ) <TypstでHTMLエクスポート>

  #figure(caption: [@変換対象のTypstコード を変換したもの。imageが無視されている。],
    ```html
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
      </head>
      <body>
        <h2>
          neko
        </h2>
        <p>
          <strong>Hello World!</strong>
        </p>
        <p>
          <em>hogefuga</em>
        </p>
        <figure>
          <figcaption>
            図 1: figure test
          </figcaption>
        </figure>
        <p>
          図 1 だよん。
        </p>
        <h3>
          tako
        </h3>
        <p></p>
      </body>
    </html>
    ```
  ) <変換後HTML>

  @変換後HTML は変換後のHTMLコードですが基本的な変換はできてるので意外とすぐ公開されるかも？数式とかはちょっとわかりませんが。$(v · ∇)v$

+ Pandoc

  Pandocはドキュメントの表現形式を変換してくれる汎用的なツールです。
  具体的にはMarkdownをWordファイルにしてくれたりLaTeXをHTMLに変換してくれたりします。
  Typstにも対応している @Pandoc ので```sh pandoc --from typst --to html tmp.typ```って感じですぐ使えます。

  #figure(caption: [@変換対象のTypstコード を変換したもの],
    ```html
    <h1>neko</h1>
    <p><strong>Hello World!</strong></p>
    <p><em>hogefuga</em></p>
    <figure>
    <p><img src="tmp.png" alt="tmp" /></p>
    <figcaption><p>figure test</p></figcaption>
    </figure>
    <p><span id="tmp_png"></span></p>
    <p><a href="#tmp_png" class="ref">[tmp_png]</a> だよん。</p>
    <h2>tako</h2>
    <p><span class="math inline">(<em>v</em> ⋅ ∇)<em>v</em></span></p>
    ```
  )

+ shiroa

  Typst用の静的サイトジェネレーター(SSG)。
  Myriad-DreaminさんというTinymist、typst.tsの作者様が作成したものです。

= この文章で使うツール

  shiroaを使います。
  まあいい感じに整ってるSSGあるならそれ使うよね。

#bibliography("公開に使えるツール.bib")
