import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/widgets/repo_list.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';

/// Everything public, filterable by language.
class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  static const _all = 'All';

  String _filter = _all;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.work,
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
              const PageHeading(
                eyebrow: 'github.com/CanArslanDev',
                stamp: 'Work',
                lede: 'Açık kaynak repolarımın tamamı, yıldız sayısına göre '
                    'sıralı. Dile göre filtreleyebilirsin.',
                rule: true,
              ),
              FutureBuilder<List<RepoInfo>>(
                future: SiteRepository.instance.repositories(),
                builder: (context, snapshot) {
                  final repos = snapshot.data;
                  if (repos == null) {
                    return const PagePlaceholder(
                      message: 'Repolar yükleniyor',
                    );
                  }
                  if (repos.isEmpty) {
                    return const PagePlaceholder(
                      message: 'Repolar şu an getirilemedi',
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

    final labels = [_WorkPageState._all, ...languages];
    final selected = labels.indexOf(filter).clamp(0, labels.length - 1);
    final visible = filter == _WorkPageState._all
        ? repos
        : repos.where((r) => r.language == filter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignalTabs(
          labels: labels,
          selected: selected,
          onSelected: (index) => onFilter(labels[index]),
        ),
        const SizedBox(height: SignalSpace.x8),
        RepoList(repos: visible),
        const SizedBox(height: SignalSpace.x6),
        SignalMicro(
          '${visible.length} / ${repos.length} repo',
        ),
      ],
    );
  }
}
