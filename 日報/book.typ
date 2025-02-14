/*
#import "/note.typ": 日報

#show : 本文 => 日報(
  執筆日: datetime(year: 2025, month: 01, day: ),
  今日やること: [

  ],
  今日やったこと: [

  ],
  今日あった嬉しかったこと: [

  ],
  明日やりたいこと: [

  ],
  その他: none
)
*/

#import "@preview/shiroa:0.1.2": *

#show: book


#let n = (date, emoji: none) => {
  return chapter(section: none, str(date) + ".typ", date + emoji)
}

#book-meta(
  title: "日報",
  summary: [
    #prefix-chapter(none, "日報")

    = 2025
    #n("25-02-15", emoji:"")
  ]
)


// re-export page template
#import "/templates/page.typ": project, embedYT
#let book-page = project
