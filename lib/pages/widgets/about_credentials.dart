import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:flutter/widgets.dart';

/// Certificates and competitions, written once.
///
/// Both the About page and the home page's paper band show them, so the lists
/// and the tile live here rather than in whichever page happened to need them
/// first.
///
/// Titles are [Copy] because some of them have a real name in each language
/// and some do not: a Harvard certificate is called what the certificate says
/// in either language, while a TEKNOFEST category has an actual Turkish name.
/// Organisations and team names are never translated.
abstract class AboutCredentials {
  static const certificates = <(Copy, String)>[
    (Copy('Computer Science', 'Computer Science'), 'Harvard University'),
    (
      Copy('Artificial Intelligence', 'Artificial Intelligence'),
      'Harvard University',
    ),
    (
      Copy(
        'Computer Science for Business Professionals',
        'Computer Science for Business Professionals',
      ),
      'Harvard University',
    ),
    (Copy('Elements of AI', 'Elements of AI'), 'University of Helsinki'),
  ];

  static const competitions = <(Copy, String)>[
    (Copy('Efficiency Challenge', 'Efficiency Challenge'), 'Delta Cells'),
    (Copy('Efficiency Challenge', 'Efficiency Challenge'), 'Alaz'),
    (
      Copy(
        'Technology for the Benefit of Humanity',
        'İnsanlık Yararına Teknoloji',
      ),
      'AKUS',
    ),
  ];
}

/// A contact sheet of plaques.
class CredentialGrid extends StatelessWidget {
  const CredentialGrid({
    required this.entries,
    required this.plaque,
    super.key,
    this.minTileWidth = 255,
  });

  final List<(Copy, String)> entries;

  /// The small label above each title, e.g. `Certificate`.
  final Copy plaque;

  final double minTileWidth;

  @override
  Widget build(BuildContext context) {
    return SignalMuseumGrid(
      minTileWidth: minTileWidth,
      children: [
        for (final (title, organisation) in entries)
          _Plaque(
            plaque: plaque.of(context),
            title: title.of(context),
            organisation: organisation,
          ),
      ],
    );
  }
}

class _Plaque extends StatelessWidget {
  const _Plaque({
    required this.plaque,
    required this.title,
    required this.organisation,
  });

  final String plaque;
  final String title;
  final String organisation;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plaque.toUpperCase(), style: SignalType.micro(palette.muted)),
        const SizedBox(height: SignalSpace.x2),
        Text(title, style: SignalType.cellTitle(palette.fg)),
        // Rows size to their tallest tile, so in a short row the Spacer
        // collapses and the organisation would sit flush against the title.
        const SizedBox(height: SignalSpace.x6),
        const Spacer(),
        Text(organisation, style: SignalType.caption(palette.fg)),
      ],
    );
  }
}
