import 'package:flutter/material.dart';

import '../theme/portfolio_theme.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: PortfolioColors.surface,
        border: Border(top: BorderSide(color: PortfolioColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 14,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flutter_dash_rounded,
                    color: PortfolioColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'Designed & built with Flutter',
                    style: TextStyle(
                      color: PortfolioColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '© ${DateTime.now().year} Ibrahim Tharwat. All rights reserved.',
                style: const TextStyle(
                  color: PortfolioColors.muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
