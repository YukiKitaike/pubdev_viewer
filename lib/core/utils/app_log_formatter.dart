import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// LogFormat を切り替えるだけで出力スタイルを変更できる。
/// JSON 等が必要になったら enum に追加するだけ。
enum LogFormat { pretty, simple }

/// ANSI 非対応環境（IDE のデバッグコンソール等）ではエスケープコードが
/// 生表示されるため、stdout の対応状況で自動判定する。
final bool _ansiSupported = stdout.supportsAnsiEscapes;

String _ansi(String code) => _ansiSupported ? code : '';

/// Logger.root のリスナーを設定し、指定フォーマットでログを出力する。
void setupLogging({LogFormat format = LogFormat.pretty}) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final message = switch (format) {
      LogFormat.pretty => _formatPretty(record),
      LogFormat.simple => _formatSimple(record),
    };
    debugPrint(message);
  });
}

const _reset = '\x1B[0m';
const _red = '\x1B[31m';
const _yellow = '\x1B[33m';
const _green = '\x1B[32m';
const _cyan = '\x1B[36m';
const _gray = '\x1B[90m';
const _magenta = '\x1B[35m';

String _formatPretty(LogRecord record) {
  final (emoji, color) = _levelStyle(record.level);
  final time = _formatTime(record.time);
  final buffer = StringBuffer()
    ..write('${_ansi(_gray)}$time${_ansi(_reset)} ')
    ..write('$emoji ')
    ..write('${_ansi(color)}${record.level.name.padRight(7)}${_ansi(_reset)} ')
    ..write('${_ansi(_cyan)}${record.loggerName}${_ansi(_reset)} ')
    ..write(record.message);

  if (record.error != null) {
    buffer.write('\n  ${_ansi(color)}${record.error}${_ansi(_reset)}');
  }
  if (record.stackTrace != null) {
    // 全スタックトレースは Marionette 側で確認可能なため 5 行に制限
    final lines = record.stackTrace.toString().split('\n').take(5);
    for (final line in lines) {
      if (line.isNotEmpty) {
        buffer.write('\n  ${_ansi(_gray)}$line${_ansi(_reset)}');
      }
    }
  }
  return buffer.toString();
}

String _formatSimple(LogRecord record) {
  return '${record.level.name}: ${record.loggerName}: ${record.message}';
}

(String, String) _levelStyle(Level level) {
  return switch (level) {
    Level.FINEST || Level.FINER || Level.FINE => ('\u{1f50d}', _gray),
    Level.CONFIG => ('\u2699\ufe0f', _cyan),
    Level.INFO => ('\u{1f4a1}', _green),
    Level.WARNING => ('\u26a0\ufe0f', _yellow),
    Level.SEVERE => ('\u{1f534}', _red),
    Level.SHOUT => ('\u{1f6a8}', _magenta),
    _ => ('  ', _reset),
  };
}

String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}:'
      '${time.second.toString().padLeft(2, '0')}.'
      '${time.millisecond.toString().padLeft(3, '0')}';
}
