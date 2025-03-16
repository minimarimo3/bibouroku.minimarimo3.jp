#import "@preview/shiroa:0.1.2": get-page-width, target, is-web-target, is-pdf-target, plain-text, templates, media
#import templates: *

#let TODOCounter = counter("minimarimo3:TODOCounter")
#let TODO = (con) => {
  TODOCounter.step()
  text(fill: red)[TODO #context TODOCounter.display(): #con]
}

#let page-width = get-page-width()
#let is-pdf-target = is-pdf-target()
#let is-web-target = is-web-target()

#let embedYT = (url, orig_width: 560, orig_height: 315) => {
  // 20ptはpageで設定したleftの値
  let width = (page-width - 20pt)
  let height = page-width * (orig_height / orig_width)

  // 操作不能になるバグを避けるためにカスタムcssを適用する必要があります
  //  .minimarimo3-embed-YT{position: absolute ; z-index: 2;}
  media.iframe(
    outer-width: width,
    outer-height: height,
    attributes: (
      class: "minimarimo3-embed-YT",
      src: url,
      frameborder: "0",
      allowfullscreen: "true",
      width: width,
      height: "100%"
    )
  )
}

// テーマ
#let (
  style: theme-style,
  is-dark: is-dark-theme,
  is-light: is-light-theme,
  main-color: main-color,
  dash-color: dash-color,
  code-extra-colors: code-extra-colors,
) = book-theme-from(toml("theme-style.toml"), xml: it => xml(it))

// フォント
#let main-font = (
  // sudo apt install fonts-noto-cjkで入るっぽい？
  "Noto Serif CJK JP",
  // "Charter",
  // "Source Han Serif SC",
  // "Source Han Serif TC",
  // shiroa's embedded font
  "Libertinus Serif",
)
#let code-font = (
  // "BlexMono Nerd Font Mono",
  // shiroa's embedded font
  "DejaVu Sans Mono",
)

// フォントのサイズ
#let main-size = if is-web-target {
  16pt
} else {
  10.5pt
}
#let heading-sizes = (26pt, 22pt, 18pt, 14pt, main-size)
#let list-indent = 0.5em

/// The project function defines how your document looks.
/// It takes your content and some metadata and formats it.
/// Go ahead and customize it to your liking!
#let project(title: "ﾐﾆﾏﾘﾓの備忘録", authors: ("minimarimo3"), kind: "page", body) = {

  // set basic document metadata
  set document(
    author: authors,
    title: title,
  ) if not is-pdf-target

  // set web/pdf page properties
  set page(
    numbering: none,
    // numbering: (..args) => {counter(page).update(none)},
    number-align: center,
    width: page-width,
  )

  // remove margins for web target
  set page(
    margin: (
      // reserved beautiful top margin
      top: 20pt,
      // reserved for our heading style.
      // If you apply a different heading style, you may remove it.
      left: 20pt,
      // Typst is setting the page's bottom to the baseline of the last line of text. So bad :(.
      bottom: 0.5em,
      // remove rest margins.
      rest: 0pt,
    ),
    height: auto,
  ) if is-web-target

  // Set main text
  set text(
    font: main-font,
    size: main-size,
    fill: main-color,
    lang: "ja",
  )

  // Set main spacing
  set enum(
    indent: list-indent * 0.618,
    body-indent: list-indent,
  )
  set list(
    indent: list-indent * 0.618,
    body-indent: list-indent,
  )
  set par(leading: 0.7em)
  set block(spacing: 0.7em * 1.5)

  // 画像にはキャプション（alt）を必ずつける
  //  ただし、24-12-29時点ではaltが反映されないようです
  show image: it => {
    return {
      if it.alt == none {
        TODO("画像にはキャプションをつける必要があります")
      }
      it
    }
  }

  // 表のキャプションを上に変更
  show figure.where(kind: table): set figure.caption(position: top)

  // コードのサプリメント？（図とか表ってやつ）はコード
  show figure.where(kind: raw): set figure(supplement: "コード")

  // 引用はsist02形式で行う
  set bibliography(style: "sist02")


  // 脚注と本文の合間を.の繰り返しで表現
  set footnote.entry(separator: repeat[.])

  // 見出しにインデントをつける。ページ数とかは非表示
  //  https://typst.app/docs/reference/model/outline/#:~:text=Building%20an%20outline%20entry%20from%20its%20parts
  show outline.entry: it => link(
    it.element.location(),
    it.indented(it.prefix(), it.body()),
  )

  set heading(numbering: "1.")
  // 見出しの左側に#をつける。あとサイズを合わせる
  show heading: set text(weight: "bold") if is-web-target
  show heading: it => {
    let it = {
      set text(size: heading-sizes.at(it.level))
      if is-web-target { 
        place(left, dx: -20pt)[\#]
      }
      it
    }

    block(
      spacing: 0.7em * 1.5 * 1.2,
      below: 0.7em * 1.2,
      it,
    )
  }

  // リンクの色変更
  show link: set text(fill: dash-color)
  // リンクにはアンダーラインを引く
  show link: underline

  // math setting
  show math.equation: set text(weight: 400)

  // コードブロックの設定
  show raw: it => {
    set text(font: code-font)
    if "block" in it.fields() and it.block {
      rect(
        width: 100%,
        inset: (x: 4pt, y: 5pt),
        radius: 4pt,
        fill: code-extra-colors.bg,
        [
          // コードを左寄せ
          #set align(left)
          #set text(fill: code-extra-colors.fg) if code-extra-colors.fg != none
          #set par(justify: false)
          // 言語を右端に表示
          #place(right, text(luma(110), it.lang))
          #it
        ],
      )
    } else {
      it
    }
  }

  outline()

  repeat([.])

  // Main body.
  set par(justify: true)

  body
}

#let part-style = heading
