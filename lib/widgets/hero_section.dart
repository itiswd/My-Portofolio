import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/portfolio_theme.dart';
import '../utils/app_localizations.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.languageCode,
    required this.onLanguageToggle,
    required this.onViewWork,
  });

  final String languageCode;
  final VoidCallback onLanguageToggle;
  final VoidCallback onViewWork;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 860;
    return Container(
      constraints: const BoxConstraints(minHeight: 760),
      padding: EdgeInsets.fromLTRB(
        width < 600 ? 20 : 48,
        compact ? 62 : 96,
        width < 600 ? 20 : 48,
        90,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: compact
              ? Column(
                  children: [
                    _HeroCopy(
                      languageCode: widget.languageCode,
                      onViewWork: widget.onViewWork,
                    ),
                    const SizedBox(height: 54),
                    _DeveloperVisual(animation: _motion),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: _HeroCopy(
                        languageCode: widget.languageCode,
                        onViewWork: widget.onViewWork,
                      ),
                    ),
                    const SizedBox(width: 72),
                    Expanded(
                      flex: 9,
                      child: _DeveloperVisual(animation: _motion),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.languageCode,
    required this.onViewWork,
  });

  final String languageCode;
  final VoidCallback onViewWork;

  bool get isArabic => languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations(languageCode);
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = width < 520
        ? 48.0
        : width < 1100
            ? 62.0
            : 76.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: PortfolioColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: PortfolioColors.accent.withValues(alpha: 0.24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: PortfolioColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PortfolioColors.accent,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 9),
              Text(
                isArabic
                    ? 'متاح لفرص العمل والمشاريع'
                    : 'AVAILABLE FOR WORK & COLLABORATION',
                style: const TextStyle(
                  color: PortfolioColors.accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          localizations.translate('hi_im'),
          style: const TextStyle(
            color: PortfolioColors.muted,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        GradientText(
          localizations.translate('name'),
          style: TextStyle(
            fontSize: titleSize,
            height: 1.04,
            letterSpacing: -2.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isArabic
              ? 'أحوّل الأفكار المعقدة إلى منتجات رقمية بسيطة.'
              : 'I turn complex ideas into simple digital products.',
          style: TextStyle(
            color: PortfolioColors.text,
            fontSize: width < 600 ? 25 : 34,
            height: 1.25,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 690),
          child: Text(
            localizations.translate('hero_description'),
            style: const TextStyle(
              color: PortfolioColors.muted,
              fontSize: 17,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onViewWork,
              icon: const Icon(Icons.arrow_downward_rounded, size: 19),
              label: Text(localizations.translate('view_work')),
            ),
            OutlinedButton.icon(
              onPressed: _openCv,
              icon: const Icon(Icons.download_rounded, size: 19),
              label: Text(localizations.translate('download_cv')),
            ),
          ],
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 22,
          runSpacing: 18,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _SocialLink(
              label: 'GitHub',
              icon: Icons.code_rounded,
              url: 'https://github.com/itiswd',
            ),
            _SocialLink(
              label: 'LinkedIn',
              icon: Icons.work_outline_rounded,
              url:
                  'https://www.linkedin.com/in/ibrahim-tharwat-18aa77323',
            ),
            _SocialLink(
              label: 'Email',
              icon: Icons.alternate_email_rounded,
              url: 'mailto:ibrahimthswd@gmail.com',
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openCv() async {
    await launchUrl(
      Uri.parse('assets/assets/files/CV.pdf'),
      webOnlyWindowName: '_blank',
    );
  }
}

class _SocialLink extends StatefulWidget {
  const _SocialLink({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(widget.url),
          webOnlyWindowName: '_blank',
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            color: _hovered
                ? PortfolioColors.primary
                : PortfolioColors.muted,
            fontWeight: FontWeight.w700,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: _hovered
                    ? PortfolioColors.primary
                    : PortfolioColors.muted,
              ),
              const SizedBox(width: 8),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeveloperVisual extends StatelessWidget {
  const _DeveloperVisual({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final phase = animation.value * math.pi * 2;
        return Transform.translate(
          offset: Offset(0, math.sin(phase) * 7),
          child: child,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 510,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF15243A), Color(0xFF0A101C)],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: PortfolioColors.border),
              boxShadow: [
                BoxShadow(
                  color: PortfolioColors.secondary.withValues(alpha: 0.14),
                  blurRadius: 70,
                  offset: const Offset(20, 26),
                ),
              ],
            ),
            child: Column(
              children: [
                const _WindowBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _CodeLine(
                          number: '01',
                          parts: [
                            _CodePart('class ', Color(0xFFB99AFF)),
                            _CodePart('Ibrahim ', PortfolioColors.primary),
                            _CodePart('{', PortfolioColors.text),
                          ],
                        ),
                        const _CodeLine(
                          number: '02',
                          indent: 18,
                          parts: [
                            _CodePart('final ', Color(0xFFB99AFF)),
                            _CodePart('focus ', PortfolioColors.text),
                            _CodePart('= ', PortfolioColors.muted),
                            _CodePart(
                              "'meaningful products';",
                              Color(0xFFB6FF6A),
                            ),
                          ],
                        ),
                        const _CodeLine(
                          number: '03',
                          indent: 18,
                          parts: [
                            _CodePart('final ', Color(0xFFB99AFF)),
                            _CodePart('stack ', PortfolioColors.text),
                            _CodePart('= ', PortfolioColors.muted),
                            _CodePart(
                              '[Flutter, Supabase, IoT];',
                              Color(0xFFFFC66D),
                            ),
                          ],
                        ),
                        const _CodeLine(
                          number: '04',
                          indent: 18,
                          parts: [
                            _CodePart('Future', Color(0xFFB99AFF)),
                            _CodePart('<Product> ', PortfolioColors.primary),
                            _CodePart('build', PortfolioColors.text),
                            _CodePart('() async {', PortfolioColors.muted),
                          ],
                        ),
                        const _CodeLine(
                          number: '05',
                          indent: 36,
                          parts: [
                            _CodePart('return ', Color(0xFFB99AFF)),
                            _CodePart('ideas', PortfolioColors.text),
                            _CodePart('.ship();', PortfolioColors.primary),
                          ],
                        ),
                        const _CodeLine(
                          number: '06',
                          indent: 18,
                          parts: [_CodePart('}', PortfolioColors.muted)],
                        ),
                        const _CodeLine(
                          number: '07',
                          parts: [_CodePart('}', PortfolioColors.text)],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.24),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: PortfolioColors.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: PortfolioColors.accent,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Build successful • Ready to ship',
                                  style: TextStyle(
                                    color: PortfolioColors.muted,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
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
          const PositionedDirectional(
            start: -24,
            top: 82,
            child: _FloatingTag(
              icon: Icons.flutter_dash_rounded,
              label: 'Flutter',
            ),
          ),
          const PositionedDirectional(
            end: -20,
            bottom: 70,
            child: _FloatingTag(
              icon: Icons.bolt_rounded,
              label: 'Supabase',
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowBar extends StatelessWidget {
  const _WindowBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF111B2B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(bottom: BorderSide(color: PortfolioColors.border)),
      ),
      child: const Row(
        children: [
          _WindowDot(Color(0xFFFF647C)),
          SizedBox(width: 7),
          _WindowDot(Color(0xFFFFC66D)),
          SizedBox(width: 7),
          _WindowDot(PortfolioColors.accent),
          Spacer(),
          Text(
            'ibrahim.dart',
            style: TextStyle(
              color: PortfolioColors.muted,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Spacer(),
          SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CodeLine extends StatelessWidget {
  const _CodeLine({
    required this.number,
    required this.parts,
    this.indent = 0,
  });

  final String number;
  final List<_CodePart> parts;
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white24,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: indent),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: parts
                    .map(
                      (part) => TextSpan(
                        text: part.text,
                        style: TextStyle(color: part.color),
                      ),
                    )
                    .toList(),
              ),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodePart {
  const _CodePart(this.text, this.color);
  final String text;
  final Color color;
}

class _FloatingTag extends StatelessWidget {
  const _FloatingTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PortfolioPanel(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: PortfolioColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: PortfolioColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
