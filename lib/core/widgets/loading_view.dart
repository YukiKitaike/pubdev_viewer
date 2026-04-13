import 'package:flutter/material.dart';

import 'package:pubdev_viewer/core/strings/app_strings.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        // スクリーンリーダー利用者にロード中であることを明示的に伝える。
        semanticsLabel: AppStrings.loading,
        color: Theme.of(context).colorScheme.primary,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
