import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/about_bio.dart';
import 'package:canarslan_website/pages/widgets/about_credentials.dart';
import 'package:canarslan_website/pages/widgets/contribution_calendar.dart';
import 'package:canarslan_website/pages/widgets/package_grid.dart';
import 'package:canarslan_website/pages/widgets/repo_list.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/material.dart';

part 'widgets/home_about.dart';
part 'widgets/home_contributions.dart';
part 'widgets/home_hero.dart';
part 'widgets/home_previews.dart';

/// The landing page: who this is, what they made, and proof it is still
/// running. Projects and packages appear here as short previews — the full
/// live on their own routes.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.home,
      slivers: [
        const _HeroViewport().asSliver,
        SignalMarquee(
          items: [
            for (final item in HomeCopy.marquee) item.of(context),
          ],
        ).asSliver,
        const _ProjectsPreview().asSliver,
        const _PackagesPreview().asSliver,
        const _AboutBand().asSliver,
        const _Contributions().asSliver,
      ],
    );
  }
}
