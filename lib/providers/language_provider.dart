import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/local_storage_service.dart';
import '../core/localization/app_localizations.dart';
import 'auth_provider.dart';

const Map<String, String> supportedLanguages = {
  'en': 'English',
  'ta': 'Tamil',
  'te': 'Telugu',
};

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return LanguageNotifier(storage.languageCode, storage);
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier(String initialLanguage, this._storage)
    : super(
        supportedLanguages.containsKey(initialLanguage)
            ? initialLanguage
            : 'en',
      );

  final LocalStorageService _storage;

  Future<void> setLanguage(String code) async {
    if (!supportedLanguages.containsKey(code)) return;
    state = code;
    AppLocale.setLanguage(code);
    await _storage.setLanguageCode(code);
  }

  String get label => supportedLanguages[state] ?? 'English';
}
