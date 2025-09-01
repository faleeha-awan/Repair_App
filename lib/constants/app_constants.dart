// Application constants - no Flutter imports needed

/// Application constants and static values
/// Centralizes all constant values used throughout the app
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ============================================================================
  // APP METADATA
  // ============================================================================
  
  static const String appName = 'Repair Guide App';
  static const String appDescription = 'Your comprehensive repair guide companion';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // ============================================================================
  // NAVIGATION
  // ============================================================================
  
  /// Bottom navigation tab indices
  static const int homeTabIndex = 0;
  static const int searchTabIndex = 1;
  static const int myGuidesTabIndex = 2;
  static const int manualsTabIndex = 3;
  static const int profileTabIndex = 4;
  
  /// Tab labels
  static const String homeTabLabel = 'Home';
  static const String searchTabLabel = 'Search';
  static const String myGuidesTabLabel = 'My Guides';
  static const String manualsTabLabel = 'Manuals & Chat';
  static const String profileTabLabel = 'Profile';
  
  /// Screen titles
  static const String homeScreenTitle = 'Home';
  static const String searchScreenTitle = 'Search';
  static const String myGuidesScreenTitle = 'My Guides';
  static const String manualsScreenTitle = 'Manuals & Chat';
  static const String profileScreenTitle = 'Profile';
  
  // ============================================================================
  // UI TEXT CONTENT
  // ============================================================================
  
  /// Welcome messages
  static const String homeWelcomeMessage = "We're here to guide you step by step";
  static const String homeWelcomeSubtitle = 'Find repair guides, upload manuals, and get expert help.';
  static const String chatWelcomeMessage = 'Hi! Upload your product manual or ask me any repair question.';
  
  /// Empty state messages
  static const String noRecentGuidesMessage = 'No recent guides yet';
  static const String noRecentGuidesSubtitle = 'Start exploring to see them here!';
  static const String noSavedGuidesMessage = 'No saved guides yet';
  static const String noSavedGuidesSubtitle = 'Search and bookmark guides to access them here.';
  static const String noChatHistoryMessage = 'Start a conversation';
  static const String noChatHistorySubtitle = 'Ask me anything about repairs or upload a manual.';
  
  /// Section titles
  static const String recentGuidesTitle = 'Recent Guides';
  static const String savedGuidesTitle = 'Saved Guides';
  static const String categoriesTitle = 'Categories';
  static const String searchResultsTitle = 'Search Results';
  static const String externalResultsTitle = 'Web Results';
  
  /// Button labels
  static const String viewAllLabel = 'View All';
  static const String searchLabel = 'Search';
  static const String searchWebLabel = 'Search Web';
  static const String uploadLabel = 'Upload';
  static const String sendLabel = 'Send';
  static const String retryLabel = 'Retry';
  static const String cancelLabel = 'Cancel';
  static const String saveLabel = 'Save';
  static const String deleteLabel = 'Delete';
  static const String editLabel = 'Edit';
  static const String shareLabel = 'Share';
  static const String bookmarkLabel = 'Bookmark';
  static const String removeLabel = 'Remove';
  static const String signInLabel = 'Sign In';
  static const String signUpLabel = 'Sign Up';
  static const String signOutLabel = 'Sign Out';
  
  /// Action labels
  static const String translateToTextLabel = 'Translate to text';
  static const String playAsAudioLabel = 'Play as audio';
  static const String askAboutManualLabel = 'Ask about this manual';
  
  /// Settings labels
  static const String settingsTitle = 'Settings';
  static const String themeLabel = 'Theme';
  static const String lightModeLabel = 'Light Mode';
  static const String darkModeLabel = 'Dark Mode';
  static const String systemModeLabel = 'System';
  static const String notificationsLabel = 'Notifications';
  static const String languageLabel = 'Language';
  static const String aboutLabel = 'About';
  static const String privacyPolicyLabel = 'Privacy Policy';
  static const String termsOfServiceLabel = 'Terms of Service';
  static const String helpLabel = 'Help & Support';
  
  /// Authentication labels
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String displayNameLabel = 'Display Name';
  static const String forgotPasswordLabel = 'Forgot Password?';
  static const String createAccountLabel = 'Create Account';
  static const String alreadyHaveAccountLabel = 'Already have an account?';
  static const String dontHaveAccountLabel = "Don't have an account?";
  
  // ============================================================================
  // PLACEHOLDER TEXT
  // ============================================================================
  
  static const String searchHint = 'Search for repair guides...';
  static const String chatInputHint = 'Type your message...';
  static const String emailHint = 'Enter your email';
  static const String passwordHint = 'Enter your password';
  static const String displayNameHint = 'Enter your name';
  
  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================
  
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'No internet connection. Please check your network.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please sign in again.';
  static const String fileUploadErrorMessage = 'Failed to upload file. Please try again.';
  static const String fileSizeErrorMessage = 'File is too large. Maximum size is 10MB.';
  static const String fileTypeErrorMessage = 'File type not supported. Please select a PDF or image.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  
  /// Field validation messages
  static const String emailRequiredMessage = 'Email is required';
  static const String emailInvalidMessage = 'Please enter a valid email';
  static const String passwordRequiredMessage = 'Password is required';
  static const String passwordTooShortMessage = 'Password must be at least 6 characters';
  static const String passwordMismatchMessage = 'Passwords do not match';
  static const String displayNameRequiredMessage = 'Display name is required';
  
  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================
  
  static const String signInSuccessMessage = 'Welcome back!';
  static const String signUpSuccessMessage = 'Account created successfully!';
  static const String signOutSuccessMessage = 'Signed out successfully';
  static const String fileUploadSuccessMessage = 'File uploaded successfully';
  static const String settingsSavedMessage = 'Settings saved';
  static const String guideBookmarkedMessage = 'Guide bookmarked';
  static const String guideRemovedMessage = 'Guide removed';
  
  // ============================================================================
  // LOADING MESSAGES
  // ============================================================================
  
  static const String loadingMessage = 'Loading...';
  static const String searchingMessage = 'Searching...';
  static const String uploadingMessage = 'Uploading...';
  static const String processingMessage = 'Processing...';
  static const String signingInMessage = 'Signing in...';
  static const String signingUpMessage = 'Creating account...';
  static const String signingOutMessage = 'Signing out...';
  
  // ============================================================================
  // ACCESSIBILITY LABELS
  // ============================================================================
  
  /// Screen reader labels
  static const String homeTabA11yLabel = 'Home tab';
  static const String searchTabA11yLabel = 'Search tab';
  static const String myGuidesTabA11yLabel = 'My Guides tab';
  static const String manualsTabA11yLabel = 'Manuals and Chat tab';
  static const String profileTabA11yLabel = 'Profile tab';
  
  static const String searchBarA11yLabel = 'Search for repair guides';
  static const String chatInputA11yLabel = 'Type your message';
  static const String uploadButtonA11yLabel = 'Upload manual file';
  static const String sendButtonA11yLabel = 'Send message';
  
  /// Semantic labels
  static const String welcomeSectionA11yLabel = 'Welcome section';
  static const String recentGuidesSectionA11yLabel = 'Recent guides section';
  static const String categoriesSectionA11yLabel = 'Categories section';
  static const String chatHistoryA11yLabel = 'Chat conversation history';
  static const String settingsSectionA11yLabel = 'Settings section';
  
  // ============================================================================
  // TOOLTIPS
  // ============================================================================
  
  static const String homeTabTooltip = 'Navigate to Home screen';
  static const String searchTabTooltip = 'Navigate to Search screen';
  static const String myGuidesTabTooltip = 'Navigate to My Guides screen';
  static const String manualsTabTooltip = 'Navigate to Manuals and Chat screen';
  static const String profileTabTooltip = 'Navigate to Profile screen';
  
  static const String searchButtonTooltip = 'Search for guides';
  static const String uploadButtonTooltip = 'Upload a manual file';
  static const String bookmarkButtonTooltip = 'Bookmark this guide';
  static const String removeButtonTooltip = 'Remove from list';
  static const String shareButtonTooltip = 'Share this guide';
  static const String themeToggleTooltip = 'Toggle between light and dark theme';
  
  // ============================================================================
  // DURATIONS
  // ============================================================================
  
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  static const Duration shortSnackBarDuration = Duration(seconds: 2);
  static const Duration mediumSnackBarDuration = Duration(seconds: 4);
  static const Duration longSnackBarDuration = Duration(seconds: 6);
  
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);
  static const Duration autoSaveDelay = Duration(seconds: 2);
  
  // ============================================================================
  // DIMENSIONS
  // ============================================================================
  
  /// Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  /// Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
  
  /// Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  /// Avatar sizes
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 48.0;
  static const double avatarSizeL = 64.0;
  static const double avatarSizeXL = 96.0;
  
  /// Thumbnail sizes
  static const double thumbnailSizeS = 48.0;
  static const double thumbnailSizeM = 64.0;
  static const double thumbnailSizeL = 80.0;
  static const double thumbnailSizeXL = 120.0;
  
  /// Minimum touch target size (accessibility)
  static const double minTouchTargetSize = 44.0;
  
  // ============================================================================
  // BREAKPOINTS
  // ============================================================================
  
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // ============================================================================
  // LIMITS
  // ============================================================================
  
  static const int maxRecentGuides = 20;
  static const int maxSavedGuides = 100;
  static const int maxChatMessages = 100;
  static const int maxSearchResults = 50;
  
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxMessageLength = 1000;
  static const int maxDisplayNameLength = 50;
  
  // ============================================================================
  // REGEX PATTERNS
  // ============================================================================
  
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern = r'^.{6,}$'; // At least 6 characters
  static const String displayNamePattern = r'^[a-zA-Z0-9\s]{1,50}$'; // Alphanumeric and spaces, max 50 chars
  
  // ============================================================================
  // FILE TYPES
  // ============================================================================
  
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> supportedDocumentTypes = ['pdf'];
  static const List<String> supportedFileTypes = [...supportedImageTypes, ...supportedDocumentTypes];
  
  static const List<String> supportedMimeTypes = [
    'image/jpeg',
    'image/png', 
    'image/webp',
    'application/pdf',
  ];
  
  // ============================================================================
  // URLS
  // ============================================================================
  
  static const String privacyPolicyUrl = 'https://repairguide.app/privacy';
  static const String termsOfServiceUrl = 'https://repairguide.app/terms';
  static const String supportUrl = 'https://repairguide.app/support';
  static const String aboutUrl = 'https://repairguide.app/about';
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Check if a file type is supported
  static bool isSupportedFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return supportedFileTypes.contains(extension);
  }
  
  /// Check if a MIME type is supported
  static bool isSupportedMimeType(String mimeType) {
    return supportedMimeTypes.contains(mimeType.toLowerCase());
  }
  
  /// Get file size limit as formatted string
  static String get maxFileSizeFormatted => '10 MB';
  
  /// Get supported file types as formatted string
  static String get supportedFileTypesFormatted => supportedFileTypes.join(', ').toUpperCase();
}