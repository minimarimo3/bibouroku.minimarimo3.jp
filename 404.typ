#import "template.typ": project

#show: project.with(
  title: "404 Not Found",
  description: "お探しのページは見つかりませんでした。",
  authors: ("minimarimo3",),
  // 404ページには日付などは不要
)

= ページが見つかりません

お探しのページは移動または削除された可能性があります。

#link("/")[トップページに戻る]
