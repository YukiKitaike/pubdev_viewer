# UI/UX 改善タスク

iOS HIG および Android Material Design 3 の審査結果に基づく改善一覧。  
対応済みのものには ✅ を付ける。

---

## Priority 1 — 高影響・低コスト

### C1. ✅ ハプティックフィードバックの追加
- **根拠**: iOS HIG 必須、MD3 推奨
- **対象**: `package_list_tile.dart` のタップ時、`error_view.dart` のリトライボタン
- **対応**: タップ確定時に `HapticFeedback.lightImpact()` を呼び出す
- **ステータス**: 対応済み

---

### C2. ✅ ボトムセーフエリア対応
- **根拠**: iOS ホームインジケーター (34pt) の下にコンテンツが隠れる
- **対象**:
  - `package_list_screen.dart` — ListView の `padding: bottom: 16` が固定値
  - `package_detail_screen.dart` — Column 末尾の `Gap(16)` が固定値
- **対応**: `MediaQuery.paddingOf(context).bottom` を bottom padding に加算
- **ステータス**: 対応済み

---

### a1. ✅ Android Predictive Back Gesture 対応
- **根拠**: Android 13+ の戻るジェスチャー標準対応
- **対象**: `android/app/src/main/AndroidManifest.xml`
- **対応**: `<activity>` タグに `android:enableOnBackInvokedCallback="true"` を追加
- **ステータス**: 対応済み

---

### i1. ✅ トレーリング・シェブロン（›）の追加
- **根拠**: iOS HIG — ナビゲーション可能なリスト行には開示インジケーター必須
- **対象**: `package_list_tile.dart` — タップで詳細画面に遷移するが視覚的手がかりがない
- **対応**: Row 末尾に `Icon(Icons.chevron_right, size: 16, color: onSurfaceVariant.withOpacity(0.5))` を追加
- **ステータス**: 対応済み

---

### C3. ✅ リップルエフェクトの復元
- **根拠**: MD3 state layers — `GestureDetector` のみではマテリアルリップルが出ない
- **対象**: `package_list_tile.dart` 全体
- **対応**: `DecoratedBox` + `Material(transparent)` + `InkWell` でラップし、`AnimatedScale` も維持。`onHighlightChanged` で scale アニメーションを制御
- **ステータス**: 対応済み

---

## Priority 2 — 中影響

### a2. ✅ タッチターゲットの拡大
- **根拠**: MD3 最小 48dp / iOS HIG 最小 44pt
- **対象**: `package_list_tile.dart` のアバター (40×40 → 44×44)
- **対応**: アバターサイズを 44×44、borderRadius を 11 に変更
- **ステータス**: 対応済み

---

### a3. ✅ scrolledUnderElevation を MD3 標準値に調整
- **根拠**: MD3 推奨値は 3.0（旧: 1 で視認性が低い）
- **対象**: `lib/app/theme.dart` の `AppBarTheme`
- **対応**: `scrolledUnderElevation: 1` → `scrolledUnderElevation: 3`
- **ステータス**: 対応済み

---

### i2. ✅ スクロール物理モデルのプラットフォーム適応
- **根拠**: iOS HIG — バウンスが自然なスクロール体験を提供
- **対象**: `package_detail_screen.dart` の `SingleChildScrollView`
- **対応**: `TargetPlatform.iOS` の場合は `BouncingScrollPhysics`、それ以外は `ClampingScrollPhysics` に切り替え（両方 `AlwaysScrollableScrollPhysics` でラップ）
- **ステータス**: 対応済み

---

## Priority 3 — 低影響・高コスト（将来対応）

### i3. Large Title AppBar の実装
- **根拠**: iOS HIG — トップレベル画面でのスクロール連動大タイトルが標準
- **対象**: `package_list_screen.dart`
- **対応**: `SliverAppBar.large()` + `CustomScrollView` に変更
- **ステータス**: 将来対応

---

## 変更履歴

| 日付 | 対応内容 |
|------|--------|
| 2026-04-11 | Priority 1〜2 の全項目（C1〜C3, a1〜a3, i1〜i2）を対応完了 |
