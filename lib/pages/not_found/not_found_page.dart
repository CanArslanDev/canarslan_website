import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/material.dart';

/// A dead link is still a page. It gets the same frame, the same type and a
/// way out, rather than a bare line of text on a black screen.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.notFound,
      slivers: [
        SignalSection(
          field: SignalFieldMode.scan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignalEyebrow(NotFoundCopy.eyebrow.of(context)),
              const SizedBox(height: SignalSpace.x6),
              const SignalDisplayLine('404', weight: SignalDisplayWeight.mass),
              SignalDisplayLine(
                NotFoundCopy.title.of(context),
                weight: SignalDisplayWeight.hair,
              ),
              const SizedBox(height: SignalSpace.x6),
              SignalLede(NotFoundCopy.lede.of(context)),
              const SizedBox(height: SignalSpace.x8),
              Wrap(
                spacing: SignalSpace.x3,
                runSpacing: SignalSpace.x3,
                children: [
                  SignalPillButton(
                    label: SectionCopy.home.of(context),
                    variant: SignalButtonVariant.filled,
                    onPressed: () => RouteService.go(Routes.home),
                  ),
                  SignalPillButton(
                    label: SectionCopy.projects.of(context),
                    trailing: '->',
                    onPressed: () => RouteService.go(Routes.projects),
                  ),
                ],
              ),
            ],
          ),
        ).asSliver,
      ],
    );
  }
}
