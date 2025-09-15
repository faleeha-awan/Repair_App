import 'package:translator/translator.dart';

class TranslationService {
  static final GoogleTranslator _translator = GoogleTranslator();

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh': 'Chinese',
    'ar': 'Arabic',
    'hi': 'Hindi',
  };

  static Future<String> translateText(
    String text,
    String targetLanguage,
  ) async {
    try {
      if (targetLanguage == 'en') {
        return text; // No translation needed for English
      }

      final translation = await _translator.translate(text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      // Return original text if translation fails
      return text;
    }
  }

  static String getLanguageName(String languageCode) {
    return supportedLanguages[languageCode] ?? 'Unknown';
  }

  static List<String> getSupportedLanguageCodes() {
    return supportedLanguages.keys.toList();
  }
}
