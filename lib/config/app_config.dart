import 'package:flutter/foundation.dart';

/// Application configuration and constants
/// This centralizes all configuration values and makes them easy to modify
class AppConfig {
  // Prevent instantiation
  AppConfig._();

  // ============================================================================
  // APP INFORMATION
  // ============================================================================
  
  static const String appName = 'Repair Guide App';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // ============================================================================
  // API CONFIGURATION
  // ============================================================================
  
  /// Base API URL - change this when backend is ready
  static const String apiBaseUrl = kDebugMode 
      ? 'https://api-dev.repairguide.app'  // Development
      : 'https://api.repairguide.app';     // Production
  
  /// API version
  static const String apiVersion = 'v1';
  
  /// Full API base URL with version
  static String get apiUrl => '$apiBaseUrl/api/$apiVersion';
  
  /// API timeout duration
  static const Duration apiTimeout = Duration(seconds: 30);
  
  /// API retry attempts
  static const int apiRetryAttempts = 3;
  
  // ============================================================================
  // EXTERNAL SERVICE CONFIGURATION
  // ============================================================================
  
  /// YouTube API configuration (for external search)
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY'; // TODO: Add real key
  static const String youtubeApiUrl = 'https://www.googleapis.com/youtube/v3';
  
  /// Google Custom Search configuration
  static const String googleSearchApiKey = 'YOUR_GOOGLE_SEARCH_API_KEY'; // TODO: Add real key
  static const String googleSearchEngineId = 'YOUR_SEARCH_ENGINE_ID'; // TODO: Add real ID
  static const String googleSearchApiUrl = 'https://www.googleapis.com/customsearch/v1';
  
  /// iFixit API configuration (if available)
  static const String ifixitApiUrl = 'https://www.ifixit.com/api/2.0';
  
  // ============================================================================
  // STORAGE CONFIGURATION
  // ============================================================================
  
  /// Local storage keys
  static const String storageKeyTheme = 'app_theme_mode';
  static const String storageKeyRecentGuides = 'recent_guides';
  static const String storageKeySavedGuides = 'saved_guides';
  static const String storageKeyChatHistory = 'chat_history';
  static const String storageKeyUserPreferences = 'user_preferences';
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserProfile = 'user_profile';
  
  /// Maximum number of recent guides to store
  static const int maxRecentGuides = 20;
  
  /// Maximum chat history messages to store locally
  static const int maxChatHistoryMessages = 100;
  
  // ============================================================================
  // UI CONFIGURATION
  // ============================================================================
  
  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  /// Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  /// Spacing values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  /// Border radius values
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  
  /// Elevation values
  static const double elevationS = 1.0;
  static const double elevationM = 2.0;
  static const double elevationL = 4.0;
  static const double elevationXL = 8.0;
  
  // ============================================================================
  // FILE UPLOAD CONFIGURATION
  // ============================================================================
  
  /// Maximum file size for manual uploads (in bytes)
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  /// Allowed file types for manual uploads
  static const List<String> allowedFileTypes = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  
  /// Allowed MIME types for manual uploads
  static const List<String> allowedMimeTypes = [
    'application/pdf',
    'image/jpeg',
    'image/png',
    'image/webp',
  ];
  
  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================
  
  /// Enable/disable features for development
  static const bool enableExternalSearch = true;
  static const bool enableChatbot = true;
  static const bool enableManualUpload = true;
  static const bool enableUserAuthentication = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false; // Disabled for privacy
  static const bool enableCrashReporting = kDebugMode ? false : true;
  
  // ============================================================================
  // ACCESSIBILITY CONFIGURATION
  // ============================================================================
  
  /// Minimum touch target size (accessibility)
  static const double minTouchTargetSize = 44.0;
  
  /// Text scale factor limits
  static const double minTextScaleFactor = 0.8;
  static const double maxTextScaleFactor = 2.0;
  
  // ============================================================================
  // DEVELOPMENT CONFIGURATION
  // ============================================================================
  
  /// Enable debug logging
  static const bool enableDebugLogging = kDebugMode;
  
  /// Enable performance monitoring
  static const bool enablePerformanceMonitoring = kDebugMode;
  
  /// Mock data configuration
  static const bool useMockData = true; // Set to false when backend is ready
  static const Duration mockNetworkDelay = Duration(milliseconds: 500);
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Check if running in development mode
  static bool get isDevelopment => kDebugMode;
  
  /// Check if running in production mode
  static bool get isProduction => kReleaseMode;
  
  /// Get environment-specific configuration
  static T getEnvironmentValue<T>({
    required T development,
    required T production,
  }) {
    return isDevelopment ? development : production;
  }
  
  /// Validate file type for uploads
  static bool isValidFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedFileTypes.contains(extension);
  }
  
  /// Validate MIME type for uploads
  static bool isValidMimeType(String mimeType) {
    return allowedMimeTypes.contains(mimeType.toLowerCase());
  }
  
  /// Validate file size for uploads
  static bool isValidFileSize(int fileSizeBytes) {
    return fileSizeBytes <= maxFileSize;
  }
  
  /// Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Environment-specific configuration
enum Environment {
  development,
  staging,
  production,
}

/// Current environment
const Environment currentEnvironment = kDebugMode 
    ? Environment.development 
    : Environment.production;