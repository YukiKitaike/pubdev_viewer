import 'package:flutter/material.dart';

const _shadowAlpha = 0.07;
const _blurRadius = 8.0;
const _offsetY = 2.0;

/// カード用の微細なシャドウを返す。
/// ダークモードでは背景が暗くシャドウが視認できないため空リストを返し、ボーダーで立体感を出す。
List<BoxShadow> cardElevatedShadow(Color primary, {bool isDark = false}) {
  if (isDark) {
    return const [];
  }
  return [
    BoxShadow(
      color: primary.withValues(alpha: _shadowAlpha),
      blurRadius: _blurRadius,
      offset: const Offset(0, _offsetY),
    ),
  ];
}
