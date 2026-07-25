import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/package_grid.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:flutter/material.dart';

/// Everything published under the canarslan.me publisher.
class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.packages,
      slivers: [
        SignalSection(
          field: SignalFieldMode.scan,
          fieldOpacity: 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                eyebrow: 'pub.dev // canarslan.me',
                stamp: 'Packages',
                lede: 'Bir işi ikinci kez yaptığımda paket hâline getiriyorum. '
                    'Hepsi açık kaynak ve pub.dev üzerinden yayında.',
                rule: true,
              ),
              FutureBuilder<List<PackageInfo>>(
                future: SiteRepository.instance.packages(),
                builder: (context, snapshot) {
                  final packages = snapshot.data;
                  if (packages == null) {
                    return const PagePlaceholder(
                      message: 'Paketler yükleniyor',
                    );
                  }
                  if (packages.isEmpty) {
                    return const PagePlaceholder(
                      message: 'Paketler şu an getirilemedi',
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PackageGrid(packages: packages),
                      const SizedBox(height: SignalSpace.x8),
                      SignalPillButton(
                        label: 'Publisher on pub.dev',
                        trailing: '->',
                        onPressed: () => JavascriptService.openUrl(
                          StringConstants.pubDevPublisher,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ).asSliver,
      ],
    );
  }
}
