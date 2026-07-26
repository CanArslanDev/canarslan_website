import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/repo_list.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';

/// Everything public, filterable by language.
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  /// Identifies the "no filter" tab. Never shown — the visible label comes
  /// from [ProjectsCopy.filterAll] — so switching language cannot drop the
  /// selection the way a translated sentinel would.
  static const _all = '';

  String _filter = _all;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.projects,
      slivers: [
        SignalSection(
          field: SignalFieldMode.wave,
          // Quieter than the home preview's 0.42. There the accent wave sits
          // behind four rows; here it runs the length of the full list, and at
          // that height it stops being atmosphere and starts eating the
          // descriptions.
          fieldOpacity: 0.16,
          fieldTintAccent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                eyebrow: 'github.com/CanArslanDev',
                stamp: SectionCopy.projects.of(context),
                lede: ProjectsCopy.lede.of(context),
                rule: true,
              ),
              FutureBuilder<List<RepoInfo>>(
                future: SiteRepository.instance.repositories(),
                builder: (context, snapshot) {
                  final repos = snapshot.data;
                  if (repos == null) {
                    return PagePlaceholder(
                      message: CommonCopy.loadingRepos.of(context),
                    );
                  }
                  if (repos.isEmpty) {
                    return PagePlaceholder(
                      message: CommonCopy.noRepos.of(context),
                    );
                  }
                  return _Results(
                    repos: repos,
                    filter: _filter,
                    onFilter: (value) => setState(() => _filter = value),
                  );
                },
              ),
            ],
          ),
        ).asSliver,
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.repos,
    required this.filter,
    required this.onFilter,
  });

  final List<RepoInfo> repos;
  final String filter;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    // Languages in order of how much of the work they represent, so the tab
    // row reads as a summary rather than an alphabet.
    final counts = <String, int>{};
    for (final repo in repos) {
      if (repo.language == 'Unknown') continue;
      counts[repo.language] = (counts[repo.language] ?? 0) + 1;
    }
    final languages = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    // The first tab is the sentinel; every other one is a language, which is
    // data and never translated.
    final values = [_ProjectsPageState._all, ...languages];
    final labels = [ProjectsCopy.filterAll.of(context), ...languages];
    final selected = values.indexOf(filter).clamp(0, values.length - 1);
    final visible = filter == _ProjectsPageState._all
        ? repos
        : repos.where((r) => r.language == filter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignalTabs(
          labels: labels,
          selected: selected,
          onSelected: (index) => onFilter(values[index]),
        ),
        const SizedBox(height: SignalSpace.x8),
        RepoList(repos: visible),
        const SizedBox(height: SignalSpace.x6),
        SignalMicro(
          '${visible.length} / ${repos.length} '
          '${ProjectsCopy.repoUnit.of(context)}',
        ),
      ],
    );
  }
}
