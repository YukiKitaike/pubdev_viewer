import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../models/package_list_item.dart';

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
