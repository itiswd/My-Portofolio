import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/supabase_config.dart';
import 'providers/locale_provider.dart';
import 'screens/admin/admin_gate.dart';
import 'screens/home_screen.dart';
import 'theme/portfolio_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeProvider);
    final isArabic = languageCode == 'ar';
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
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      },
    );
  }
}
