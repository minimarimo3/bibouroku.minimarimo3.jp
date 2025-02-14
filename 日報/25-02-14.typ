#import "/note.typ": 日報

#show : 本文 => 日報(
    執筆日: datetime(year: 2025, month: 02, day: 14),
    今日やること: [

    ],
    今日やったこと: [
        #grid(inset: 10pt,
            columns: (40%, 60%),
            align(center + horizon)[#image("25-02-14-task.jpg", alt: "2025-02-14 のタスク完了分布")],
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
