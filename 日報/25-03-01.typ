#import "/note.typ": 日報
#import "/templates/page.typ": embedYT

#show : 本文 => 日報(
    執筆日: datetime(year: 2025, month: 03, day: 01),
    今日やること: [
        + 化物語について調べて1話を見てみる
        
            #embedYT("https://www.youtube.com/embed/Jj1_mfUzjOs?si=xmPVndWr4vsWpgfW")

        + ANTLRのvisitorだかlistenerだか実装
    ],
    今日やったこと: [
    ],
    今日あった嬉しかったこと: [
    ],
    明日やりたいこと: [
    ],
    その他: none
)
