#import "/note.typ": 日報

#show : 本文 => 日報(
    執筆日: datetime(year: 2025, month: 02, day: 15),
    今日やること: [
        + 融景のDSLの設計をする(ANTLR4?Lark?)
        + 融景に関する備忘録を書く
    ],
    今日やったこと: [
        #grid(inset: 10pt,
            columns: (40%, 60%),
            align(center + horizon)[#image("25-02-15-task.jpg", alt: "2025-02-15 のタスク完了分布")],
            align(horizon)[
                + ANTLR4でコードを書き直してた
                
                    VSCode拡張が超便利。エラーが一目でわかるし最初からこれ使っとけばよかった。
                    #image("25-02-15-fig1.png", alt:"グラフ")
            ],
        )
    ],
    今日あった嬉しかったこと: [
        + 苺のショートケーキ食べた
    ],
    明日やりたいこと: [
        ANTLR4のみの実装をちゃんと終わらせる。
    ],
    その他: none
)
