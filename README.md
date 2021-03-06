# Firebase Sampler

## 概要
2016年5月からアップデートされたFirebaseで、Auth Database Push通知を実装しています。

### 開発環境
Xcode 8.0

OS X 10.11.5

Firebase 3.7.1

Firebase Database 3.7.1

Firebase Auth 3.0.5

## 仕様
### 画面構成
SignupViewControllerあるいは、LoginViewControllerが最初の画面となります。ログイン状態なら、そのままListViewControllerに遷移するようになっています。データの追加はListViewControllerの右上のプラスボタンからViewControllerに遷移することで、textfieldから文字をPOSTすることができます。

### Auth
EmailとPasswordでユーザー認証が可能になっています。

### Database
#### CREATE
ViewControllerクラスのcreate()という関数でtextfieldに打ち込んだ文字をユーザーのTokenと日時と一緒に送信しています。

DatabaseのDB設計としては、
ユーザーのTokenをIDとして、そこからViewControllerのcreate()関数で送られたデータをコレクションとして保存しています。

#### READ
ListViewControllerのread()関数で自身のPOSTしたデータのみを読み込んでいます。

それぞれをTableViewで表示しています。

FIRDataEventTypeをValueにすることで、すべての変化に対して対応しています



#### UPDATE
ViewControllerのupdate関数でデータベース上の該当のデータを更新しています。

isCreateで更新か作成かをBoolで判断しています。
post関数でisCreateがどちらかによってcreateとupdateを切り替えてます

#### DELETE
ListViewControllerに実装しているdelete関数をtableview(tableview:commitEditingStyle)の中で呼び出し、NSIndexPathを渡すことで、該当するデータをDatabaseから削除しています。


### Push通知
Firebaseのコンソールからプッシュ通知を送ることができます。また、未読のプッシュ通知の数はバッジで表示します。

未読かどうか、プッシュ通知の一覧をTableViewで表示する機能などは今後実装予定です。

## Pull Request
まだまだ理解ができていない部分が多いので、プルリクエスト大歓迎です。
プルリクエストお待ちしております。
