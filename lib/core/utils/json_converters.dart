// pub.dev API は DateTime を ISO 8601 文字列で返す。
// json_serializable のデフォルト DateTime 変換は int を想定するためカスタムコンバーターで対応。
DateTime dateTimeFromIso8601(String value) => DateTime.parse(value);
String dateTimeToIso8601(DateTime value) => value.toIso8601String();
