import 'package:flutter/material.dart';

/// プリミティブカラートークン。
///
/// アプリで使用する全ての色の原始値を定義する。
/// コンポーネントからは直接参照せず、AppThemeTokens 経由でセマンティックトークンを使用する。
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────
  static const Color pubBlue = Color(0xFF0175C2);

  // ── Neutral (Light surface) ───────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFF334155);
  static const Color lightSkeletonBase = Color(0xFFF1F5F9);
  static const Color lightSkeletonHighlight = Color(0xFFE2E8F0);

  // ── Neutral (Dark surface) ────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkBorderCard = Color(0xFF334155);
  static const Color darkSkeletonBase = Color(0xFF1E293B);
  static const Color darkSkeletonHighlight = Color(0xFF334155);

  // ── Avatar gradients ──────────────────────────────────
  static const List<List<Color>> avatarGradients = [
    [Color(0xFF1565C0), Color(0xFF42A5F5)],
    [Color(0xFF6A1B9A), Color(0xFFCE93D8)],
    [Color(0xFF00695C), Color(0xFF4DB6AC)],
    [Color(0xFFE65100), Color(0xFFFFB74D)],
    [Color(0xFFC62828), Color(0xFFEF9A9A)],
    [Color(0xFF283593), Color(0xFF7986CB)],
    [Color(0xFF2E7D32), Color(0xFF81C784)],
    [Color(0xFF4527A0), Color(0xFFB39DDB)],
  ];
}
