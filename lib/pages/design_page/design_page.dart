import 'dart:async';

import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/services/javascript_service.dart';
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
    // Scoped rather than global: the existing pages keep their old theme
    // until they are migrated, so this route is additive and risk-free.
    return Theme(
      data: SignalTheme.instrument,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.signal.canvas,
          body: const Column(
            children: [
              SignalNavBar(
                wordmark: StringConstants.name,
                selectedIndex: 0,
                items: [
                  SignalNavItem(label: 'Work', onTap: _noop),
                  SignalNavItem(label: 'Packages', onTap: _noop),
                  SignalNavItem(label: 'About', onTap: _noop),
                  SignalNavItem(label: 'Contact', onTap: _noop),
                ],
                actionLabel: 'Get in touch',
                onAction: _noop,
              ),
              Expanded(
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
                      _WorkSection(),
                      _AboutSection(),
                      SignalFooter(
                        name: StringConstants.name,
                        role: 'Yazılım geliştirici',
                        contactLines: [
                          StringConstants.email,
                          StringConstants.github,
                        ],
                        locationLabel: 'Türkiye',
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
