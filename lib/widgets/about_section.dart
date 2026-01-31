import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 80,
      ),
      child: Column(
        children: [
          _buildSectionTitle('About Me'),
          const SizedBox(height: 60),
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildAboutContent(),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildExperienceCards(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildAboutContent(),
        const SizedBox(height: 40),
        _buildExperienceCards(),
      ],
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I\'m a passionate Flutter developer with expertise in creating '
          'beautiful, high-performance mobile applications.',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFB0B0B0),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'With over 3 years of experience in mobile development, I specialize in:',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFB0B0B0),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        _buildSkillPoint('Cross-platform mobile development with Flutter'),
        _buildSkillPoint('State management (Provider, Riverpod, Bloc)'),
        _buildSkillPoint('RESTful APIs and Firebase integration'),
        _buildSkillPoint('Clean architecture and SOLID principles'),
        _buildSkillPoint('UI/UX design implementation'),
        const SizedBox(height: 30),
        const Text(
          'I\'m always eager to learn new technologies and take on challenging projects. '
          'Let\'s build something amazing together!',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFB0B0B0),
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF00B4DB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFB0B0B0),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCards() {
    return Column(
      children: [
        _buildExperienceCard(
          'Education',
          'Bachelor in Computer Science',
          '2018 - 2022',
          Icons.school,
        ),
        const SizedBox(height: 20),
        _buildExperienceCard(
          'Experience',
          'Flutter Developer',
          '2021 - Present',
          Icons.work,
        ),
        const SizedBox(height: 20),
        _buildExperienceCard(
          'Certifications',
          'Flutter Developer Certified',
          '2022',
          Icons.card_membership,
        ),
      ],
    );
  }

  Widget _buildExperienceCard(
    String title,
    String subtitle,
    String period,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4DB).withOpacity(0.1),
            const Color(0xFF0083B0).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF00B4DB).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00B4DB),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0B0B0),
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
