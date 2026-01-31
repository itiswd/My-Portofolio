import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E3C).withOpacity(0.3),
      ),
      child: Column(
        children: [
          _buildSectionTitle('Skills & Technologies'),
          const SizedBox(height: 60),
          _buildSkillsGrid(isMobile),
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

  Widget _buildSkillsGrid(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      mainAxisSpacing: 30,
      crossAxisSpacing: 30,
      childAspectRatio: isMobile ? 1 : 1.2,
      children: [
        _buildSkillCard(
          'Flutter',
          Icons.phone_android,
          0.95,
          const Color(0xFF02569B),
        ),
        _buildSkillCard(
          'Dart',
          Icons.code,
          0.90,
          const Color(0xFF00B4AB),
        ),
        _buildSkillCard(
          'Firebase',
          Icons.cloud,
          0.85,
          const Color(0xFFFFA000),
        ),
        _buildSkillCard(
          'State Mgmt',
          Icons.developer_board,
          0.88,
          const Color(0xFF00B4DB),
        ),
        _buildSkillCard(
          'REST API',
          Icons.api,
          0.87,
          const Color(0xFF4CAF50),
        ),
        _buildSkillCard(
          'Git',
          Icons.source,
          0.92,
          const Color(0xFFF05032),
        ),
        _buildSkillCard(
          'UI/UX',
          Icons.design_services,
          0.83,
          const Color(0xFFFF6F00),
        ),
        _buildSkillCard(
          'SQLite',
          Icons.storage,
          0.80,
          const Color(0xFF003B57),
        ),
      ],
    );
  }

  Widget _buildSkillCard(
    String name,
    IconData icon,
    double proficiency,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: proficiency,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(proficiency * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
