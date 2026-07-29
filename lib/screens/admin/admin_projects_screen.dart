import 'package:flutter/material.dart';

import '../../config/supabase_config.dart';
import '../../data/project_repository.dart';
import '../../models/portfolio_project.dart';
import '../../theme/portfolio_theme.dart';
import 'project_editor_screen.dart';

enum _ProjectFilter { all, published, draft, featured }

class AdminProjectsScreen extends StatefulWidget {
  const AdminProjectsScreen({super.key});

  @override
  State<AdminProjectsScreen> createState() => _AdminProjectsScreenState();
}

class _AdminProjectsScreenState extends State<AdminProjectsScreen> {
  final _repository = ProjectRepository();
  final _search = TextEditingController();
  late Future<List<PortfolioProject>> _projects;
  _ProjectFilter _filter = _ProjectFilter.all;

  @override
  void initState() {
    super.initState();
    _projects = _repository.getAllProjects();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _projects = _repository.getAllProjects();
    });
  }

  Future<void> _openEditor([PortfolioProject? project]) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProjectEditorScreen(repository: _repository, project: project),
      ),
    );
    _reload();
  }

  Future<void> _togglePublished(PortfolioProject project) async {
    await _repository.saveProject(
      project.copyWith(published: !project.published),
    );
    _reload();
  }

  Future<void> _delete(PortfolioProject project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text(
          '"${project.titleEn}" and all its uploaded media will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete permanently'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _repository.deleteProject(project);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final email = SupabaseConfig.client.auth.currentUser?.email ?? 'Admin';
    return Scaffold(
      backgroundColor: PortfolioColors.background,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: PortfolioColors.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 22,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StudioMark(),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Studio',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Text(
                  'CONTENT CONTROL',
                  style: TextStyle(
                    color: PortfolioColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width > 720)
            _AccountPill(email: email),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'View portfolio',
            onPressed: () => Navigator.pushNamed(context, '/'),
            icon: const Icon(Icons.open_in_new_rounded),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => SupabaseConfig.client.auth.signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: FutureBuilder<List<PortfolioProject>>(
        future: _projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AdminLoading();
          }
          if (snapshot.hasError) {
            return _AdminError(error: snapshot.error, onRetry: _reload);
          }

          final projects = snapshot.data ?? const [];
          final visible = _filterProjects(projects);
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.sizeOf(context).width < 600 ? 16 : 28,
                28,
                MediaQuery.sizeOf(context).width < 600 ? 16 : 28,
                100,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1380),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DashboardHeader(onCreate: _openEditor),
                        const SizedBox(height: 24),
                        _StatsRow(projects: projects),
                        const SizedBox(height: 24),
                        _Toolbar(
                          search: _search,
                          selected: _filter,
                          onSelected: (value) =>
                              setState(() => _filter = value),
                        ),
                        const SizedBox(height: 22),
                        if (visible.isEmpty)
                          _EmptyProjects(
                            hasProjects: projects.isNotEmpty,
                            onCreate: _openEditor,
                          )
                        else
                          _ProjectGrid(
                            projects: visible,
                            onEdit: _openEditor,
                            onDelete: _delete,
                            onTogglePublished: _togglePublished,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PortfolioProject> _filterProjects(List<PortfolioProject> projects) {
    final query = _search.text.trim().toLowerCase();
    return projects.where((project) {
      final matchesQuery = query.isEmpty ||
          project.titleEn.toLowerCase().contains(query) ||
          project.titleAr.contains(query) ||
          project.category.toLowerCase().contains(query);
      final matchesFilter = switch (_filter) {
        _ProjectFilter.all => true,
        _ProjectFilter.published => project.published,
        _ProjectFilter.draft => !project.published,
        _ProjectFilter.featured => project.featured,
      };
      return matchesQuery && matchesFilter;
    }).toList();
  }
}

class _StudioMark extends StatelessWidget {
  const _StudioMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PortfolioColors.primary, PortfolioColors.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.dashboard_customize_rounded,
        color: PortfolioColors.background,
        size: 21,
      ),
    );
  }
}

class _AccountPill extends StatelessWidget {
  const _AccountPill({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: PortfolioColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: PortfolioColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            email,
            style: const TextStyle(
              color: PortfolioColors.muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runAlignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 16,
      children: [
        const SizedBox(
          width: 650,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good to see you, Ibrahim',
                style: TextStyle(
                  color: PortfolioColors.text,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Create, publish and organize the work that represents you.',
                style: TextStyle(
                  color: PortfolioColors.muted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create project'),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.projects});

  final List<PortfolioProject> projects;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        'Total projects',
        '${projects.length}',
        Icons.folder_copy_outlined,
        PortfolioColors.primary,
      ),
      (
        'Published',
        '${projects.where((item) => item.published).length}',
        Icons.public_rounded,
        PortfolioColors.accent,
      ),
      (
        'Drafts',
        '${projects.where((item) => !item.published).length}',
        Icons.edit_note_rounded,
        const Color(0xFFFFB86B),
      ),
      (
        'Media files',
        '${projects.fold<int>(0, (sum, item) => sum + item.media.length)}',
        Icons.perm_media_outlined,
        PortfolioColors.secondary,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 4
            : constraints.maxWidth >= 560
                ? 2
                : 1;
        const gap = 14.0;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * gap)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final stat in stats)
              SizedBox(
                width: itemWidth,
                child: _StatCard(
                  label: stat.$1,
                  value: stat.$2,
                  icon: stat.$3,
                  color: stat.$4,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PortfolioColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PortfolioColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: PortfolioColors.text,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: PortfolioColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.search,
    required this.selected,
    required this.onSelected,
  });

  final TextEditingController search;
  final _ProjectFilter selected;
  final ValueChanged<_ProjectFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PortfolioColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PortfolioColors.border),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: TextField(
              controller: search,
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search_rounded),
                isDense: true,
              ),
            ),
          ),
          for (final filter in _ProjectFilter.values)
            ChoiceChip(
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
              label: Text(
                switch (filter) {
                  _ProjectFilter.all => 'All',
                  _ProjectFilter.published => 'Published',
                  _ProjectFilter.draft => 'Drafts',
                  _ProjectFilter.featured => 'Featured',
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePublished,
  });

  final List<PortfolioProject> projects;
  final ValueChanged<PortfolioProject> onEdit;
  final ValueChanged<PortfolioProject> onDelete;
  final ValueChanged<PortfolioProject> onTogglePublished;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1080
            ? 3
            : constraints.maxWidth >= 650
                ? 2
                : 1;
        const gap = 18.0;
        final width =
            (constraints.maxWidth - ((columns - 1) * gap)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final project in projects)
              SizedBox(
                width: width,
                child: _AdminProjectCard(
                  project: project,
                  onEdit: () => onEdit(project),
                  onDelete: () => onDelete(project),
                  onTogglePublished: () => onTogglePublished(project),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AdminProjectCard extends StatefulWidget {
  const _AdminProjectCard({
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePublished,
  });

  final PortfolioProject project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePublished;

  @override
  State<_AdminProjectCard> createState() => _AdminProjectCardState();
}

class _AdminProjectCardState extends State<_AdminProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          color: PortfolioColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? PortfolioColors.primary.withValues(alpha: 0.4)
                : PortfolioColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 28,
                    offset: const Offset(0, 15),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (project.cover != null &&
                      project.cover!.type == ProjectMediaType.image)
                    Image.network(
                      project.cover!.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _AdminPlaceholder(),
                    )
                  else
                    const _AdminPlaceholder(),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xB3060B14)],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 12,
                    start: 12,
                    child: _StatusBadge(published: project.published),
                  ),
                  if (project.featured)
                    const PositionedDirectional(
                      top: 12,
                      end: 12,
                      child: _FeaturedBadge(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.category.toUpperCase(),
                    style: const TextStyle(
                      color: PortfolioColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    project.titleEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PortfolioColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${project.media.length} media  •  ${project.links.length} links  •  Order ${project.displayOrder}',
                    style: const TextStyle(
                      color: PortfolioColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        tooltip: 'More actions',
                        onSelected: (value) {
                          if (value == 'publish') {
                            widget.onTogglePublished();
                          } else if (value == 'delete') {
                            widget.onDelete();
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'publish',
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                project.published
                                    ? Icons.visibility_off_outlined
                                    : Icons.public_rounded,
                              ),
                              title: Text(
                                project.published ? 'Unpublish' : 'Publish',
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_horiz_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminPlaceholder extends StatelessWidget {
  const _AdminPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF142136),
      child: Icon(
        Icons.photo_library_outlined,
        color: Colors.white24,
        size: 48,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.published});

  final bool published;

  @override
  Widget build(BuildContext context) {
    final color = published ? PortfolioColors.accent : const Color(0xFFFFB86B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: PortfolioColors.background.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            published ? 'LIVE' : 'DRAFT',
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: PortfolioColors.background.withValues(alpha: 0.86),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.star_rounded,
        color: Color(0xFFFFC66D),
        size: 16,
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({
    required this.hasProjects,
    required this.onCreate,
  });

  final bool hasProjects;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(54),
      decoration: BoxDecoration(
        color: PortfolioColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PortfolioColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_mosaic_outlined,
            color: PortfolioColors.primary,
            size: 48,
          ),
          const SizedBox(height: 15),
          Text(
            hasProjects
                ? 'No projects match your search.'
                : 'Your next case study starts here.',
            style: const TextStyle(
              color: PortfolioColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!hasProjects) ...[
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create first project'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdminLoading extends StatelessWidget {
  const _AdminLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _AdminError extends StatelessWidget {
  const _AdminError({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.redAccent,
              size: 52,
            ),
            const SizedBox(height: 14),
            const Text(
              'Could not load your projects',
              style: TextStyle(
                color: PortfolioColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: PortfolioColors.muted),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
