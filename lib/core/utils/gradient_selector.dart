import 'dart:ui';

import 'package:pubdev_viewer/core/design_system/design_system.dart';

/// パッケージ名のハッシュからグラデーションを決定論的に選択する。
/// 同じ名前は常に同じ色になり視覚的に区別しやすい。
List<Color> selectGradientByName(String name) {
  final hash = name.codeUnits.fold(0, (a, b) => a + b);
  return AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
}
