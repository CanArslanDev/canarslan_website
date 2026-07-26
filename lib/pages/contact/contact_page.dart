import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One address and four links. The old page put this behind a CRT terminal
/// with a typewriter animation; the address is the point, so it goes first.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.contact,
      slivers: [
        SignalSection(
          field: SignalFieldMode.vortex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                eyebrow: ContactCopy.eyebrow.of(context),
                stamp: SectionCopy.contact.of(context),
                lede: ContactCopy.lede.of(context),
                rule: true,
              ),
              const _EmailBlock(),
              const SizedBox(height: SignalSpace.x16),
              SignalLabelledBlock(
                label: ContactCopy.elsewhere.of(context),
                child: SignalDataRows(
                  children: [
                    LinkRow(
                      name: 'GitHub',
                      description: ContactCopy.github.of(context),
                      meta: [ContactCopy.githubMeta.of(context)],
                      url: StringConstants.github,
                    ),
                    LinkRow(
                      name: 'LinkedIn',
                      description: ContactCopy.linkedin.of(context),
                      meta: [ContactCopy.linkedinMeta.of(context)],
                      url: StringConstants.linkedin,
                    ),
                    LinkRow(
                      name: 'X',
                      description: ContactCopy.x.of(context),
                      meta: [ContactCopy.xMeta.of(context)],
                      url: StringConstants.x,
                    ),
                    LinkRow(
                      name: 'pub.dev',
                      description: ContactCopy.pubDev.of(context),
                      meta: [ContactCopy.pubDevMeta.of(context)],
                      url: StringConstants.pubDevPublisher,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SignalSpace.x12),
              SignalSpecStrip(
                entries: [
                  SignalSpecEntry(
                    label: ContactCopy.basedIn.of(context),
                    value: StringConstants.locationLabel,
                  ),
                  SignalSpecEntry(
                    label: ContactCopy.repliesLabel.of(context),
                    value: ContactCopy.repliesValue.of(context),
                  ),
                  SignalSpecEntry.live(
                    SignalLiveClock(
                      utcOffsetHours: IntConstants.timezone,
                      label: ContactCopy.now.of(context),
                    ),
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

/// The address, big, with a copy button that confirms itself.
class _EmailBlock extends StatefulWidget {
  const _EmailBlock();

  @override
  State<_EmailBlock> createState() => _EmailBlockState();
}

class _EmailBlockState extends State<_EmailBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(
      const ClipboardData(text: StringConstants.email),
    );
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectionArea(
          child: SignalDisplayLine(
            StringConstants.email.emailUser,
            weight: SignalDisplayWeight.hair,
            section: true,
          ),
        ),
        const SizedBox(height: SignalSpace.x2),
        SelectionArea(
          child: Text(
            '@${StringConstants.email.emailHost}',
            style: SignalType.stamp(
              context.screenWidth,
              context.signal.muted,
            ).copyWith(fontSize: 20, letterSpacing: 20 * 0.2),
          ),
        ),
        const SizedBox(height: SignalSpace.x6),
        Wrap(
          spacing: SignalSpace.x3,
          runSpacing: SignalSpace.x3,
          children: [
            SignalPillButton(
              label: ContactCopy.sendEmail.of(context),
              variant: SignalButtonVariant.filled,
              trailing: '->',
              onPressed: () => JavascriptService.openUrl(
                'mailto:${StringConstants.email}',
              ),
            ),
            SignalPillButton(
              label: _copied
                  ? ContactCopy.copied.of(context)
                  : ContactCopy.copyAddress.of(context),
              onPressed: _copy,
            ),
          ],
        ),
      ],
    );
  }
}
