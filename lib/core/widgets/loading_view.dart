import 'package:flutter/material.dart';

/// データ読み込み中に表示するインジケーター Widget。
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
