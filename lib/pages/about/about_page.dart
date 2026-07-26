import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';

/// The one page that runs on paper.
///
/// Certificates and competitions read as museum plaques, which is the whole
/// reason the inversion band exists in the system. Everything else on the site
/// is dark; this page is where the light gets turned on.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static final _birthYear = StringConstants.birthYear;

  static int get _age {
    final now = DateTime.now();
    var age = now.year - _birthYear.year;
    final hadBirthday = now.month > _birthYear.month ||
        (now.month == _birthYear.month && now.day >= _birthYear.day);
    if (!hadBirthday) age -= 1;
    return age;
  }

  static const _certificates = <(String, String)>[
    ('Computer Science', 'Harvard University'),
    ('Artificial Intelligence', 'Harvard University'),
    ('Computer Science for Business Professionals', 'Harvard University'),
    ('Elements of AI', 'University of Helsinki'),
  ];

  static const _competitions = <(String, String)>[
    ('Efficiency Challenge', 'Delta Cells'),
    ('Efficiency Challenge', 'Alaz'),
    ('Technology for the Benefit of Humanity', 'AKUS'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.about,
      slivers: [
        SignalInversion(
          child: SignalSection(
            ruled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeading(
                  eyebrow: 'Can Arslan // $_role',
                  stamp: 'About',
                ),
                _Bio(age: _age),
                const SizedBox(height: SignalSpace.x16),
                const SignalEyebrow('Certificates'),
                const SizedBox(height: SignalSpace.x4),
                SignalMuseumGrid(
                  children: [
                    for (final (title, org) in _certificates)
                      _Plaque(
                        plaque: 'Certificate',
                        title: title,
                        organisation: org,
                      ),
                  ],
                ),
                const SizedBox(height: SignalSpace.x16),
                const SignalEyebrow('Competitions'),
                const SizedBox(height: SignalSpace.x4),
                SignalMuseumGrid(
                  children: [
                    for (final (title, org) in _competitions)
                      _Plaque(
                        plaque: 'Project manager',
                        title: title,
                        organisation: org,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ).asSliver,
      ],
    );
  }

  static const _role = 'YAZILIM GELİŞTİRİCİ';
}

class _Bio extends StatelessWidget {
  const _Bio({required this.age});

  final int age;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merhaba, ben Can. $age yaşındayım ve yazılım geliştiriyorum.',
            style: SignalType.lede(palette.fg)
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: SignalSpace.x4),
          Text(
            'Çoğunlukla ${StringConstants.framework} ve '
            '${StringConstants.lang} ile çalışıyorum. Mobil ve web tarafında '
            'ürünler yazıyorum, işime yarayan bir şey çıkınca da paketleyip '
            "pub.dev'de paylaşıyorum.",
            style: SignalType.lede(palette.muted),
          ),
          const SizedBox(height: SignalSpace.x4),
          Text(
            'Öğrendiklerimi açık kaynak bırakmayı seviyorum. Bu sitenin kodu '
            "da tasarımı da GitHub'da duruyor, dilerseniz bakabilirsiniz.",
            style: SignalType.lede(palette.muted),
          ),
        ],
      ),
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
        Text(
          plaque.toUpperCase(),
          style: SignalType.micro(palette.muted),
        ),
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
