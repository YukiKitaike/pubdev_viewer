@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/core/utils/app_retry.dart';

void main() {
  group('appRetry', () {
    test('NetworkException に対して指数バックオフの Duration を返す', () {
      const error = NetworkException();
      check(appRetry(0, error)).equals(const Duration(milliseconds: 200));
      check(appRetry(1, error)).equals(const Duration(milliseconds: 400));
      check(appRetry(2, error)).equals(const Duration(milliseconds: 800));
    });

    test('ServerException に対して指数バックオフの Duration を返す', () {
      const error = ServerException(500);
      check(appRetry(0, error)).equals(const Duration(milliseconds: 200));
      check(appRetry(1, error)).equals(const Duration(milliseconds: 400));
      check(appRetry(2, error)).equals(const Duration(milliseconds: 800));
    });

    test('3 回目以降は null を返してリトライを停止する', () {
      const error = NetworkException();
      check(appRetry(3, error)).isNull();
      check(appRetry(4, error)).isNull();
    });

    test('Error に対しては即座に null を返す', () {
      check(appRetry(0, StateError('bug'))).isNull();
    });
  });
}
