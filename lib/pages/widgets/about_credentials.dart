import 'package:canarslan_website/design/signal.dart';
import 'package:flutter/widgets.dart';

/// Certificates and competitions, written once.
///
/// Both the About page and the home page's paper band show them, so the lists
/// and the tile live here rather than in whichever page happened to need them
/// first.
abstract class AboutCredentials {
  static const certificates = <(String, String)>[
    ('Computer Science', 'Harvard University'),
    ('Artificial Intelligence', 'Harvard University'),
    ('Computer Science for Business Professionals', 'Harvard University'),
    ('Elements of AI', 'University of Helsinki'),
  ];

  static const competitions = <(String, String)>[
    ('Efficiency Challenge', 'Delta Cells'),
    ('Efficiency Challenge', 'Alaz'),
    ('Technology for the Benefit of Humanity', 'AKUS'),
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

  final List<(String, String)> entries;

  /// The small label above each title, e.g. `Certificate`.
  final String plaque;

  final double minTileWidth;

  @override
  Widget build(BuildContext context) {
    return SignalMuseumGrid(
      minTileWidth: minTileWidth,
      children: [
        for (final (title, organisation) in entries)
          _Plaque(
            plaque: plaque,
            title: title,
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
