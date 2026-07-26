import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/language_switch.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/material.dart';

/// The frame every page sits in: frosted nav on top, the page's own bands in
/// the middle, the coordinate footer at the bottom.
///
/// Each route builds its own [AppShell]. Pages are siblings, not sections of
/// one scrolling document — tapping a nav item changes the route and the page
/// starts at the top with its own content.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.route,
    required this.slivers,
    super.key,
  });

  /// The current route, used to light the right nav item.
  final String route;

  /// The page's bands. Slivers rather than a Column so long lists on
  /// `/work` and `/packages` stay lazy.
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return Scaffold(
      backgroundColor: palette.canvas,
      body: Column(
        children: [
          SignalNavBar(
            wordmark: StringConstants.name,
            selectedIndex: Routes.navigationIndexOf(route),
            items: [
              for (final (path, label) in Routes.navigation)
                SignalNavItem(
                  label: label.of(context),
                  onTap: () => RouteService.go(path),
                ),
            ],
            trailing: const LanguageSwitch(),
            actionLabel: CommonCopy.getInTouch.of(context),
            compactActionLabel: SectionCopy.contact.of(context),
            onAction: () => RouteService.go(Routes.contact),
          ),
          Expanded(
            child: CustomScrollView(
              key: PageStorageKey<String>(route),
              slivers: [
                ...slivers,
                SliverToBoxAdapter(
                  child: SignalFooter(
                    name: StringConstants.name,
                    role: CommonCopy.role.of(context),
                    contactLines: const [
                      StringConstants.email,
                      StringConstants.github,
                    ],
                    locationLabel: StringConstants.location,
                    utcOffsetHours: IntConstants.timezone,
                    note: 'canarslan.me',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience: wrap a box widget as a sliver.
extension SignalSliver on Widget {
  Widget get asSliver => SliverToBoxAdapter(child: this);
}

/// The section header used across the pages: eyebrow, stamp, lede.
class PageHeading extends StatelessWidget {
  const PageHeading({
    required this.eyebrow,
    required this.stamp,
    super.key,
    this.lede,
    this.rule = false,
  });

  final String eyebrow;
  final String stamp;
  final String? lede;

  /// Draws the accent hairline under the stamp. Reserved for the page's
  /// leading section, so it never reads as decoration.
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
            const SizedBox(width: 260, child: SignalDrawnRule()),
          ],
          if (lede != null) ...[
            const SizedBox(height: SignalSpace.x3),
            SignalReveal(child: SignalLede(lede!)),
          ],
        ],
      ),
    );
  }
}

/// Shown while remote data is in flight, and when it never arrives.
///
/// Both states say the same thing in the same place, because the difference
/// does not matter to a visitor — only whether there is anything to read.
class PagePlaceholder extends StatelessWidget {
  const PagePlaceholder({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SignalSpace.x12),
      child: SignalMicro(message),
    );
  }
}

/// A link rendered as one of the system's data rows.
class LinkRow extends StatelessWidget {
  const LinkRow({
    required this.name,
    required this.description,
    required this.meta,
    required this.url,
    super.key,
  });

  final String name;
  final String description;
  final List<String> meta;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SignalDataRow(
      name: name,
      description: description,
      meta: meta,
      onTap: () => JavascriptService.openUrl(url),
    );
  }
}
