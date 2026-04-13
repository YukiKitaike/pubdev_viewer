import 'package:characters/characters.dart';

// 先頭グラフィムの取得。index アクセス `[0]` は合字・絵文字で壊れ、
// さらに空文字で RangeError になるためヘルパーで一元化する。
String firstGrapheme(String value, {String fallback = '?'}) {
  if (value.isEmpty) {
    return fallback;
  }
  return value.characters.first;
}
