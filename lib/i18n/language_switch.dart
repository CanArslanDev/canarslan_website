import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_locale.dart';
import 'package:flutter/widgets.dart';

/// The nav bar's `EN / TR`, wired to [SiteLocaleScope].
///
/// Rebuilds on a language change like everything else that reads copy, which
/// is what moves the lit label across.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    const locales = SiteLocale.values;
    return SignalLabelSwitch(
      labels: [for (final locale in locales) locale.label],
      selected: locales.indexOf(context.locale),
      onSelected: (index) =>
          SiteLocaleScope.select(context, locales[index]),
    );
  }
}
