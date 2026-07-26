import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/language_switch.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/material.dart';

part 'widgets/design_page_sections.dart';
part 'widgets/design_page_specimens.dart';

/// Internal storybook for the SIGNAL system.
///
/// Renders every token and component in the real app, so the design can be
/// reviewed and tuned before any page is rebuilt on top of it. Not linked from
/// the navigation — reachable at `/design`.
class DesignPage extends StatelessWidget {
  const DesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SignalTheme.instrument,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.signal.canvas,
          body: Column(
            children: [
              SignalNavBar(
                wordmark: StringConstants.name,
                // The storybook is not one of the site's sections, so no nav
                // item is lit — but the links work, because a nav that does
                // nothing is worse than no nav at all.
                selectedIndex: -1,
                items: [
                  for (final (path, label) in Routes.navigation)
                    SignalNavItem(
                      // Outside the locale scope, so this resolves to the
                      // default. The storybook documents the system rather
                      // than presenting the site, and does not switch.
                      label: label.of(context),
                      onTap: () => RouteService.go(path),
                    ),
                ],
                trailing: const LanguageSwitch(),
                actionLabel: CommonCopy.getInTouch.of(context),
                compactActionLabel: SectionCopy.contact.of(context),
                onAction: () => RouteService.go(Routes.contact),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _Hero(),
                      SignalMarquee(
                        items: [
                          'Flutter',
                          'Dart',
                          'pub.dev publisher',
                          'Open source',
                          'Mobile',
                          'Web',
                        ],
                      ),
                      _PaletteSection(),
                      _TypeSection(),
                      _ShapeSection(),
                      _MotionSection(),
                      _ComponentsSection(),
                      _ProjectsSection(),
                      _AboutSection(),
                      SignalFooter(
                        name: StringConstants.name,
                        // Authored uppercase — see the note in _Hero.
                        role: 'YAZILIM GELİŞTİRİCİ',
                        contactLines: [
                          StringConstants.email,
                          StringConstants.github,
                        ],
                        locationLabel: 'TÜRKİYE',
                        utcOffsetHours: 3,
                        note: 'Signal v1 — design system',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The component demos are specimens, not controls — their buttons are meant
/// to be looked at, not followed.
void _noop() {}

/// Section header: eyebrow, stamp, lede and an optional provenance note.
class _Head extends StatelessWidget {
  const _Head({
    required this.eyebrow,
    required this.stamp,
    required this.lede,
    this.provenance,
    this.rule = false,
  });

  final String eyebrow;
  final String stamp;
  final String lede;
  final String? provenance;

  /// Draws the accent hairline under the stamp.
  final bool rule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SignalSpace.x12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignalEyebrow(eyebrow),
          const SizedBox(height: SignalSpace.x3),
          SignalStamp(stamp),
          if (rule) ...[
            const SizedBox(height: SignalSpace.x2),
            const SizedBox(width: 280, child: SignalDrawnRule()),
          ],
          const SizedBox(height: SignalSpace.x3),
          SignalReveal(child: SignalLede(lede)),
          if (provenance != null) ...[
            const SizedBox(height: SignalSpace.x3),
            SignalMicro(provenance!),
          ],
        ],
      ),
    );
  }
}
