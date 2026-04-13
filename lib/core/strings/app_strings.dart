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

  // セクション見出し
  static const String sectionOverview = 'Overview';
  static const String sectionVersions = 'Versions';
  static const String latestBadge = 'LATEST';

  // アプリタイトル
  static const String appTitle = 'pub.dev Viewer';
  static const String appTitlePub = 'pub';
  static const String appTitleDotDev = '.dev';
  static const String appTitleViewer = ' Viewer';

  // ラベル・アクション
  static const String retry = '再試行';
  static const String share = '共有';
  static const String openExternal = '外部サイトで開く';
  static const String lightMode = 'ライトモード';
  static const String darkMode = 'ダークモード';

  // セマンティクスラベル（スクリーンリーダー向け）
  static const String loading = '読み込み中';
  static const String loadingMore = '追加データを読み込み中';
  static const String skeletonLoading = '読み込み中のプレースホルダー';
  static const String verifiedPublisher = '認証済みパブリッシャー';
  static const String latestVersionLabel = '最新バージョン';
  static const String packageListItemHint = 'パッケージ詳細を表示';
}
