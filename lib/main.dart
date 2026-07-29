import 'package:flutter/material.dart';

import 'config/supabase_config.dart';
import 'screens/admin/admin_gate.dart';
import 'screens/home_screen.dart';
import 'theme/portfolio_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
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
      theme: PortfolioTheme.dark(isArabic: isArabic),
      onGenerateRoute: (settings) {
        if (settings.name == '/admin') {
          return MaterialPageRoute<void>(
            builder: (_) => const AdminGate(),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => HomeScreen(
            languageCode: _languageCode,
            onLanguageToggle: _toggleLanguage,
          ),
          settings: settings,
        );
      },
    );
  }
}
