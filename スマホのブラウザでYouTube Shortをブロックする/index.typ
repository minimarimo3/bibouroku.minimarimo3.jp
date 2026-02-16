#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
#let meta = post-data.at("スマホのブラウザでYouTube Shortをブロックする")
#show: project.with(..meta)

#env(
  ("Vivaldiブラウザ", "7.8.3931.96", "Android"),
)

= 使い方

Vivaldiブラウザの設定から「トラッカー・広告ブロック」→「個別設定」または「トラッカーブロックソース管理」を選択（どっちでも大丈夫。両方やる必要はありません。）→「新しいソースを追加」を押して出てきた入力欄に下のURLを貼り付けてインポート。

```
https://gist.githubusercontent.com/minimarimo3/dc12d0ed2317da31cb68aa46657ad5b2/raw/12b3f4327e701d8df89ac10a791152e2017d9156/gistfile1.txt
```

これでYouTubeを開いた後一回再読み込みすることでショート動画が消えるようになります。

・・・まあ目の前に面白そうなショート動画があるのにそれを無視してページをリロードできるような奴らはそもそもショート動画を見すぎて困ったりしねぇだろってことでこれも修正します。
Vivaldiブラウザの設定から「プライバシーと設定」→「ページをプリロードする」を「プリロードなし」に変更する。
これにより、ページの読み込みは少し遅くなりますがブラウザでYouTubeを開いたとしてもショート動画が表示されることはなくなるはずです！

多分広告ブロック機能あるほかのブラウザ(Opera、Braveとか？)でもおんなじ感じでできるとは思う。知らんけど。
