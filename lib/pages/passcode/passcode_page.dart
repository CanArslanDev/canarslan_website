import 'package:canarslan_website/data/vault.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The door in front of the private pages.
///
/// Not linked from anywhere, like `/design` — but unlike the storybook this one
/// is meant to be reached by someone who was told the address. It says nothing
/// about what is behind it, and a wrong code, a missing vault and a corrupt one
/// all produce the same answer.
class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  /// Raise this and re-run the tool with a longer code; nothing else changes.
  /// Six digits is a million combinations, which is the weakest part of the
  /// whole arrangement — see [Vault].
  static const _length = 6;

  final _controller = TextEditingController();
  final _focus = FocusNode();

  bool _working = false;
  bool _wrong = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit(String code) async {
    if (_working) return;
    setState(() {
      _working = true;
      _wrong = false;
    });

    final opened = await Vault.unlock(code);
    if (!mounted) return;

    setState(() {
      _working = false;
      _wrong = !opened;
      if (!opened) _controller.clear();
    });
    if (!opened) _focus.requestFocus();
  }

  void _onChanged(String value) {
    setState(() => _wrong = false);
    if (value.length == _length) _submit(value);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.passcode,
      slivers: [
        SignalSection(
          field: SignalFieldMode.scan,
          child: Vault.isOpen
              ? _VaultIndex(onClose: () => setState(Vault.close))
              : _Gate(
                  length: _length,
                  controller: _controller,
                  focus: _focus,
                  working: _working,
                  wrong: _wrong,
                  onChanged: _onChanged,
                ),
        ).asSliver,
      ],
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate({
    required this.length,
    required this.controller,
    required this.focus,
    required this.working,
    required this.wrong,
    required this.onChanged,
  });

  final int length;
  final TextEditingController controller;
  final FocusNode focus;
  final bool working;
  final bool wrong;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          eyebrow: PasscodeCopy.eyebrow.of(context),
          stamp: PasscodeCopy.stamp.of(context),
          lede: PasscodeCopy.lede.of(context),
          rule: true,
        ),
        _CodeField(
          length: length,
          controller: controller,
          focus: focus,
          wrong: wrong,
          onChanged: onChanged,
        ),
        const SizedBox(height: SignalSpace.x4),
        SignalMicro(
          working
              ? PasscodeCopy.checking.of(context)
              : wrong
                  ? PasscodeCopy.wrong.of(context)
                  : PasscodeCopy.hint.of(context),
        ),
      ],
    );
  }
}

/// The cells, and the invisible field that actually holds the text.
///
/// A real `TextField` rather than a key listener: it is what brings up a
/// numeric keypad on a phone, what the browser's autofill and paste go
/// through, and what a screen reader announces. It is sized to nothing and
/// drawn transparent, and the cells below render its value.
class _CodeField extends StatelessWidget {
  const _CodeField({
    required this.length,
    required this.controller,
    required this.focus,
    required this.wrong,
    required this.onChanged,
  });

  final int length;
  final TextEditingController controller;
  final FocusNode focus;
  final bool wrong;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return Stack(
      children: [
        SizedBox(
          width: 1,
          height: 1,
          child: TextField(
            controller: controller,
            focusNode: focus,
            onChanged: onChanged,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: length,
            showCursor: false,
            cursorWidth: 0,
            style: SignalType.micro(SignalPalette.transparent),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        GestureDetector(
          onTap: focus.requestFocus,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => Wrap(
              spacing: SignalSpace.x3,
              runSpacing: SignalSpace.x3,
              children: [
                for (var i = 0; i < length; i++)
                  _Cell(
                    filled: i < value.text.length,
                    lit: !wrong && i == value.text.length && focus.hasFocus,
                    wrong: wrong,
                    palette: palette,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.filled,
    required this.lit,
    required this.wrong,
    required this.palette,
  });

  final bool filled;
  final bool lit;
  final bool wrong;
  final SignalPalette palette;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: SignalMotion.state,
      curve: SignalMotion.linearish,
      width: 52,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(
          // The one accent on this page: the cell waiting for the next digit.
          color: lit
              ? palette.accent
              : (wrong ? palette.fg : palette.line),
        ),
        borderRadius: SignalRadius.structural,
      ),
      child: AnimatedOpacity(
        opacity: filled ? 1 : 0,
        duration: SignalMotion.state,
        child: Container(width: 10, height: 10, color: palette.fg),
      ),
    );
  }
}

/// What is behind the door, once it is open.
class _VaultIndex extends StatelessWidget {
  const _VaultIndex({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final pages = Vault.pages ?? const <VaultPage>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          eyebrow: PasscodeCopy.openEyebrow.of(context),
          stamp: PasscodeCopy.stamp.of(context),
        ),
        if (pages.isEmpty)
          SignalMicro(PasscodeCopy.empty.of(context))
        else
          for (final page in pages) ...[
            SignalLabelledBlock(
              label: page.title,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final paragraph in page.body) ...[
                    SignalLede(paragraph),
                    const SizedBox(height: SignalSpace.x3),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SignalSpace.x12),
          ],
        SignalPillButton(
          label: PasscodeCopy.lock.of(context),
          onPressed: onClose,
        ),
      ],
    );
  }
}
