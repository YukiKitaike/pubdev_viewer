/// pub.dev API の ISO 8601 文字列を DateTime に変換する。
/// json_serializable のデフォルト DateTime 変換は int を想定するためカスタムコンバーターで対応。
DateTime dateTimeFromIso8601(String value) => DateTime.parse(value);

/// DateTime を ISO 8601 文字列に変換する。
String dateTimeToIso8601(DateTime value) => value.toIso8601String();
