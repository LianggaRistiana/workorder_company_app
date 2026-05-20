import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

class VersionText extends StatelessWidget {
  const VersionText({super.key});

  Future<String> _getVersion() async {
    final info = await PackageInfo.fromPlatform();

    return "Version ${info.version} (${info.buildNumber})";
  }

  @override
  Widget build(BuildContext context) {
    appLogger.i("Getting version");
    return FutureBuilder<String>(
      future: _getVersion(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        appLogger.i(snapshot.data!);

        return Text(
          "Workorder SaaS Mobile App\n${snapshot.data!}",
          style: Theme.of(context).textTheme.labelSmall,
        );
      },
    );
  }
}
