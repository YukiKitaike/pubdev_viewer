/// JetBrains Mono フォントで使用するフォントサイズ定数。
///
/// 通常の本文・見出しは TextTheme を使用し、
/// このクラスは等幅フォント（バージョン番号・日付・バッジ等）専用。
/// 2pt ステップのスケール: mono10（小バッジ）/ mono12（本文相当）/ mono14（強調）。
abstract final class AppTextSize {
  static const double mono10 = 10;
  static const double mono12 = 12;
  static const double mono14 = 14;
}
