#import "/note.typ": 日報

#show : 本文 => 日報(
    執筆日: datetime(year: 2025, month: 02, day: 16),
    今日やること: [
        + ANTLRで基本的な文法を完成させる
        + 例とかを書いた
    ],
    今日やったこと: [
        #grid(inset: 10pt,
            columns: (40%, 60%),
            align(center + horizon)[#image("25-02-16-task.jpg", alt: "2025-02-16 のタスク完了分布")],
            align(horizon)[
            ],
        )
    ],
    今日あった嬉しかったこと: [

    ],
    明日やりたいこと: [

    ],
    その他: none
)
