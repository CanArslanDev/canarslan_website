import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
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
          fieldOpacity: 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                eyebrow: 'Say hello',
                stamp: 'Contact',
                lede: 'Bir fikrin, bir sorun ya da sadece merakın varsa yaz. '
                    'E-postaya genelde aynı gün dönüyorum.',
                rule: true,
              ),
              const _EmailBlock(),
              const SizedBox(height: SignalSpace.x16),
              const SignalEyebrow('Elsewhere'),
              const SizedBox(height: SignalSpace.x4),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.signal.line),
                  ),
                ),
                child: const Column(
                  children: [
                    LinkRow(
                      name: 'GitHub',
                      description: 'Kod, paketler ve bu sitenin kaynağı.',
                      meta: ['Open source'],
                      url: StringConstants.github,
                    ),
                    LinkRow(
                      name: 'LinkedIn',
                      description: 'İş geçmişi ve profesyonel iletişim.',
                      meta: ['Profile'],
                      url: StringConstants.linkedin,
                    ),
                    LinkRow(
                      name: 'X',
                      description: 'Kısa notlar ve yaptıklarımdan parçalar.',
                      meta: ['Feed'],
                      url: StringConstants.x,
                    ),
                    LinkRow(
                      name: 'pub.dev',
                      description: 'Yayımladığım Dart ve Flutter paketleri.',
                      meta: ['Publisher'],
                      url: StringConstants.pubDevPublisher,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SignalSpace.x12),
              SignalSpecStrip(
                entries: [
                  const SignalSpecEntry(
                    label: 'Based in',
                    value: 'TÜRKİYE',
                  ),
                  const SignalSpecEntry(
                    label: 'Usually replies',
                    value: 'Same day',
                  ),
                  SignalSpecEntry(
                    label: 'Local time',
                    child: SignalLiveClock(
                      utcOffsetHours: IntConstants.timezone,
                      label: 'Now',
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
              label: 'Send an email',
              variant: SignalButtonVariant.filled,
              trailing: '->',
              onPressed: () => JavascriptService.openUrl(
                'mailto:${StringConstants.email}',
              ),
            ),
            SignalPillButton(
              label: _copied ? 'Copied' : 'Copy address',
              onPressed: _copy,
            ),
          ],
        ),
      ],
    );
  }
}
