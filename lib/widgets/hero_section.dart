import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_localizations.dart';

class HeroSection extends StatelessWidget {
  final String languageCode;
  final VoidCallback onLanguageToggle;
  const HeroSection({
    super.key,
    required this.languageCode,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 80,
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildTextContent()),
        const SizedBox(width: 60),
        Expanded(flex: 2, child: _buildAnimatedCard()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildAnimatedCard(),
        const SizedBox(height: 40),
        _buildTextContent(),
      ],
    );
  }

  Widget _buildTextContent() {
    final localizations = AppLocalizations(languageCode);
    final isArabic = languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('hi_im'),
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFF00B4DB),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          localizations.translate('name'),
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          localizations.translate('title'),
          style: const TextStyle(
            fontSize: 32,
            color: Color(0xFFB0B0B0),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          localizations.translate('hero_description'),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFFB0B0B0),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildPrimaryButton(
              localizations.translate('view_work'),
              Icons.arrow_forward,
              () {},
            ),
            _buildSecondaryButton(
              localizations.translate('download_cv'),
              Icons.download,
              () async {
                const cvAssetPath = 'assets/files/CV.pdf';
                final uri = Uri.parse(cvAssetPath);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  final fileUri = Uri.file(cvAssetPath);
                  if (await canLaunchUrl(fileUri)) {
                    await launchUrl(fileUri);
                  }
                }
              },
            ),
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
        const SizedBox(height: 40),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildAnimatedCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4DB).withOpacity(0.1),
            const Color(0xFF0083B0).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00B4DB).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B4DB).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.code, size: 100, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          _buildStatCard('50+', 'Projects Completed'),
          const SizedBox(height: 15),
          _buildStatCard('3+', 'Years Experience'),
          const SizedBox(height: 15),
          _buildStatCard('100%', 'Client Satisfaction'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E3C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00B4DB),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00B4DB),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        side: const BorderSide(color: Color(0xFF00B4DB), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00B4DB),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0xFF00B4DB)),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        _buildSocialIcon('https://github.com/itiswd', Icons.code),
        const SizedBox(width: 15),
        _buildSocialIcon(
          'https://www.linkedin.com/in/ibrahim-tharwat-18aa77323?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
          Icons.business,
        ),
        const SizedBox(width: 15),
        _buildSocialIcon('mailto:ibrahimthswd@gmail.com', Icons.email),
      ],
    );
  }

  Widget _buildSocialIcon(String url, IconData icon) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E3C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00B4DB).withOpacity(0.3)),
        ),
        child: Icon(icon, color: const Color(0xFF00B4DB), size: 24),
      ),
    );
  }
}
