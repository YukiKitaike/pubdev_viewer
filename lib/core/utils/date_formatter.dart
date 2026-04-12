import 'package:intl/intl.dart';

// DateFormat の生成コストを避けるためモジュールレベルで再利用する。
final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

String formatDate(DateTime date) => _dateFormat.format(date);
