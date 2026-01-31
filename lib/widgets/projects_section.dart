import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
          _buildSectionTitle('Featured Projects'),
          const SizedBox(height: 20),
          const Text(
            'Here are some of my recent projects that showcase my skills',
            style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _buildProjectsGrid(isMobile),
          const SizedBox(height: 40),
          OutlinedButton(
            onPressed: () async {
              final uri = Uri.parse('https://github.com/itiswd');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              side: const BorderSide(color: Color(0xFF00B4DB), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All Projects on GitHub',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00B4DB),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Color(0xFF00B4DB)),
              ],
            ),
          ),
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

  Widget _buildProjectsGrid(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 3,
      mainAxisSpacing: 30,
      crossAxisSpacing: 30,
      childAspectRatio: isMobile ? 0.8 : 0.75,
      children: [
        _buildProjectCard(
          'October SCADA',
          'Station monitoring app with real-time MQTT data from sensors, pumps, and valves with responsive UI and animated displays',
          ['Flutter', 'MQTT', 'IoT'],
          'https://github.com/itiswd/october_scada',
          const Color(0xFF00B4DB),
        ),
        _buildProjectCard(
          'Auto Car Controller',
          'Bluetooth IoT app for Arduino car control with manual/automatic modes, connection management, and speed control',
          ['Flutter', 'Bluetooth', 'Arduino'],
          'https://github.com/itiswd/auto_car',
          const Color(0xFF4CAF50),
        ),
        _buildProjectCard(
          '3SA - Autism Support',
          'Educational app helping autistic children learn communication skills with interactive lessons and multimedia content',
          ['Flutter', 'Education', 'Multimedia'],
          'https://github.com/itiswd/3SA',
          const Color(0xFFFFA000),
        ),
        _buildProjectCard(
          'Fitness Tracker',
          'Workout and nutrition tracking app with clean architecture, progress charts, and local storage',
          ['Flutter', 'Charts', 'Local Storage'],
          'https://github.com/itiswd/fitness',
          const Color(0xFFE91E63),
        ),
        _buildProjectCard(
          'Bookify',
          'Book reading app with bookmarks, themes, reading history, and offline support using Hive database',
          ['Flutter', 'Hive', 'Offline'],
          'https://github.com/itiswd/bookify',
          const Color(0xFF9C27B0),
        ),
        _buildProjectCard(
          'Paqyat - Islamic App',
          'Published Islamic content app with Quran, Azkar, prayer times, and media using Firebase Storage',
          ['Flutter', 'Firebase', 'Islamic'],
          'https://github.com/itiswd/Paqyat',
          const Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    List<String> technologies,
    String githubUrl,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.phone_android,
                size: 60,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0B0B0),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: technologies
                        .map((tech) => _buildTechChip(tech, accentColor))
                        .toList(),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(githubUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          icon: Icon(Icons.code, color: accentColor, size: 18),
                          label: Text(
                            'View Code',
                            style: TextStyle(color: accentColor),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: accentColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String tech, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        tech,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
