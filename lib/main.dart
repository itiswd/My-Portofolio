import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  String _languageCode = 'en';

  void _toggleLanguage() {
    setState(() {
      _languageCode = _languageCode == 'en' ? 'ar' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _languageCode == 'ar';
    return MaterialApp(
      title: isArabic
          ? 'إبراهيم ثروت - مطور فلاتر'
          : 'Ibrahim Tharwat - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        fontFamily: isArabic ? 'Cairo' : 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
        ),
      ),
      home: HomeScreen(
        languageCode: _languageCode,
        onLanguageToggle: _toggleLanguage,
      ),
    );
  }
}
