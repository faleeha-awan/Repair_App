import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/guide.dart';
import '../models/chat_message.dart';
import '../models/user_preferences.dart';
import '../models/manual.dart';

class LocalStorageService {
  static const String _userPreferencesKey = 'user_preferences';
  static const String _recentGuidesKey = 'recent_guides';
  static const String _savedGuidesKey = 'saved_guides';
  static const String _chatHistoryKey = 'chat_history';
  static const String _uploadedManualsKey = 'uploaded_manuals';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Ensure SharedPreferences is initialized
  static Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // User Preferences Methods
  static Future<UserPreferences> getUserPreferences() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_userPreferencesKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return UserPreferences.fromJson(json);
      }
      
      return UserPreferences.defaultPreferences();
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      // Return default preferences if there's an error
      return UserPreferences.defaultPreferences();
    }
  }

  static Future<bool> saveUserPreferences(UserPreferences preferences) async {
    try {
      final prefs = await _preferences;
      final jsonString = jsonEncode(preferences.toJson());
      return await prefs.setString(_userPreferencesKey, jsonString);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Recent Guides Methods
  static Future<List<Guide>> getRecentGuides() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_recentGuidesKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Guide.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return [];
    }
  }

  static Future<bool> saveRecentGuides(List<Guide> guides) async {
    try {
      final prefs = await _preferences;
      final jsonList = guides.map((guide) => guide.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_recentGuidesKey, jsonString);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> addRecentGuide(Guide guide) async {
    try {
      final recentGuides = await getRecentGuides();
      
      // Remove if already exists to avoid duplicates
      recentGuides.removeWhere((g) => g.id == guide.id);
      
      // Add to beginning
      recentGuides.insert(0, guide);
      
      // Limit to 10 recent guides
      if (recentGuides.length > 10) {
        recentGuides.removeRange(10, recentGuides.length);
      }
      
      return await saveRecentGuides(recentGuides);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> removeRecentGuide(String guideId) async {
    try {
      final recentGuides = await getRecentGuides();
      recentGuides.removeWhere((guide) => guide.id == guideId);
      return await saveRecentGuides(recentGuides);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Saved Guides Methods
  static Future<List<Guide>> getSavedGuides() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_savedGuidesKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Guide.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return [];
    }
  }

  static Future<bool> saveSavedGuides(List<Guide> guides) async {
    try {
      final prefs = await _preferences;
      final jsonList = guides.map((guide) => guide.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_savedGuidesKey, jsonString);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> addSavedGuide(Guide guide) async {
    try {
      final savedGuides = await getSavedGuides();
      
      // Check if guide is already saved
      if (!savedGuides.any((g) => g.id == guide.id)) {
        savedGuides.add(guide.copyWith(isBookmarked: true));
        return await saveSavedGuides(savedGuides);
      }
      
      return true; // Already saved
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> removeSavedGuide(String guideId) async {
    try {
      final savedGuides = await getSavedGuides();
      savedGuides.removeWhere((guide) => guide.id == guideId);
      return await saveSavedGuides(savedGuides);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Chat History Methods
  static Future<List<ChatMessage>> getChatHistory() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_chatHistoryKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return [];
    }
  }

  static Future<bool> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await _preferences;
      final jsonList = messages.map((message) => message.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_chatHistoryKey, jsonString);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> addChatMessage(ChatMessage message) async {
    try {
      final chatHistory = await getChatHistory();
      chatHistory.add(message);
      
      // Limit chat history to 1000 messages to prevent excessive storage
      if (chatHistory.length > 1000) {
        chatHistory.removeRange(0, chatHistory.length - 1000);
      }
      
      return await saveChatHistory(chatHistory);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> clearChatHistory() async {
    try {
      final prefs = await _preferences;
      return await prefs.remove(_chatHistoryKey);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Uploaded Manuals Methods
  static Future<List<Manual>> getUploadedManuals() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_uploadedManualsKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Manual.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return [];
    }
  }

  static Future<bool> saveUploadedManuals(List<Manual> manuals) async {
    try {
      final prefs = await _preferences;
      final jsonList = manuals.map((manual) => manual.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_uploadedManualsKey, jsonString);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> addUploadedManual(Manual manual) async {
    try {
      final uploadedManuals = await getUploadedManuals();
      uploadedManuals.add(manual);
      
      // Limit to 50 manuals to prevent excessive storage
      if (uploadedManuals.length > 50) {
        uploadedManuals.removeRange(0, uploadedManuals.length - 50);
      }
      
      return await saveUploadedManuals(uploadedManuals);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  static Future<bool> removeUploadedManual(String manualId) async {
    try {
      final uploadedManuals = await getUploadedManuals();
      uploadedManuals.removeWhere((manual) => manual.id == manualId);
      return await saveUploadedManuals(uploadedManuals);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Utility Methods
  static Future<bool> clearAllData() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_userPreferencesKey);
      await prefs.remove(_recentGuidesKey);
      await prefs.remove(_savedGuidesKey);
      await prefs.remove(_chatHistoryKey);
      await prefs.remove(_uploadedManualsKey);
      return true;
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return false;
    }
  }

  // Theme preference shortcuts
  static Future<bool> isDarkMode() async {
    final preferences = await getUserPreferences();
    return preferences.isDarkMode;
  }

  static Future<bool> setDarkMode(bool isDark) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(isDarkMode: isDark);
    return await saveUserPreferences(updatedPreferences);
  }
}