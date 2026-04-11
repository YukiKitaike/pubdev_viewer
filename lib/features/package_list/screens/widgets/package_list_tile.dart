import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../models/package_list_item.dart';

/// パッケージ一覧の各行を表示する ListTile Widget。
class PackageListTile extends StatelessWidget {
  const PackageListTile({
    required this.package,
    super.key,
  });

  final PackageListItem package;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(package.name),
      subtitle: Text('v${package.latest.version}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => PackageDetailRoute(
        name: package.name,
      ).go(context),
    );
  }
}
