import 'package:flutter/material.dart';

import '../data/project_repository.dart';
import '../models/portfolio_project.dart';
import 'project_details_dialog.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key, required this.languageCode});

  final String languageCode;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final _repository = ProjectRepository();
  late Future<List<PortfolioProject>> _projects;
  String _selectedCategory = 'All';

  bool get _isArabic => widget.languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _projects = _repository.getPublishedProjects();
  }

  void _retry() {
    setState(() {
      _projects = _repository.getPublishedProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1440),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 96),
      child: FutureBuilder<List<PortfolioProject>>(
        future: _projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 360,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return _ErrorState(onRetry: _retry, isArabic: _isArabic);
          }

          final projects = snapshot.data ?? const [];
          final categories = <String>{
            'All',
            ...projects.map((project) => project.category),
          }.toList();
          if (!categories.contains(_selectedCategory)) {
            _selectedCategory = 'All';
          }
          final filtered = _selectedCategory == 'All'
              ? projects
              : projects
                    .where((project) => project.category == _selectedCategory)
                    .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(isArabic: _isArabic),
              const SizedBox(height: 36),
              _CategoryFilter(
                categories: categories,
                selected: _selectedCategory,
                isArabic: _isArabic,
                onSelected: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 32),
              if (filtered.isEmpty)
                _EmptyState(isArabic: _isArabic)
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final columns = width >= 1120
                        ? 3
                        : width >= 720
                        ? 2
                        : 1;
                    final gap = width < 600 ? 18.0 : 24.0;
                    final itemWidth = (width - ((columns - 1) * gap)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (var index = 0; index < filtered.length; index++)
                          SizedBox(
                            width: itemWidth,
                            child: _ProjectCard(
                              project: filtered[index],
                              isArabic: _isArabic,
                              prominent:
                                  filtered[index].featured &&
                                  columns > 1 &&
                                  index == 0,
                              onOpen: () => _openProject(filtered[index]),
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _openProject(PortfolioProject project) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.86),
      builder: (_) =>
          ProjectDetailsDialog(project: project, isArabic: _isArabic),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runAlignment: WrapAlignment.end,
      spacing: 32,
      runSpacing: 16,
      children: [
        SizedBox(
          width: 680,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'أعمال مختارة' : 'SELECTED WORK',
                style: const TextStyle(
                  color: Color(0xFF38D6E7),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? 'مشاريع صنعت فيها فرقًا حقيقيًا.'
                    : 'Projects built to make a real difference.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.sizeOf(context).width < 600 ? 34 : 52,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'استكشف التفاصيل والصور والفيديوهات والروابط الخاصة بكل تجربة.'
                    : 'Explore the story, media, process and links behind every experience.',
                style: const TextStyle(
                  color: Color(0xFFAEB6CC),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: Color(0xFF38D6E7),
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'صور • فيديو • تفاصيل' : 'IMAGES • VIDEO • DETAILS',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.isArabic,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final bool isArabic;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            _FilterChip(
              label: category == 'All' && isArabic ? 'الكل' : category,
              selected: selected == category,
              onTap: () => onSelected(category),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF38D6E7)
              : Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? const Color(0xFF38D6E7)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF07121F) : Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    required this.project,
    required this.isArabic,
    required this.prominent,
    required this.onOpen,
  });

  final PortfolioProject project;
  final bool isArabic;
  final bool prominent;
  final VoidCallback onOpen;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final cover = project.cover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        label: project.title(widget.isArabic),
        child: InkWell(
          onTap: widget.onOpen,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            transform: Matrix4.translationValues(0, _hovered ? -7 : 0, 0),
            decoration: BoxDecoration(
              color: const Color(0xFF11182D),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _hovered
                    ? const Color(0xFF38D6E7).withValues(alpha: 0.55)
                    : Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? const Color(0xFF00B4DB).withValues(alpha: 0.16)
                      : Colors.black.withValues(alpha: 0.18),
                  blurRadius: _hovered ? 34 : 18,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (cover != null && cover.type == ProjectMediaType.image)
                        Image.network(
                          cover.url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const _ProjectPlaceholder(),
                        )
                      else
                        const _ProjectPlaceholder(),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB30A0E1D)],
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: 16,
                        top: 16,
                        child: _Badge(label: project.category),
                      ),
                      if (project.media.length > 1)
                        PositionedDirectional(
                          end: 16,
                          top: 16,
                          child: _Badge(
                            label:
                                '${project.media.length} ${widget.isArabic ? 'وسائط' : 'MEDIA'}',
                            icon: Icons.collections_outlined,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 21, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.title(widget.isArabic),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _hovered ? -0.08 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: const Icon(
                              Icons.north_east_rounded,
                              color: Color(0xFF38D6E7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      Text(
                        project.summary(widget.isArabic),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFAEB6CC),
                          height: 1.55,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.technologies
                            .take(4)
                            .map(
                              (technology) => Text(
                                '#$technology',
                                style: const TextStyle(
                                  color: Color(0xFF7EE8F2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xE6121726),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: Colors.white70),
            const SizedBox(width: 5),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectPlaceholder extends StatelessWidget {
  const _ProjectPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF183B55), Color(0xFF20244D)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_mosaic_outlined,
          color: Colors.white.withValues(alpha: 0.72),
          size: 58,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry, required this.isArabic});

  final VoidCallback onRetry;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, color: Colors.white54, size: 52),
          const SizedBox(height: 14),
          Text(
            isArabic
                ? 'تعذر تحميل المشاريع الآن'
                : 'Projects could not be loaded',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(isArabic ? 'إعادة المحاولة' : 'Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(56),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        isArabic ? 'لا توجد مشاريع في هذا التصنيف.' : 'No projects here yet.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54, fontSize: 17),
      ),
    );
  }
}
