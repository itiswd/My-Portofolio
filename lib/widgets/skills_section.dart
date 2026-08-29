import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../theme/portfolio_theme.dart';
import 'common/section_heading.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeProvider);
    final isArabic = languageCode == 'ar';
    final width = MediaQuery.sizeOf(context).width;
    final groups = [
      _SkillGroup(
        icon: Icons.phone_iphone_rounded,
        number: '01',
        title: isArabic ? 'تطبيقات الموبايل' : 'Mobile products',
        description: isArabic
            ? 'تطبيقات سريعة ومتجاوبة تعمل على أكثر من منصة.'
            : 'Fast, responsive cross-platform experiences from one codebase.',
        skills: const ['Flutter', 'Dart', 'Material 3', 'Responsive UI'],
        color: PortfolioColors.primary,
      ),
      _SkillGroup(
        icon: Icons.layers_outlined,
        number: '02',
        title: isArabic ? 'هندسة التطبيقات' : 'App architecture',
        description: isArabic
            ? 'كود منظم وقابل للتوسع والاختبار والصيانة.'
            : 'Maintainable systems designed for scale, testing and change.',
        skills: const ['Bloc / Cubit', 'Riverpod', 'Clean Architecture', 'SOLID'],
        color: PortfolioColors.secondary,
      ),
      _SkillGroup(
        icon: Icons.cloud_outlined,
        number: '03',
        title: isArabic ? 'الخدمات والبيانات' : 'Backend & data',
        description: isArabic
            ? 'ربط آمن مع قواعد البيانات والـAPIs والبيانات اللحظية.'
            : 'Secure APIs, cloud data, authentication and real-time flows.',
        skills: const ['Supabase', 'Firebase', 'REST APIs', 'Hive'],
        color: PortfolioColors.accent,
      ),
      _SkillGroup(
        icon: Icons.memory_rounded,
        number: '04',
        title: isArabic ? 'الأنظمة الذكية' : 'Connected systems',
        description: isArabic
            ? 'ربط الموبايل بالأجهزة والحساسات والأنظمة الصناعية.'
            : 'Mobile interfaces for hardware, sensors and industrial systems.',
        skills: const ['MQTT', 'Bluetooth', 'Arduino', 'IoT'],
        color: const Color(0xFFFFB86B),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 600 ? 20 : 48,
        vertical: 100,
      ),
      decoration: BoxDecoration(
        color: PortfolioColors.surface.withValues(alpha: 0.52),
        border: const Border.symmetric(
          horizontal: BorderSide(color: PortfolioColors.border),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                eyebrow: isArabic ? 'الخبرات' : 'CAPABILITIES',
                title: isArabic
                    ? 'الأدوات المناسبة، في المكان المناسب.'
                    : 'The right tools, applied with intent.',
                description: isArabic
                    ? 'خبرة عملية تغطي دورة المنتج من الفكرة والواجهة إلى البيانات والنشر.'
                    : 'Practical experience across the product lifecycle—from interface and architecture to data and deployment.',
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 980
                      ? 4
                      : constraints.maxWidth >= 600
                          ? 2
                          : 1;
                  const gap = 18.0;
                  final cardWidth =
                      (constraints.maxWidth - (columns - 1) * gap) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final group in groups)
                        SizedBox(
                          width: cardWidth,
                          child: _SkillCard(group: group),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillGroup {
  const _SkillGroup({
    required this.icon,
    required this.number,
    required this.title,
    required this.description,
    required this.skills,
    required this.color,
  });

  final IconData icon;
  final String number;
  final String title;
  final String description;
  final List<String> skills;
  final Color color;
}

class _SkillCard extends StatefulWidget {
  const _SkillCard({required this.group});

  final _SkillGroup group;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              group.color.withValues(alpha: _hovered ? 0.12 : 0.07),
              PortfolioColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: group.color.withValues(alpha: _hovered ? 0.48 : 0.19),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: group.color.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: group.color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(group.icon, color: group.color),
                ),
                const Spacer(),
                Text(
                  group.number,
                  style: TextStyle(
                    color: group.color.withValues(alpha: 0.55),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              group.title,
              style: const TextStyle(
                color: PortfolioColors.text,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              group.description,
              style: const TextStyle(
                color: PortfolioColors.muted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: group.skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: PortfolioColors.border),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: PortfolioColors.text,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
