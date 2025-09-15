import 'package:flutter/material.dart';
import 'local_storage_service.dart';
import '../utils/logger.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  // Supported languages with their display names
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'nativeName': 'English'},
    'es': {'name': 'Spanish', 'nativeName': 'Español'},
    'fr': {'name': 'French', 'nativeName': 'Français'},
    'de': {'name': 'German', 'nativeName': 'Deutsch'},
    'it': {'name': 'Italian', 'nativeName': 'Italiano'},
    'pt': {'name': 'Portuguese', 'nativeName': 'Português'},
    'zh': {'name': 'Chinese', 'nativeName': '中文'},
    'ja': {'name': 'Japanese', 'nativeName': '日本語'},
    'ko': {'name': 'Korean', 'nativeName': '한국어'},
    'ar': {'name': 'Arabic', 'nativeName': 'العربية'},
  };

  // Get supported locales
  static List<Locale> get supportedLocales {
    return supportedLanguages.keys.map((code) => Locale(code)).toList();
  }

  // Initialize language service
  Future<void> initialize() async {
    try {
      // Load language preference from local storage
      final preferences = await LocalStorageService.getUserPreferences();
      final languageCode = preferences.language;

      if (supportedLanguages.containsKey(languageCode)) {
        _currentLocale = Locale(languageCode);
        Logger.info('Language service initialized with locale: $languageCode');
      } else {
        // Fallback to English if unsupported language
        _currentLocale = const Locale('en');
        Logger.warning(
          'Unsupported language code: $languageCode, falling back to English',
        );
      }
    } catch (e, st) {
      Logger.error(
        'Error initializing language service',
        error: e,
        stackTrace: st,
      );
      _currentLocale = const Locale('en');
    }
  }

  // Change language
  Future<bool> changeLanguage(String languageCode) async {
    try {
      if (!supportedLanguages.containsKey(languageCode)) {
        Logger.warning(
          'Attempted to change to unsupported language: $languageCode',
        );
        return false;
      }

      final newLocale = Locale(languageCode);

      // Update local storage
      final preferences = await LocalStorageService.getUserPreferences();
      final updatedPreferences = preferences.copyWith(language: languageCode);
      final localSuccess = await LocalStorageService.saveUserPreferences(
        updatedPreferences,
      );

      if (!localSuccess) {
        Logger.error('Failed to save language preference to local storage');
        return false;
      }

      // Update current locale and notify listeners
      _currentLocale = newLocale;
      notifyListeners();

      Logger.info('Language changed to: $languageCode');
      return true;
    } catch (e, st) {
      Logger.error(
        'Error changing language to $languageCode',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  // Get language display name
  String getLanguageDisplayName(
    String languageCode, {
    bool useNativeName = false,
  }) {
    final language = supportedLanguages[languageCode];
    if (language == null) return 'Unknown';

    return useNativeName ? language['nativeName']! : language['name']!;
  }

  // Get current language display name
  String getCurrentLanguageDisplayName({bool useNativeName = false}) {
    return getLanguageDisplayName(
      _currentLocale.languageCode,
      useNativeName: useNativeName,
    );
  }

  // Check if language is RTL
  bool isRTL(String languageCode) {
    return languageCode == 'ar'; // Add more RTL languages as needed
  }

  // Get text direction for current language
  TextDirection get textDirection {
    return isRTL(_currentLocale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
