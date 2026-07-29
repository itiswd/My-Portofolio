import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/portfolio_theme.dart';
import '../utils/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
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

  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onSkillsPressed;
  final VoidCallback onProjectsPressed;
  final VoidCallback onContactPressed;
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 820;
    final localizations = AppLocalizations(isArabic ? 'ar' : 'en');
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 76,
          padding: EdgeInsets.symmetric(horizontal: mobile ? 18 : 42),
          decoration: BoxDecoration(
            color: PortfolioColors.background.withValues(alpha: 0.82),
            border: const Border(
              bottom: BorderSide(color: PortfolioColors.border),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1340),
              child: Row(
                children: [
                  InkWell(
                    onTap: onHomePressed,
                    borderRadius: BorderRadius.circular(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                PortfolioColors.primary,
                                PortfolioColors.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: PortfolioColors.primary.withValues(
                                  alpha: 0.18,
                                ),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'IT',
                              style: TextStyle(
                                color: PortfolioColors.background,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        if (!mobile) ...[
                          const SizedBox(width: 12),
                          Text(
                            localizations.translate('name'),
                            style: const TextStyle(
                              color: PortfolioColors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (mobile)
                    IconButton(
                      onPressed: () => _showMobileMenu(context, localizations),
                      icon: const Icon(Icons.menu_rounded),
                    )
                  else ...[
                    _NavItem(
                      label: localizations.translate('home'),
                      onTap: onHomePressed,
                    ),
                    _NavItem(
                      label: localizations.translate('about'),
                      onTap: onAboutPressed,
                    ),
                    _NavItem(
                      label: localizations.translate('skills'),
                      onTap: onSkillsPressed,
                    ),
                    _NavItem(
                      label: localizations.translate('projects'),
                      onTap: onProjectsPressed,
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: onContactPressed,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                      ),
                      child: Text(localizations.translate('contact')),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: isArabic ? 'English' : 'العربية',
                    onPressed: onLanguageToggle,
                    style: IconButton.styleFrom(
                      foregroundColor: PortfolioColors.text,
                      backgroundColor: Colors.white.withValues(alpha: 0.045),
                    ),
                    icon: const Icon(Icons.language_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMobileMenu(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final items = [
      (localizations.translate('home'), onHomePressed),
      (localizations.translate('about'), onAboutPressed),
      (localizations.translate('skills'), onSkillsPressed),
      (localizations.translate('projects'), onProjectsPressed),
      (localizations.translate('contact'), onContactPressed),
    ];
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: PortfolioColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in items)
                ListTile(
                  title: Text(
                    item.$1,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.arrow_forward_rounded, size: 18),
                  onTap: () {
                    Navigator.pop(context);
                    item.$2();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          foregroundColor:
              _hovered ? PortfolioColors.primary : PortfolioColors.muted,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          style: TextStyle(
            color:
                _hovered ? PortfolioColors.primary : PortfolioColors.muted,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
