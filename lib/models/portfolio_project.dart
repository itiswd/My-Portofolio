enum ProjectMediaType { image, video, externalVideo }

class ProjectMedia {
  const ProjectMedia({
    required this.id,
    required this.url,
    required this.type,
    this.captionAr = '',
    this.captionEn = '',
    this.thumbnailUrl,
    this.storagePath,
    this.displayOrder = 0,
  });

  final String id;
  final String url;
  final ProjectMediaType type;
  final String captionAr;
  final String captionEn;
  final String? thumbnailUrl;
  final String? storagePath;
  final int displayOrder;

  String caption(bool isArabic) =>
      isArabic && captionAr.isNotEmpty ? captionAr : captionEn;

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: switch (json['media_type']) {
        'video' => ProjectMediaType.video,
        'external_video' => ProjectMediaType.externalVideo,
        _ => ProjectMediaType.image,
      },
      captionAr: json['caption_ar']?.toString() ?? '',
      captionEn: json['caption_en']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString(),
      storagePath: json['storage_path']?.toString(),
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson(String projectId) => {
    'project_id': projectId,
    'url': url,
    'media_type': switch (type) {
      ProjectMediaType.image => 'image',
      ProjectMediaType.video => 'video',
      ProjectMediaType.externalVideo => 'external_video',
    },
    'caption_ar': captionAr,
    'caption_en': captionEn,
    'thumbnail_url': thumbnailUrl,
    'storage_path': storagePath,
    'display_order': displayOrder,
  };
}

class ProjectLink {
  const ProjectLink({
    required this.id,
    required this.label,
    required this.url,
    this.displayOrder = 0,
  });

  final String id;
  final String label;
  final String url;
  final int displayOrder;

  factory ProjectLink.fromJson(Map<String, dynamic> json) => ProjectLink(
    id: json['id']?.toString() ?? '',
    label: json['label']?.toString() ?? '',
    url: json['url']?.toString() ?? '',
    displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson(String projectId) => {
    'project_id': projectId,
    'label': label,
    'url': url,
    'display_order': displayOrder,
  };
}

class PortfolioProject {
  const PortfolioProject({
    required this.id,
    required this.slug,
    required this.titleAr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.category,
    required this.technologies,
    required this.media,
    required this.links,
    this.client = '',
    this.year = '',
    this.featured = false,
    this.published = false,
    this.displayOrder = 0,
  });

  final String id;
  final String slug;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final String descriptionAr;
  final String descriptionEn;
  final String category;
  final List<String> technologies;
  final List<ProjectMedia> media;
  final List<ProjectLink> links;
  final String client;
  final String year;
  final bool featured;
  final bool published;
  final int displayOrder;

  String title(bool isArabic) =>
      isArabic && titleAr.isNotEmpty ? titleAr : titleEn;
  String summary(bool isArabic) =>
      isArabic && summaryAr.isNotEmpty ? summaryAr : summaryEn;
  String description(bool isArabic) =>
      isArabic && descriptionAr.isNotEmpty ? descriptionAr : descriptionEn;

  ProjectMedia? get cover {
    for (final item in media) {
      if (item.type == ProjectMediaType.image) return item;
    }
    return media.isEmpty ? null : media.first;
  }

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    final media =
        (json['project_media'] as List? ?? const [])
            .map((item) => ProjectMedia.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    final links =
        (json['project_links'] as List? ?? const [])
            .map((item) => ProjectLink.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return PortfolioProject(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      titleAr: json['title_ar']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      summaryAr: json['summary_ar']?.toString() ?? '',
      summaryEn: json['summary_en']?.toString() ?? '',
      descriptionAr: json['description_ar']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Other',
      technologies: List<String>.from(
        json['technologies'] as List? ?? const [],
      ),
      media: media,
      links: links,
      client: json['client']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      featured: json['featured'] == true,
      published: json['published'] == true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toProjectJson() => {
    'slug': slug,
    'title_ar': titleAr,
    'title_en': titleEn,
    'summary_ar': summaryAr,
    'summary_en': summaryEn,
    'description_ar': descriptionAr,
    'description_en': descriptionEn,
    'category': category,
    'technologies': technologies,
    'client': client,
    'year': year,
    'featured': featured,
    'published': published,
    'display_order': displayOrder,
  };

  PortfolioProject copyWith({
    String? id,
    String? slug,
    String? titleAr,
    String? titleEn,
    String? summaryAr,
    String? summaryEn,
    String? descriptionAr,
    String? descriptionEn,
    String? category,
    List<String>? technologies,
    List<ProjectMedia>? media,
    List<ProjectLink>? links,
    String? client,
    String? year,
    bool? featured,
    bool? published,
    int? displayOrder,
  }) {
    return PortfolioProject(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      summaryAr: summaryAr ?? this.summaryAr,
      summaryEn: summaryEn ?? this.summaryEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      category: category ?? this.category,
      technologies: technologies ?? this.technologies,
      media: media ?? this.media,
      links: links ?? this.links,
      client: client ?? this.client,
      year: year ?? this.year,
      featured: featured ?? this.featured,
      published: published ?? this.published,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
