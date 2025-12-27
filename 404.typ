#import "template.typ": project

#show: project.with(
  title: "404 Not Found",
  description: "お探しのページは見つかりませんでした。",
  authors: ("minimarimo3",),
  create: datetime(year: 2025, month: 12, day: 12)
)

= ページが見つかりません

お探しのページは移動または削除された可能性があります。

#link("/")[トップページに戻る]
