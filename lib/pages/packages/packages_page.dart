import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/package_grid.dart';
import 'package:canarslan_website/pages/widgets/site_data.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                eyebrow: 'pub.dev // ${StringConstants.publisher}',
                stamp: SectionCopy.packages.of(context),
                lede: PackagesCopy.lede.of(context),
                rule: true,
              ),
              SiteData<List<PackageInfo>>(
                future: SiteRepository.instance.packages(),
                loading: CommonCopy.loadingPackages,
                unavailable: CommonCopy.noPackages,
                builder: (context, packages) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PackageGrid(packages: packages),
                    const SizedBox(height: SignalSpace.x8),
                    SignalPillButton(
                      label: PackagesCopy.publisher.of(context),
                      trailing: '->',
                      onPressed: () => JavascriptService.openUrl(
                        StringConstants.pubDevPublisher,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).asSliver,
      ],
    );
  }
}
