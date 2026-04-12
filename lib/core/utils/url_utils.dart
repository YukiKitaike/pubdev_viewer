Uri pubDevPackageUrl(String packageName) =>
    Uri.parse('https://pub.dev/packages/$packageName');

bool isHttpUrl(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  final parsed = Uri.tryParse(url);
  // http も許可: 古い pubspec.yaml では homepage が http:// で登録されている場合がある。
  return parsed != null &&
      (parsed.scheme == 'https' || parsed.scheme == 'http');
}
