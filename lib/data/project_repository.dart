import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/portfolio_project.dart';

class ProjectRepository {
  ProjectRepository({SupabaseClient? client})
    : _client =
          client ??
          (SupabaseConfig.isConfigured ? SupabaseConfig.client : null);

  final SupabaseClient? _client;

  static const _projectSelect = '''
    *,
    project_media(*),
    project_links(*)
  ''';

  Future<List<PortfolioProject>> getPublishedProjects() async {
    if (_client == null) return _demoProjects;

    final rows = await _client
        .from('projects')
        .select(_projectSelect)
        .eq('published', true)
        .order('featured', ascending: false)
        .order('display_order');
    return rows.map((row) => PortfolioProject.fromJson(row)).toList();
  }

  Future<List<PortfolioProject>> getAllProjects() async {
    _requireClient();
    final rows = await _client!
        .from('projects')
        .select(_projectSelect)
        .order('display_order');
    return rows.map((row) => PortfolioProject.fromJson(row)).toList();
  }

  Future<PortfolioProject> saveProject(PortfolioProject project) async {
    _requireClient();
    final data = project.toProjectJson();
    late final Map<String, dynamic> row;

    if (project.id.isEmpty) {
      row = await _client!.from('projects').insert(data).select().single();
    } else {
      row = await _client!
          .from('projects')
          .update(data)
          .eq('id', project.id)
          .select()
          .single();
    }

    final projectId = row['id'].toString();
    await _client.from('project_links').delete().eq('project_id', projectId);
    if (project.links.isNotEmpty) {
      await _client
          .from('project_links')
          .insert(project.links.map((link) => link.toJson(projectId)).toList());
    }

    return project.copyWith(id: projectId);
  }

  Future<void> addMedia(String projectId, ProjectMedia media) async {
    _requireClient();
    await _client!.from('project_media').insert(media.toJson(projectId));
  }

  Future<void> deleteMedia(ProjectMedia media) async {
    _requireClient();
    await _client!.from('project_media').delete().eq('id', media.id);
    if (media.storagePath != null && media.storagePath!.isNotEmpty) {
      await _client.storage.from('portfolio-media').remove([
        media.storagePath!,
      ]);
    }
  }

  Future<void> updateMediaOrder(List<ProjectMedia> media) async {
    _requireClient();
    for (var index = 0; index < media.length; index++) {
      await _client!
          .from('project_media')
          .update({'display_order': index}).eq('id', media[index].id);
    }
  }

  Future<String> uploadMedia({
    required String projectId,
    required String fileName,
    required Uint8List bytes,
    required String contentType,
  }) async {
    _requireClient();
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final path =
        '$projectId/${DateTime.now().microsecondsSinceEpoch}_$safeName';
    await _client!.storage
        .from('portfolio-media')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        );
    return path;
  }

  String publicMediaUrl(String path) {
    _requireClient();
    return _client!.storage.from('portfolio-media').getPublicUrl(path);
  }

  Future<void> deleteProject(PortfolioProject project) async {
    _requireClient();
    final paths = project.media
        .map((item) => item.storagePath)
        .whereType<String>()
        .where((path) => path.isNotEmpty)
        .toList();
    if (paths.isNotEmpty) {
      await _client!.storage.from('portfolio-media').remove(paths);
    }
    await _client!.from('projects').delete().eq('id', project.id);
  }

  void _requireClient() {
    if (_client == null) {
      throw StateError('Supabase is not configured.');
    }
  }

  static const _demoProjects = <PortfolioProject>[
    PortfolioProject(
      id: 'demo-october-scada',
      slug: 'october-scada',
      titleAr: 'نظام October SCADA',
      titleEn: 'October SCADA',
      summaryAr: 'مراقبة محطات المياه لحظيًا بواجهة صناعية متجاوبة.',
      summaryEn:
          'Real-time water station monitoring with a responsive industrial UI.',
      descriptionAr:
          'تطبيق يعرض بيانات المضخات والصمامات والخزانات والضغط لحظيًا عبر MQTT.',
      descriptionEn:
          'A monitoring experience for pumps, valves, tanks and pressure data streamed over MQTT.',
      category: 'IoT',
      technologies: ['Flutter', 'MQTT', 'Riverpod'],
      media: [],
      links: [
        ProjectLink(
          id: 'demo-link-1',
          label: 'GitHub',
          url: 'https://github.com/itiswd/october_scada',
        ),
      ],
      year: '2025',
      featured: true,
      published: true,
    ),
    PortfolioProject(
      id: 'demo-auto-car',
      slug: 'auto-car-controller',
      titleAr: 'التحكم في سيارة ذكية',
      titleEn: 'Auto Car Controller',
      summaryAr: 'تحكم كامل في سيارة Arduino عن طريق Bluetooth.',
      summaryEn: 'Full Bluetooth control for an Arduino-powered car.',
      descriptionAr:
          'أوضاع قيادة يدوية وتلقائية مع إدارة الاتصال والسرعة وحالة الأوامر.',
      descriptionEn:
          'Manual and automatic drive modes with connection, speed and command status management.',
      category: 'Mobile',
      technologies: ['Flutter', 'Bluetooth', 'Arduino'],
      media: [],
      links: [
        ProjectLink(
          id: 'demo-link-2',
          label: 'GitHub',
          url: 'https://github.com/itiswd/auto_car',
        ),
      ],
      year: '2025',
      published: true,
      displayOrder: 1,
    ),
  ];
}
