# Flutter / Widget Tips

## 15. 専用ウィジェットを使う

`Container` の代わりに目的に合ったウィジェットを選ぶ。

```dart
// NG → OK
Container(padding: p, child: c)          → Padding(padding: p, child: c)
Container(color: color, child: c)        → ColoredBox(color: color, child: c)
Container(decoration: d, child: c)       → DecoratedBox(decoration: d, child: c)
Container(width: w, height: h, child: c) → SizedBox(width: w, height: h, child: c)
Container(alignment: center, child: c)   → Center(child: c)

// decoration + padding の組み合わせ
Container(decoration: d, padding: p, child: c)
→ DecoratedBox(decoration: d, child: Padding(padding: p, child: c))

// width/height + decoration
Container(width: w, height: h, decoration: d)
→ SizedBox(width: w, height: h, child: DecoratedBox(decoration: d))
```

**例外:** `decoration` + `padding` + `width` の複合使用は `Container` 維持も可。

## 16. Sliver プレフィックス

Sliver を返すウィジェットには `Sliver` プレフィックスを付ける。

## 17. Widget クラス分離

ウィジェットを返すメソッド (`buildXxx()`) ではなく専用クラスに切り出す。

## 18. build() 内で重い計算をしない

`initState` / `didUpdateWidget` / notifier で事前計算する。

## 19. `compute()` で重い処理を別 Isolate に逃がす

UI フリーズ防止。
