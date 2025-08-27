class UserPreferences {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final List<String> recentGuideIds;

  UserPreferences({
    required this.isDarkMode,
    required this.language,
    required this.notificationsEnabled,
    required this.recentGuideIds,
  });

  // Default preferences
  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      isDarkMode: false,
      language: 'en',
      notificationsEnabled: true,
      recentGuideIds: [],
    );
  }

  // Convert UserPreferences to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'recentGuideIds': recentGuideIds,
    };
  }

  // Create UserPreferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json['isDarkMode'] ?? false,
      language: json['language'] ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      recentGuideIds: List<String>.from(json['recentGuideIds'] ?? []),
    );
  }

  // Create a copy with updated fields
  UserPreferences copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    List<String>? recentGuideIds,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      recentGuideIds: recentGuideIds ?? this.recentGuideIds,
    );
  }

  // Add a guide to recent guides (maintains order and limits to 10)
  UserPreferences addRecentGuide(String guideId) {
    final updatedIds = List<String>.from(recentGuideIds);
    
    // Remove if already exists to avoid duplicates
    updatedIds.remove(guideId);
    
    // Add to beginning
    updatedIds.insert(0, guideId);
    
    // Limit to 10 recent guides
    if (updatedIds.length > 10) {
      updatedIds.removeRange(10, updatedIds.length);
    }
    
    return copyWith(recentGuideIds: updatedIds);
  }

  // Remove a guide from recent guides
  UserPreferences removeRecentGuide(String guideId) {
    final updatedIds = List<String>.from(recentGuideIds);
    updatedIds.remove(guideId);
    return copyWith(recentGuideIds: updatedIds);
  }
}