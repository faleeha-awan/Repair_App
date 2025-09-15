import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> _initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _isInitialized = true;
  }

  static Future<void> speak(String text, {String? languageCode}) async {
    await _initialize();
    
    if (languageCode != null) {
      await _setLanguageForTTS(languageCode);
    }
    
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  static Future<void> _setLanguageForTTS(String languageCode) async {
    final Map<String, String> ttsLanguageMap = {
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh': 'zh-CN',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
    };

    final ttsLanguage = ttsLanguageMap[languageCode] ?? 'en-US';
    await _flutterTts.setLanguage(ttsLanguage);
  }

  static Future<bool> isLanguageAvailable(String languageCode) async {
    await _initialize();
    final languages = await _flutterTts.getLanguages;
    final ttsLanguage = _getTTSLanguageCode(languageCode);
    return languages?.contains(ttsLanguage) ?? false;
  }

  static String _getTTSLanguageCode(String languageCode) {
    final Map<String, String> ttsLanguageMap = {
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh': 'zh-CN',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
    };
    return ttsLanguageMap[languageCode] ?? 'en-US';
  }
}