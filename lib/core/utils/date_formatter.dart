import 'package:intl/intl.dart';

// DateFormat の生成コストを避けるためモジュールレベルで再利用する。
final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

/// DateTime を `yyyy-MM-dd` 形式の文字列に変換する。
String formatDate(DateTime date) => _dateFormat.format(date);
