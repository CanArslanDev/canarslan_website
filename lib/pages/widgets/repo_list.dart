import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:flutter/widgets.dart';

/// Repositories as wireframe rows. Shared by the home preview and `/work` so
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
        children: [
          for (final repo in repos)
            SignalDataRow(
              name: repo.name,
              description: repo.hasDescription
                  ? repo.description
                  : 'Açıklama yok.',
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
