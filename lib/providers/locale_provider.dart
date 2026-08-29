import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<String> {
  @override
  String build() => 'en';

  void toggle() => state = state == 'en' ? 'ar' : 'en';
}

final localeProvider = NotifierProvider<LocaleNotifier, String>(
  LocaleNotifier.new,
);
