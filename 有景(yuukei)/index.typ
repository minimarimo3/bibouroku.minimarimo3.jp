#import "../template.typ": project, note, note, tip, important, warning, caution, env
#import "../posts.typ": post-data
// #let meta = post-data.at("有景(yuukei)")
// #show: project.with(..meta)

= 実装すること

== 基本

- [ ] デスクトップに矩形表示
  - [x] Windows
  - [ ] macOS(未確認。多分OK)
  - [ ] Linux
- [ ] 画面
  - [ ] 現在ロード中のキャラについての画面
  - [ ] 設定画面
  - [ ] アプリ情報画面(バージョン等)
- [ ] ユーザーが用意したデータのロード
  - [-] VRM
    - [x] ファイルから直接
    - [ ] VRoidHubから
  - [ ] モーションデータ
    - [ ] VRMA
    - [ ] BVH(?)
  - [ ] ゲームオブジェクト
    - [ ] AssetBundle
  - [ ] EneScript
  - [ ] C\#のロード？MOD？他アプリとの連携等を考えたとき、EneScriptでは不十分なのでプログラミング言語を実行できるようにする必要がある。
- [ ] 基本的なモーション

== 実装すべき機能

- [ ] 画面認識
- [ ] 端末間の同期
- [ ] AIによるチャット
- [ ] リマインダー、他アプリとの連携

