/// アプリケーション全体で使用する文字列定数を集中管理する。
class AppStrings {
  AppStrings._();

  // エラータイトル
  static const String networkErrorTitle = '通信エラー';
  static const String serverErrorTitle = 'サーバーエラー';
  static const String unexpectedErrorTitle = '予期しないエラー';

  // エラーメッセージ
  static const String networkErrorMessage = 'ネットワーク接続を確認してから\n再試行してください。';
  static const String serverErrorMessage = 'しばらくしてから再試行してください。';
  static const String unexpectedErrorMessage = '問題が解決しない場合はアプリを再起動してください。';
  static const String loadMoreFailed = '追加読み込みに失敗しました';
  static const String linkOpenFailed = 'リンクを開けませんでした';

  // ラベル・アクション
  static const String retry = '再試行';
  static const String share = '共有';
  static const String openExternal = '外部サイトで開く';
  static const String lightMode = 'ライトモード';
  static const String darkMode = 'ダークモード';
}
