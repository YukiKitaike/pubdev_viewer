---
name: pubdev-state
description: >
  pubdev_viewer の Riverpod AsyncNotifier パターン。
  状態管理・ページネーション（loadMore）・リフレッシュ・並列 API コール・エラーハンドリングを
  実装する際に使用。「Notifier を書いて」「状態管理」「loadMore」「refresh」
  「ref.watch」と言われたときに参照。
---

# Riverpod 状態管理パターン（pubdev_viewer）

このアプリは `riverpod_generator` の `@riverpod` アノテーションを使用。
`StateNotifier`・`ChangeNotifier`・bare `Provider` は feature で使わない。

---

## 基本パターン: AsyncNotifier

`build()` が非同期初期ロードを担う。Riverpod が自動で `AsyncValue<T>` にラップする。

```dart
// lib/features/package_list/notifiers/package_list_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_list_state.dart';
import '../repository/package_list_repository.dart';

part 'package_list_notifier.g.dart';

@riverpod
class PackageListNotifier extends _$PackageListNotifier {
  @override
  Future<PackageListState> build() async {
    final repository = ref.watch(packageListRepositoryProvider); // build() 内は watch
    final response = await repository.getPackages();
    return PackageListState(
      packages: response.packages,
      nextUrl: response.nextUrl,
    );
  }
}
```

実際のファイル: [lib/features/package_list/notifiers/package_list_notifier.dart](lib/features/package_list/notifiers/package_list_notifier.dart)

---

## 詳細パターン

以下の詳細な実装例は [advanced_patterns.md](references/advanced_patterns.md) を参照:

- パラメータ付き Notifier（Family vs ProviderScope override）
- 並列 API コール（`.wait` パターン）
- ページネーション（loadMore パターン）
- リフレッシュ / エラーのクリア
- Screen 側のパターン（ref.watch / ref.listen）

---

## ルール早見表

| 場面 | 使うもの |
|------|----------|
| `build()` 内で依存取得 | `ref.watch(...)` |
| `build()` 以外のメソッド | `ref.read(...)` |
| 副作用（Snackbar 等） | `ref.listen(...)` |
| 全リフレッシュ | `ref.invalidateSelf()` / `ref.invalidate(provider)` |
| 別 provider の強制再ロード | `ref.invalidate(otherProvider)` |

---

## やってはいけないこと

```dart
// ❌ メソッド内で ref.watch（build() 以外での watch は禁止）
Future<void> loadMore() async {
  final repo = ref.watch(repositoryProvider); // NG
}

// ❌ 順次 await（独立した呼び出しを直列化しない）
final detail = await repository.getDetail(name);
final publisher = await repository.getPublisher(name); // 並列にすべき

// ❌ Either<Failure, T> パターン（例外を使う）
// ❌ StateNotifier や ChangeNotifier の使用
```

---

### WHY コメントの典型例

- `ref.read` vs `ref.watch` の使い分け理由
- エラーを `AsyncData` 内に保持する理由（`AsyncError` にしない理由）
- `keepAlive: true` の理由
