import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/about_bio.dart';
import 'package:canarslan_website/pages/widgets/about_credentials.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';

/// The one page that runs on paper.
///
/// Certificates and competitions read as museum plaques, which is the whole
/// reason the inversion band exists in the system. Everything else on the site
/// is dark; this page is where the light gets turned on.
///
/// It carries the same [SignalFieldMode.ripple] as the home page's paper band,
/// because they are the same room seen twice — the band is the excerpt and this
/// is the page. Quieter here, on the same reasoning `/work` is quieter than its
/// preview: the field runs the whole length of a much taller section, and at
/// that height atmosphere turns into noise behind the reading.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.about,
      slivers: [
        const SignalInversion(
          child: SignalSection(
            field: SignalFieldMode.ripple,
            fieldOpacity: 0.32,
            ruled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeading(
                  eyebrow: 'Can Arslan // YAZILIM GELİŞTİRİCİ',
                  stamp: 'About',
                ),
                AboutBio(),
                SizedBox(height: SignalSpace.x16),
                SignalEyebrow('Certificates'),
                SizedBox(height: SignalSpace.x4),
                CredentialGrid(
                  entries: AboutCredentials.certificates,
                  plaque: 'Certificate',
                ),
                SizedBox(height: SignalSpace.x16),
                SignalEyebrow('Competitions'),
                SizedBox(height: SignalSpace.x4),
                CredentialGrid(
                  entries: AboutCredentials.competitions,
                  plaque: 'Project manager',
                ),
              ],
            ),
          ),
        ).asSliver,
      ],
    );
  }
}
