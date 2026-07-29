import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/project_repository.dart';
import '../../models/portfolio_project.dart';
import '../../theme/portfolio_theme.dart';

class ProjectEditorScreen extends StatefulWidget {
  const ProjectEditorScreen({
    super.key,
    required this.repository,
    this.project,
  });

  final ProjectRepository repository;
  final PortfolioProject? project;

  @override
  State<ProjectEditorScreen> createState() => _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends State<ProjectEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late PortfolioProject _project;
  late final TextEditingController _titleEn;
  late final TextEditingController _titleAr;
  late final TextEditingController _slug;
  late final TextEditingController _summaryEn;
  late final TextEditingController _summaryAr;
  late final TextEditingController _descriptionEn;
  late final TextEditingController _descriptionAr;
  late final TextEditingController _category;
  late final TextEditingController _technologies;
  late final TextEditingController _client;
  late final TextEditingController _year;
  late final TextEditingController _order;
  late List<_EditableLink> _links;
  bool _featured = false;
  bool _published = false;
  bool _saving = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _project = widget.project ?? _emptyProject;
    _titleEn = TextEditingController(text: _project.titleEn);
    _titleAr = TextEditingController(text: _project.titleAr);
    _slug = TextEditingController(text: _project.slug);
    _summaryEn = TextEditingController(text: _project.summaryEn);
    _summaryAr = TextEditingController(text: _project.summaryAr);
    _descriptionEn = TextEditingController(text: _project.descriptionEn);
    _descriptionAr = TextEditingController(text: _project.descriptionAr);
    _category = TextEditingController(text: _project.category);
    _technologies = TextEditingController(
      text: _project.technologies.join(', '),
    );
    _client = TextEditingController(text: _project.client);
    _year = TextEditingController(text: _project.year);
    _order = TextEditingController(text: _project.displayOrder.toString());
    _featured = _project.featured;
    _published = _project.published;
    _links = _project.links
        .map((link) => _EditableLink(link.label, link.url))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in [
      _titleEn,
      _titleAr,
      _slug,
      _summaryEn,
      _summaryAr,
      _descriptionEn,
      _descriptionAr,
      _category,
      _technologies,
      _client,
      _year,
      _order,
    ]) {
      controller.dispose();
    }
    for (final link in _links) {
      link.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      var slug = _slug.text.trim();
      if (slug.isEmpty) slug = _makeSlug(_titleEn.text);
      final links = <ProjectLink>[];
      for (var i = 0; i < _links.length; i++) {
        final link = _links[i];
        if (link.url.text.trim().isEmpty) continue;
        links.add(
          ProjectLink(
            id: '',
            label: link.label.text.trim().isEmpty
                ? 'Open link'
                : link.label.text.trim(),
            url: link.url.text.trim(),
            displayOrder: i,
          ),
        );
      }
      final draft = _project.copyWith(
        slug: slug,
        titleEn: _titleEn.text.trim(),
        titleAr: _titleAr.text.trim(),
        summaryEn: _summaryEn.text.trim(),
        summaryAr: _summaryAr.text.trim(),
        descriptionEn: _descriptionEn.text.trim(),
        descriptionAr: _descriptionAr.text.trim(),
        category: _category.text.trim(),
        technologies: _technologies.text
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(),
        links: links,
        client: _client.text.trim(),
        year: _year.text.trim(),
        displayOrder: int.tryParse(_order.text.trim()) ?? 0,
        featured: _featured,
        published: _published,
      );
      final saved = await widget.repository.saveProject(draft);
      if (!mounted) return;
      setState(() {
        _project = saved;
        _slug.text = saved.slug;
      });
      _message('Project saved');
    } catch (error) {
      _message('$error', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAndUploadMedia() async {
    if (_project.id.isEmpty) {
      _message('Save the project before uploading media.', isError: true);
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: const [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'gif',
        'avif',
        'mp4',
        'webm',
        'mov',
        'm4v',
      ],
    );
    if (result == null || result.files.isEmpty) return;
    setState(() => _uploading = true);
    try {
      for (var index = 0; index < result.files.length; index++) {
        final file = result.files[index];
        final bytes = file.bytes;
        if (bytes == null) {
          throw StateError('Could not read ${file.name}.');
        }
        final extension = (file.extension ?? '').toLowerCase();
        final isVideo = const ['mp4', 'webm', 'mov', 'm4v'].contains(extension);
        final contentType = _contentType(extension);
        final path = await widget.repository.uploadMedia(
          projectId: _project.id,
          fileName: file.name,
          bytes: bytes,
          contentType: contentType,
        );
        await widget.repository.addMedia(
          _project.id,
          ProjectMedia(
            id: '',
            url: widget.repository.publicMediaUrl(path),
            type: isVideo ? ProjectMediaType.video : ProjectMediaType.image,
            storagePath: path,
            displayOrder: _project.media.length + index,
          ),
        );
      }
      await _reloadProject();
      _message('${result.files.length} media file(s) uploaded');
    } catch (error) {
      _message('$error', isError: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _addExternalVideo() async {
    if (_project.id.isEmpty) {
      _message('Save the project before adding video.', isError: true);
      return;
    }
    final url = TextEditingController();
    final thumbnail = TextEditingController();
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add YouTube / Vimeo video'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: url,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'https://youtube.com/watch?v=...',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: thumbnail,
                decoration: const InputDecoration(
                  labelText: 'Thumbnail URL (optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, [
              url.text.trim(),
              thumbnail.text.trim(),
            ]),
            child: const Text('Add video'),
          ),
        ],
      ),
    );
    url.dispose();
    thumbnail.dispose();
    if (result == null || result.first.isEmpty) return;

    try {
      await widget.repository.addMedia(
        _project.id,
        ProjectMedia(
          id: '',
          url: result.first,
          type: ProjectMediaType.externalVideo,
          thumbnailUrl: result.last.isEmpty ? null : result.last,
          displayOrder: _project.media.length,
        ),
      );
      await _reloadProject();
      _message('Video added');
    } catch (error) {
      _message('$error', isError: true);
    }
  }

  Future<void> _deleteMedia(ProjectMedia media) async {
    try {
      await widget.repository.deleteMedia(media);
      await _reloadProject();
      _message('Media removed');
    } catch (error) {
      _message('$error', isError: true);
    }
  }

  Future<void> _moveMedia(int index, int offset) async {
    final target = index + offset;
    if (target < 0 || target >= _project.media.length) return;
    final reordered = [..._project.media];
    final item = reordered.removeAt(index);
    reordered.insert(target, item);
    setState(() => _project = _project.copyWith(media: reordered));
    try {
      await widget.repository.updateMediaOrder(reordered);
    } catch (error) {
      await _reloadProject();
      _message('$error', isError: true);
    }
  }

  Future<void> _reloadProject() async {
    final projects = await widget.repository.getAllProjects();
    final fresh = projects.firstWhere((item) => item.id == _project.id);
    if (mounted) setState(() => _project = fresh);
  }

  void _message(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor:
            isError ? Colors.redAccent : PortfolioColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _project.id.isEmpty;
    return Scaffold(
      backgroundColor: PortfolioColors.background,
      appBar: AppBar(
        backgroundColor: PortfolioColors.surface,
        title: Text(
          isNew ? 'Create project' : 'Edit ${_project.titleEn}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: PortfolioColors.primary,
                foregroundColor: PortfolioColors.background,
              ),
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    _EditorSection(
                      title: 'Project identity',
                      subtitle: 'Titles, URL and portfolio grouping.',
                      child: _ResponsiveFields(
                        children: [
                          _field(_titleEn, 'English title', isRequired: true),
                          _field(_titleAr, 'Arabic title'),
                          _field(_slug, 'URL slug', hint: 'my-project'),
                          _field(_category, 'Category', isRequired: true),
                          _field(_client, 'Client'),
                          _field(_year, 'Year', hint: '2026'),
                          _field(
                            _technologies,
                            'Technologies',
                            hint: 'Flutter, Supabase, IoT',
                            wide: true,
                          ),
                          _field(
                            _order,
                            'Display order',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _EditorSection(
                      title: 'Story',
                      subtitle:
                          'Short card copy and complete case study description.',
                      child: Column(
                        children: [
                          _field(
                            _summaryEn,
                            'English summary',
                            maxLines: 3,
                            isRequired: true,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            _summaryAr,
                            'Arabic summary',
                            maxLines: 3,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            _descriptionEn,
                            'English description',
                            maxLines: 7,
                            isRequired: true,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            _descriptionAr,
                            'Arabic description',
                            maxLines: 7,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _EditorSection(
                      title: 'Media gallery',
                      subtitle:
                          'Upload as many images and videos as the project needs.',
                      trailing: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _uploading ? null : _pickAndUploadMedia,
                            icon: _uploading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.cloud_upload_outlined),
                            label: const Text('Upload files'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _addExternalVideo,
                            icon: const Icon(Icons.video_library_outlined),
                            label: const Text('Video link'),
                          ),
                        ],
                      ),
                      child: _project.media.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(34),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.025),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Text(
                                isNew
                                    ? 'Save the project, then add media.'
                                    : 'No media yet. The first image becomes the cover.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : _MediaGrid(
                              media: _project.media,
                              onDelete: _deleteMedia,
                              onMove: _moveMedia,
                            ),
                    ),
                    const SizedBox(height: 18),
                    _EditorSection(
                      title: 'Project links',
                      subtitle:
                          'GitHub, live demo, store listing, Behance or any URL.',
                      trailing: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _links.add(_EditableLink('', '')));
                        },
                        icon: const Icon(Icons.add_link),
                        label: const Text('Add link'),
                      ),
                      child: Column(
                        children: [
                          for (var index = 0; index < _links.length; index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: _links[index].label,
                                      decoration: const InputDecoration(
                                        labelText: 'Button label',
                                        hintText: 'Live demo',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: _links[index].url,
                                      decoration: const InputDecoration(
                                        labelText: 'URL',
                                        hintText: 'https://...',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove link',
                                    onPressed: () {
                                      final removed = _links.removeAt(index);
                                      removed.dispose();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_links.isEmpty)
                            const Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'No links added.',
                                style: TextStyle(color: Colors.white38),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _EditorSection(
                      title: 'Publishing',
                      subtitle: 'Control where and how the project appears.',
                      child: Wrap(
                        spacing: 28,
                        runSpacing: 8,
                        children: [
                          SwitchListTile(
                            value: _published,
                            onChanged: (value) =>
                                setState(() => _published = value),
                            title: const Text('Published'),
                            subtitle: const Text(
                              'Visible on the public portfolio',
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            value: _featured,
                            onChanged: (value) =>
                                setState(() => _featured = value),
                            title: const Text('Featured project'),
                            subtitle: const Text('Prioritize in the gallery'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? hint,
    bool isRequired = false,
    bool wide = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textDirection: textDirection,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: isRequired
          ? (value) => value == null || value.trim().isEmpty
                ? '$label is required'
                : null
          : null,
    );
  }

  String _makeSlug(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  String _contentType(String extension) => switch (extension) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'webp' => 'image/webp',
    'gif' => 'image/gif',
    'avif' => 'image/avif',
    'webm' => 'video/webm',
    'mov' => 'video/quicktime',
    'm4v' => 'video/x-m4v',
    _ => 'video/mp4',
  };

  static const _emptyProject = PortfolioProject(
    id: '',
    slug: '',
    titleAr: '',
    titleEn: '',
    summaryAr: '',
    summaryEn: '',
    descriptionAr: '',
    descriptionEn: '',
    category: 'Mobile',
    technologies: [],
    media: [],
    links: [],
  );
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PortfolioColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 560,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 680) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }
        final width = (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({
    required this.media,
    required this.onDelete,
    required this.onMove,
  });

  final List<ProjectMedia> media;
  final ValueChanged<ProjectMedia> onDelete;
  final void Function(int index, int offset) onMove;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 760 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: media.length,
          itemBuilder: (_, index) {
            final item = media[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.type == ProjectMediaType.image)
                    Image.network(item.url, fit: BoxFit.cover)
                  else if (item.thumbnailUrl?.isNotEmpty == true)
                    Image.network(item.thumbnailUrl!, fit: BoxFit.cover)
                  else
                    const ColoredBox(color: PortfolioColors.surfaceLight),
                  if (item.type != ProjectMediaType.image)
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  PositionedDirectional(
                    top: 7,
                    end: 7,
                    child: IconButton.filled(
                      tooltip: 'Remove media',
                      onPressed: () => onDelete(item),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xCC111827),
                        foregroundColor: Colors.redAccent,
                      ),
                      icon: const Icon(Icons.delete_outline, size: 19),
                    ),
                  ),
                  PositionedDirectional(
                    end: 7,
                    bottom: 7,
                    child: Row(
                      children: [
                        _MoveButton(
                          icon: Icons.chevron_left_rounded,
                          enabled: index > 0,
                          onPressed: () => onMove(index, -1),
                        ),
                        const SizedBox(width: 4),
                        _MoveButton(
                          icon: Icons.chevron_right_rounded,
                          enabled: index < media.length - 1,
                          onPressed: () => onMove(index, 1),
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    start: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC111827),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        index == 0 ? 'COVER' : '#${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xCC111827),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 19,
          color: enabled ? Colors.white : Colors.white24,
        ),
      ),
    );
  }
}

class _EditableLink {
  _EditableLink(String labelValue, String urlValue)
    : label = TextEditingController(text: labelValue),
      url = TextEditingController(text: urlValue);

  final TextEditingController label;
  final TextEditingController url;

  void dispose() {
    label.dispose();
    url.dispose();
  }
}
