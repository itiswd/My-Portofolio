import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onSkillsPressed;
  final VoidCallback onProjectsPressed;
  final VoidCallback onContactPressed;
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const CustomAppBar({
    super.key,
    required this.onHomePressed,
    required this.onAboutPressed,
    required this.onSkillsPressed,
    required this.onProjectsPressed,
    required this.onContactPressed,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    final localizations = AppLocalizations(isArabic ? 'ar' : 'en');
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27).withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Name
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 12),
                Text(
                  localizations.translate('name'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          // Navigation buttons and language toggle
          Row(
            children: [
              if (isMobile)
                _buildMobileMenu(context)
              else
                _buildDesktopMenu(localizations),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  isArabic ? Icons.language : Icons.translate,
                  color: Colors.white,
                ),
                tooltip: isArabic ? 'English' : 'العربية',
                onPressed: onLanguageToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopMenu(AppLocalizations localizations) {
    return Row(
      children: [
        _NavButton(
          label: localizations.translate('home'),
          onPressed: onHomePressed,
        ),
        _NavButton(
          label: localizations.translate('about'),
          onPressed: onAboutPressed,
        ),
        _NavButton(
          label: localizations.translate('skills'),
          onPressed: onSkillsPressed,
        ),
        _NavButton(
          label: localizations.translate('projects'),
          onPressed: onProjectsPressed,
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onContactPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B4DB),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            localizations.translate('contact'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMenu(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF1A1E3C),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MobileNavItem(label: 'Home', onPressed: onHomePressed),
                _MobileNavItem(label: 'About', onPressed: onAboutPressed),
                _MobileNavItem(label: 'Skills', onPressed: onSkillsPressed),
                _MobileNavItem(label: 'Projects', onPressed: onProjectsPressed),
                _MobileNavItem(label: 'Contact', onPressed: onContactPressed),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavButton({required this.label, required this.onPressed});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isHovered ? const Color(0xFF00B4DB) : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MobileNavItem({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onPressed();
      },
    );
  }
}
