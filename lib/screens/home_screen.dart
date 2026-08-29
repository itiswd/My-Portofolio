import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../utils/app_localizations.dart';
import '../widgets/about_section.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/common/animated_portfolio_background.dart';
import '../widgets/common/scroll_reveal.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(localeProvider);
    final localizations = AppLocalizations(languageCode);
    final isArabic = localizations.isArabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedPortfolioBackground(),
            // Content
            Column(
              children: [
                CustomAppBar(
                  onHomePressed: () => _scrollToSection(_heroKey),
                  onAboutPressed: () => _scrollToSection(_aboutKey),
                  onSkillsPressed: () => _scrollToSection(_skillsKey),
                  onProjectsPressed: () => _scrollToSection(_projectsKey),
                  onContactPressed: () => _scrollToSection(_contactKey),
                  isArabic: isArabic,
                  onLanguageToggle: () =>
                      ref.read(localeProvider.notifier).toggle(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ScrollReveal(
                          key: _heroKey,
                          controller: _scrollController,
                          child: HeroSection(
                            onViewWork: () =>
                                _scrollToSection(_projectsKey),
                          ),
                        ),
                        ScrollReveal(
                          key: _aboutKey,
                          controller: _scrollController,
                          child: const AboutSection(),
                        ),
                        ScrollReveal(
                          key: _skillsKey,
                          controller: _scrollController,
                          child: const SkillsSection(),
                        ),
                        ScrollReveal(
                          key: _projectsKey,
                          controller: _scrollController,
                          child: const ProjectsSection(),
                        ),
                        ScrollReveal(
                          key: _contactKey,
                          controller: _scrollController,
                          child: const ContactSection(),
                        ),
                        ScrollReveal(
                          controller: _scrollController,
                          child: const FooterWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
