/*
このTypstテンプレートは @minimarimo3@misskey.io によって作成され、 WTFPL(Do What The Fuck You Want To Public License) に従って配布されています。連絡は @minimarimo3@misskey.io (Misskey) か @katayaura (X) にどうぞ。
*/

#let TODOCounter = counter("TODOCounter")
#let TODO = (con) => {
  TODOCounter.step()
  text(fill: red)[TODO #TODOCounter.display(): #con]
}

#let configuration(
  主題: none, 
  タグ: (), 
  要約: TODO[要約], 
  本文) = [

#let 氏名 = "minimarimo3"
#let 最終更新日 = datetime.today()

// 文書の設定
// 明朝フォント(見出し以外の本文に使用する)
#let 明朝フォント = ("Yu Mincho", "Hiragino Mincho Pro", "MS Mincho", "Harano Aji Mincho")
// ゴシックフォント(見出しに使用する)
#let ゴシックフォント = ("Yu Gothic", "Hiragino Kaku Gothic Pro", "Meiryo", "MS Gothic", "Harano Aji Gothic")

// 表のキャプションを上に変更するときに使う
#show figure.where(
  kind: table
): set figure.caption(position: top)

// リンクにはアンダーラインを引く
#show link: underline

#show figure.where(
  kind: raw
): set block(breakable: true)

// 引用時にブロックで囲む
#set quote(block: true)

// 画像にはキャプション（alt）を必ずつける
#show image: it => {
  return {
    if it.alt == none {
      TODO("画像にはキャプションをつける必要があります")
    }
    it
  }
}

// PDFのメタデータを設定
#set document(title: 主題, author: 氏名, date: 最終更新日, keywords: タグ)
// ページのサイズや余白。
#set page(margin: 20mm, paper: "a4", numbering: "1")

// > 見出し以外の本文は明朝体フォント(MS明朝など)で、11ポイントで書くこと
#set text(11pt, font: 明朝フォント, lang: "ja")

// 引用のスタイルをsist02にする
#set bibliography(style: "sist02")

#set enum(numbering: "1.い.")

// 見出しを設定
#set heading(numbering: "1.")
#show heading: it => locate(loc => {
    let levels = counter(heading).at(loc)
    let gothic = (txt) => {
      // > 見出しはゴシックフォントで、12ポイントで書くこと
      return text(font: ゴシックフォント, size: 12pt)[*#txt*]
    }
    if it.body in ([参考文献], [付録]) {
      return gothic(it.body)
    }
    if levels.len() == 1{
      return gothic(numbering("1.", ..levels) + " " + it.body)
    }
    return gothic(numbering("1.1", ..levels) + " " + it.body)
})

// 左ぞろえ
#set align(left)

// 文書の設定終わり

// 1枚目。フォントサイズはWord版テンプレートに合わせとく
#align(center, text(20pt)[
  *#主題*
])
#linebreak()

// フォントサイズはWord版テンプレートに合わせとく
#align(center, text(10pt)[
  この文章は #氏名 が書きました。最終更新日は #最終更新日.display("[year]年 [month]月 [day]日")です。
])
#linebreak()

// 要約
#align(center)[*要約*]

#要約

#linebreak()
#linebreak()

#align(center)[*目次*]

#outline(title: none, indent: auto)

#linebreak()
#linebreak()

#本文

]

/* 使い方
report.typとかから
#import "template.typ": configuration, TODO
#show: 本文 => configuration(主題: "", 参考文献のパス: "reference.bib", 最終更新日: datetime(year: 2024, month: 08, day: 30), 要約: [
  要約を書く
], 本文)
ここから本文を書いていく
*/
