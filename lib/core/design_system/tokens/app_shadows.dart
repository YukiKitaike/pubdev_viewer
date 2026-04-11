import 'package:flutter/material.dart';

/// カードに適用するエレベーション風シャドウを返す。
///
/// [primary] にはテーマのプライマリカラーを渡す。
/// ダークモードではシャドウを使用しないため空リストを返す。
List<BoxShadow> cardElevatedShadow(Color primary, {bool isDark = false}) {
  if (isDark) {
    return const [];
  }
  return [
    BoxShadow(
      color: primary.withValues(alpha: 0.07),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
