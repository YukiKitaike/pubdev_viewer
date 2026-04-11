/// アプリケーション全体で使用する文字列定数を集中管理する。
class AppStrings {
  AppStrings._();

  // エラータイトル
  static const String errorTitleNetwork = '通信エラー';
  static const String errorTitleServer = 'サーバーエラー';
  static const String errorTitleUnexpected = '予期しないエラー';

  // エラーメッセージ
  static const String errorMessageNetwork = 'ネットワーク接続を確認してから\n再試行してください。';
  static const String errorMessageServer = 'しばらくしてから再試行してください。';
  static const String errorMessageUnexpected = '問題が解決しない場合はアプリを再起動してください。';
  static const String errorMessageLoadMoreFailed = '追加読み込みに失敗しました';
  static const String errorMessageLinkFailed = 'リンクを開けませんでした';

  // ラベル・アクション
  static const String labelRetry = '再試行';
  static const String labelShare = '共有';
  static const String labelOpenExternal = '外部サイトで開く';
  static const String labelLightMode = 'ライトモード';
  static const String labelDarkMode = 'ダークモード';
}
