/*
#n(
  2025, 12, 27,
  [

  ],
  [

  ],
  [
    
  ]
)
*/

#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
#let meta = post-data.at("日記")
#show: project.with(..meta)



#let n(
  y, m, d,   // 年, 月, 日 (数字でOK)
  goal,      // 目標 (文字列 or 配列)
  progress,  // 進捗 (文字列 or 配列)
  thoughts,  // 感想 (文字列 or 配列)
  body: none       // 自由記述エリア
) = {
  let date = datetime(year: y, month: m, day: d)

  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em),
    stroke: (left: 4pt),
    breakable: true, // ページまたぎを許可
    {
      // ヘッダー (日付)
      heading(level: 2, numbering: none)[#date.display("[year]年[month]月[day]日の日記")]
      v(0.5em)
      
      // グリッドレイアウト
      grid(
        columns: (auto, 1fr),
        gutter: 1em, // 列と行の間隔
      )

      heading(level: 3, outlined: false, numbering: none)[🎯 目標]
      goal
      parbreak()

      heading(level: 3, outlined: false, numbering: none)[📈 進捗]
      progress
      parbreak()

      heading(level: 3, outlined: false, numbering: none)[💭 感想]
      thoughts
      parbreak()
      
      // 自由記述エリアがあれば表示
      if body != none  {
        parbreak()
        body
      }
    }
  )
  parbreak()
}

= 日記

#n(
  2025, 12, 27,
  [
    + nijimiの書き直し
  ],
  [

  ],
  [

  ]
)
