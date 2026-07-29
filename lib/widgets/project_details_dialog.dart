import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../models/portfolio_project.dart';

class ProjectDetailsDialog extends StatefulWidget {
  const ProjectDetailsDialog({
    super.key,
    required this.project,
    required this.isArabic,
  });

  final PortfolioProject project;
  final bool isArabic;

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  final _pageController = PageController();
  int _selectedMedia = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 820;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 36,
        vertical: compact ? 16 : 32,
      ),
      backgroundColor: const Color(0xFF0C1120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240, maxHeight: 880),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: compact
                  ? Column(
                      children: [
                        _buildGallery(compact),
                        _buildContent(compact),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildGallery(compact)),
                        Expanded(flex: 5, child: _buildContent(compact)),
                      ],
                    ),
            ),
            PositionedDirectional(
              end: 14,
              top: 14,
              child: IconButton.filled(
                tooltip: widget.isArabic ? 'إغلاق' : 'Close',
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xD9131929),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(bool compact) {
    final media = widget.project.media;
    if (media.isEmpty) {
      return Container(
        height: compact ? 300 : 720,
        color: const Color(0xFF151C31),
        child: const Center(
          child: Icon(
            Icons.auto_awesome_mosaic_outlined,
            color: Colors.white24,
            size: 90,
          ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(bottom: compact ? 0 : 18),
      child: Column(
        children: [
          SizedBox(
            height: compact ? 330 : 650,
            child: PageView.builder(
              controller: _pageController,
              itemCount: media.length,
              onPageChanged: (value) => setState(() => _selectedMedia = value),
              itemBuilder: (_, index) => _MediaView(media: media[index]),
            ),
          ),
          if (media.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: SizedBox(
                height: 62,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 9),
                  itemBuilder: (_, index) {
                    final item = media[index];
                    final selected = _selectedMedia == index;
                    return InkWell(
                      onTap: () => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 86,
                        decoration: BoxDecoration(
                          color: const Color(0xFF151C31),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF38D6E7)
                                : Colors.white12,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: item.type == ProjectMediaType.image
                            ? Image.network(item.url, fit: BoxFit.cover)
                            : const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white70,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(bool compact) {
    final project = widget.project;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 24 : 34,
        compact ? 28 : 70,
        compact ? 24 : 34,
        34,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF38D6E7),
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.title(widget.isArabic),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            project.description(widget.isArabic),
            style: const TextStyle(
              color: Color(0xFFB7C0D6),
              fontSize: 15,
              height: 1.75,
            ),
          ),
          if (project.client.isNotEmpty || project.year.isNotEmpty) ...[
            const SizedBox(height: 26),
            Row(
              children: [
                if (project.client.isNotEmpty)
                  Expanded(
                    child: _Meta(
                      label: widget.isArabic ? 'العميل' : 'CLIENT',
                      value: project.client,
                    ),
                  ),
                if (project.year.isNotEmpty)
                  Expanded(
                    child: _Meta(
                      label: widget.isArabic ? 'السنة' : 'YEAR',
                      value: project.year,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 26),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38D6E7).withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF38D6E7).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF7EE8F2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (project.links.isNotEmpty) ...[
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: project.links
                  .map(
                    (link) => FilledButton.icon(
                      onPressed: () => _launch(link.url),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF38D6E7),
                        foregroundColor: const Color(0xFF07121F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 14,
                        ),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 17),
                      label: Text(
                        link.label,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _launch(String value) async {
    final uri = Uri.tryParse(value);
    if (uri != null) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
}

class _MediaView extends StatelessWidget {
  const _MediaView({required this.media});

  final ProjectMedia media;

  @override
  Widget build(BuildContext context) {
    return switch (media.type) {
      ProjectMediaType.image => InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.network(
          media.url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white30,
              size: 64,
            ),
          ),
        ),
      ),
      ProjectMediaType.video => _NetworkVideo(url: media.url),
      ProjectMediaType.externalVideo => _ExternalVideo(media: media),
    };
  }
}

class _NetworkVideo extends StatefulWidget {
  const _NetworkVideo({required this.url});

  final String url;

  @override
  State<_NetworkVideo> createState() => _NetworkVideoState();
}

class _NetworkVideoState extends State<_NetworkVideo> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initialization = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton.filled(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  iconSize: 38,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExternalVideo extends StatelessWidget {
  const _ExternalVideo({required this.media});

  final ProjectMedia media;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (media.thumbnailUrl?.isNotEmpty == true)
          Image.network(media.thumbnailUrl!, fit: BoxFit.cover)
        else
          const ColoredBox(color: Color(0xFF161D31)),
        const DecoratedBox(decoration: BoxDecoration(color: Color(0x55000000))),
        Center(
          child: FilledButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(media.url);
              if (uri != null) {
                await launchUrl(uri, webOnlyWindowName: '_blank');
              }
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('WATCH VIDEO'),
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
