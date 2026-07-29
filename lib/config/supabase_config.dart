import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static String _url = const String.fromEnvironment('SUPABASE_URL');
  static String _publishableKey = const String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get isConfigured =>
      _url.isNotEmpty && _publishableKey.isNotEmpty;

  static Future<void> initialize() async {
    await _loadLocalConfiguration();
    if (!isConfigured) return;

    await Supabase.initialize(
      url: _url,
      publishableKey: _publishableKey,
    );
  }

  static Future<void> _loadLocalConfiguration() async {
    if (isConfigured) return;

    try {
      final content = await rootBundle.loadString('config/supabase.json');
      final json = jsonDecode(content) as Map<String, dynamic>;
      _url = json['SUPABASE_URL']?.toString().trim() ?? '';
      _publishableKey =
          json['SUPABASE_PUBLISHABLE_KEY']?.toString().trim() ?? '';
    } catch (_) {
      // Without local configuration, the portfolio uses its demo projects.
    }
  }

  static SupabaseClient get client {
    if (!isConfigured) {
      throw StateError(
        'Supabase is not configured. Pass SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY with --dart-define.',
      );
    }
    return Supabase.instance.client;
  }
}
