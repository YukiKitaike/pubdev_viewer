Uri pubDevPackageUrl(String packageName) =>
    Uri.parse('https://pub.dev/packages/$packageName');

bool isHttpsUrl(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  final parsed = Uri.tryParse(url);
  // セキュリティ上、平文 http は許可せず https のみ受け入れる
  return parsed != null && parsed.scheme == 'https';
}
