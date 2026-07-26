import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:flutter/widgets.dart';

/// The bio, written once.
///
/// It appears on the About page and again on the home page's paper band; two
/// copies of the same paragraphs would drift the first time either is edited.
class AboutBio extends StatelessWidget {
  const AboutBio({super.key, this.short = false});

  /// Drops the closing paragraph. The home band is a taste of the page, not a
  /// second copy of it.
  final bool short;

  static int get age {
    final birth = StringConstants.birthYear;
    final now = DateTime.now();
    var years = now.year - birth.year;
    final hadBirthday = now.month > birth.month ||
        (now.month == birth.month && now.day >= birth.day);
    if (!hadBirthday) years -= 1;
    return years;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AboutCopy.greeting(age).of(context),
            style: SignalType.lede(palette.fg)
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: SignalSpace.x4),
          Text(
            AboutCopy.work.of(context),
            style: SignalType.lede(palette.muted),
          ),
          if (!short) ...[
            const SizedBox(height: SignalSpace.x4),
            Text(
              AboutCopy.openSource.of(context),
              style: SignalType.lede(palette.muted),
            ),
          ],
        ],
      ),
    );
  }
}
