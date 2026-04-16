import 'package:flutter/material.dart';

/// 画面中央にプログレスインジケータを表示する共通ローディングウィジェット。
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
