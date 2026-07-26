import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/i18n/site_locale.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:flutter/widgets.dart';

/// Packages as tiles on a shared grid: name, what it does, and the three
/// numbers pub.dev scores them by.
class PackageGrid extends StatelessWidget {
  const PackageGrid({required this.packages, super.key, this.maxRows});

  final List<PackageInfo> packages;

  /// Set on a preview to show whole rows only. Pass every package and let the
  /// grid decide how many fit — trimming the list here would guess at a column
  /// count that depends on the width.
  final int? maxRows;

  @override
  Widget build(BuildContext context) {
    return SignalTileGrid(
      minTileWidth: 320,
      maxColumns: 3,
      maxRows: maxRows,
      children: [
        for (final package in packages) _PackageTile(package: package),
      ],
    );
  }
}

class _PackageTile extends StatefulWidget {
  const _PackageTile({required this.package});

  final PackageInfo package;

  @override
  State<_PackageTile> createState() => _PackageTileState();
}

class _PackageTileState extends State<_PackageTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final package = widget.package;

    Widget metric(String value, String label) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: SignalType.caption(palette.fg)),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: SignalType.micro(palette.muted),
            ),
          ],
        );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => JavascriptService.openUrl(package.url),
        child: AnimatedContainer(
          duration: SignalMotion.state,
          color: _hovered ? palette.recess : palette.surface,
          padding: const EdgeInsets.all(SignalSpace.x6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignalScrambleText(
                package.title,
                style: SignalType.rowName(
                  context.screenWidth,
                  _hovered ? palette.accentText : palette.fg,
                ).copyWith(fontSize: 24),
                duration: SignalMotion.glitch,
                play: _hovered && !MediaQuery.disableAnimationsOf(context),
              ),
              const SizedBox(height: SignalSpace.x2),
              if (package.description.isNotEmpty)
                Text(
                  package.description,
                  style: SignalType.bodySmall(palette.muted),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: SignalSpace.x6),
              const Spacer(),
              if (package.platforms.isNotEmpty)
                Wrap(
                  spacing: SignalSpace.x2,
                  runSpacing: SignalSpace.x2,
                  children: [
                    for (final platform in package.platforms)
                      SignalChip(platform),
                  ],
                ),
              const SizedBox(height: SignalSpace.x4),
              Row(
                children: [
                  Expanded(
                    child: metric(
                      package.likes,
                      PackagesCopy.likes.of(context),
                    ),
                  ),
                  Expanded(
                    child: metric(
                      package.points,
                      PackagesCopy.points.of(context),
                    ),
                  ),
                  Expanded(
                    child: metric(
                      package.downloads,
                      PackagesCopy.downloads.of(context),
                    ),
                  ),
                ],
              ),
              if (package.published != null) ...[
                const SizedBox(height: SignalSpace.x4),
                Text(
                  PackagesCopy.publishedAgo(
                    package.published!,
                    context.locale,
                  ).toUpperCase(),
                  style: SignalType.micro(palette.dim),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
