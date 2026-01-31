import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';
import '../widgets/about_section.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';

class HomeScreen extends StatefulWidget {
  final String languageCode;
  final VoidCallback onLanguageToggle;

  const HomeScreen({
    super.key,
    required this.languageCode,
    required this.onLanguageToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final localizations = AppLocalizations(widget.languageCode);
    final isArabic = localizations.isArabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A0E27), Color(0xFF1A1E3C)],
                ),
              ),
            ),
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
                  onLanguageToggle: widget.onLanguageToggle,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        HeroSection(
                          key: _heroKey,
                          languageCode: widget.languageCode,
                          onLanguageToggle: widget.onLanguageToggle,
                        ),
                        AboutSection(key: _aboutKey),
                        SkillsSection(key: _skillsKey),
                        ProjectsSection(key: _projectsKey),
                        ContactSection(key: _contactKey),
                        FooterWidget(),
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
