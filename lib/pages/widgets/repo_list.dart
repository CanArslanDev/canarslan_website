import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:flutter/widgets.dart';

/// Repositories as wireframe rows. Shared by the home preview and
/// `/projects` so
/// the two never drift into different-looking lists of the same thing.
class RepoList extends StatelessWidget {
  const RepoList({required this.repos, super.key});

  final List<RepoInfo> repos;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.signal.line)),
      ),
      child: Column(
        // Rows are full-bleed. A Column centres by default and hands its
        // children loose constraints, so each row took the width of its own
        // content: the one repository with a real description filled the
        // column and sat flush left, while the ones reading "no description"
        // shrank and drifted inwards by different amounts. Invisible at
        // desktop, where the row's own Row fills the width regardless.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final repo in repos)
            SignalDataRow(
              name: repo.name,
              description: repo.hasDescription
                  ? repo.description
                  : CommonCopy.noDescription.of(context),
              meta: [
                repo.language,
                '* ${repo.stars}',
              ],
              onTap: () => JavascriptService.openUrl(
                '${StringConstants.github}/${repo.name}',
              ),
            ),
        ],
      ),
    );
  }
}
