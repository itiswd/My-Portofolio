import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../theme/portfolio_theme.dart';
import '../utils/app_localizations.dart';
import 'common/section_heading.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeProvider);
    final localizations = AppLocalizations(languageCode);
    final isArabic = languageCode == 'ar';
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 900;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width < 600 ? 20 : 48,
        vertical: 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                eyebrow: isArabic ? 'نبذة عني' : 'ABOUT',
                title: isArabic
                    ? 'هندسة في التفكير، وبساطة في التنفيذ.'
                    : 'Engineering thinking. Human-centered execution.',
                description: localizations.translate('about_description_1'),
              ),
              const SizedBox(height: 52),
              if (compact)
                Column(
                  children: [
                    _StoryCard(
                      isArabic: isArabic,
                      localizations: localizations,
                    ),
                    const SizedBox(height: 20),
                    _Journey(localizations: localizations),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _StoryCard(
                        isArabic: isArabic,
                        localizations: localizations,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 5,
                      child: _Journey(localizations: localizations),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.isArabic,
    required this.localizations,
  });

  final bool isArabic;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final points = List.generate(
      4,
      (index) => localizations.translate('about_point_${index + 1}'),
    );
    return PortfolioPanel(
      padding: const EdgeInsets.all(30),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF121F31), Color(0xFF0B121F)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      PortfolioColors.primary,
                      PortfolioColors.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: PortfolioColors.background,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isArabic
                      ? 'أبني منتجات، مش مجرد شاشات.'
                      : 'I build products, not just screens.',
                  style: const TextStyle(
                    color: PortfolioColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            localizations.translate('about_description_3'),
            style: const TextStyle(
              color: PortfolioColors.muted,
              fontSize: 16,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 26),
          for (final point in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: PortfolioColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: PortfolioColors.primary,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        color: PortfolioColors.text,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Journey extends StatelessWidget {
  const _Journey({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _JourneyItem(
          icon: Icons.work_outline_rounded,
          label: localizations.translate('experience'),
          title: localizations.translate('experience_title'),
          period: localizations.translate('experience_period'),
          color: PortfolioColors.primary,
        ),
        const SizedBox(height: 16),
        _JourneyItem(
          icon: Icons.school_outlined,
          label: localizations.translate('education'),
          title: localizations.translate('education_title'),
          period: localizations.translate('education_period'),
          color: PortfolioColors.secondary,
        ),
        const SizedBox(height: 16),
        _JourneyItem(
          icon: Icons.workspace_premium_outlined,
          label: localizations.translate('certifications'),
          title: localizations.translate('certifications_title'),
          period: localizations.translate('certifications_period'),
          color: PortfolioColors.accent,
        ),
      ],
    );
  }
}

class _JourneyItem extends StatefulWidget {
  const _JourneyItem({
    required this.icon,
    required this.label,
    required this.title,
    required this.period,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String title;
  final String period;
  final Color color;

  @override
  State<_JourneyItem> createState() => _JourneyItemState();
}

class _JourneyItemState extends State<_JourneyItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_hovered ? 7 : 0, 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: PortfolioColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? widget.color.withValues(alpha: 0.45)
                : PortfolioColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: widget.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PortfolioColors.text,
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.period,
                    style: const TextStyle(
                      color: PortfolioColors.muted,
                      fontSize: 12,
                    ),
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
