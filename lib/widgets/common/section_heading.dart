import 'package:flutter/material.dart';

import '../../theme/portfolio_theme.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.centered = false,
  });

  final String eyebrow;
  final String title;
  final String description;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 2,
              color: PortfolioColors.primary,
            ),
            const SizedBox(width: 10),
            Text(
              eyebrow.toUpperCase(),
              style: const TextStyle(
                color: PortfolioColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: PortfolioColors.text,
            fontSize: width < 600 ? 34 : 48,
            height: 1.1,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 15),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            description,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              color: PortfolioColors.muted,
              fontSize: 16,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}
