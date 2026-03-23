#import "template.typ": project, d

#show: project.with(
  slug: "404",
  title: "404 Not Found",
  description: "お探しのページは見つかりませんでした。",
  authors: ("minimarimo3",),
  create: d(2025, 12, 12)
)

= ページが見つかりません

お探しのページは移動または削除された可能性があります。

#link("/")[トップページに戻る]
