# 仕様
大きく分けて二つの画面を持つ App を作成します。
表示する要素については増やしていただくのは構いません（例: Home で `name` 以外に最新の `version` も表示するなど）。
---

## API

この App では pub.dev の API を使用します。

- https://pub.dev/help/api
- https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md

API スキーマの詳細は [openapi.yaml](openapi.yaml) を参照してください。

---

## 画面仕様

### Home

- `GET /api/packages` から取得した package 一覧の `name` を表示する。
- 表示はスクロール可能とし、取得した内容を全件閲覧できるようにする。
- List item を tap すると Details 画面へ遷移する。

---

### Details

tap された item の `name` を元に、以下の情報を取得する。

| API | 用途 |
|-----|------|
| `GET /api/packages/{name}` | package の詳細情報 |
| `GET /api/packages/{name}/publisher` | publisher 情報 |

#### Navigation Bar

- タイトルとして `name` を表示する。
- Action として外部リンクアイコンを表示する。
  - tap すると外部ブラウザで URL を開く。URL の優先順位は以下の通り。
    1. `PackageDetails.latest.pubspec.homepage`
    2. `PackageDetails.latest.pubspec.repository`（homepage がない場合）
    3. どちらもない場合は、アイコンを表示しない。

#### Overview セクション

- 内容を Border で囲む（color、width などは自由）。
- `PackageDetails.latest.pubspec.description` を表示する。
- `PackagePublisher.publisherId` を description の下部に右寄せ（`end`）で表示する。

#### Versions セクション

- 内容を Border で囲む（color、width などは自由）。
- `PackageDetails.versions` から全 `version` を表示する。
- 最新バージョンが最上部になるよう sort する。
- 表示はスクロール可能とし、取得した内容を全件閲覧できるようにする。

---

## Challenge

- [ ] 読み込み中に Loading インジケーターを表示する。
- [ ] 機内モードなど、取得時に Error が発生した際にその旨を表示する。
- [ ] 再試行可能な手段を User に提供する。
- [ ] Pull-to-refresh を実装する。
- [ ] Home で `next_url` を使用した paging を実装する。
- [ ] Unit tests / Widget tests / Golden tests を実装する。
