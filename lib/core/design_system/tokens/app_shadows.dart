import 'package:flutter/material.dart';

// ダークモードでは背景が暗くシャドウが視認できないため描画しない。ボーダーで立体感を出す。
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
