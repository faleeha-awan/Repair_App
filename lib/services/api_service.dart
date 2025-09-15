import 'package:flutter/foundation.dart';
import '../models/guide.dart';
import '../models/search_result.dart';
import '../models/chat_message.dart';
import '../models/manual.dart';
import '../models/category.dart' as app_models;

/// Centralized API service for all backend integrations
/// This service provides a unified interface for all API calls
/// and can be easily extended when backend services are implemented
class ApiService {
  // These constants are ready for backend integration
  // Uncomment and use when implementing real API calls
  // static const String _baseUrl = 'https://api.repairguide.app';
  // static const Duration _defaultTimeout = Duration(seconds: 30);
  
  // Singleton pattern for global access
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // API endpoints configuration - ready for backend integration
  // static const Map<String, String> _endpoints = {
  //   'guides': '/api/v1/guides',
  //   'search': '/api/v1/search',
  //   'categories': '/api/v1/categories',
  //   'chat': '/api/v1/chat',
  //   'manuals': '/api/v1/manuals',
  //   'user': '/api/v1/user',
  //   'auth': '/api/v1/auth',
  // };

  // Headers for API requests - ready for backend integration
  // Map<String, String> get _defaultHeaders => {
  //   'Content-Type': 'application/json',
  //   'Accept': 'application/json',
  //   'User-Agent': 'RepairGuideApp/1.0.0',
  // };

  /// Authentication token (will be set after login)
  String? _authToken;
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  void clearAuthToken() {
    _authToken = null;
  }
  
  // Authenticated headers - ready for backend integration
  // Map<String, String> get _authenticatedHeaders => {
  //   ..._defaultHeaders,
  //   if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  // };

  // ============================================================================
  // GUIDE MANAGEMENT API
  // ============================================================================

  /// Fetch user's recent guides from backend
  /// Currently returns mock data, ready for backend integration
  Future<List<Guide>> fetchRecentGuides() async {
    try {
      if (kDebugMode) {
        print('API: Fetching recent guides (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request
      // final response = await http.get(
      //   Uri.parse('$_baseUrl${_endpoints['guides']}/recent'),
      //   headers: _authenticatedHeaders,
      // ).timeout(_defaultTimeout);
      
      // Mock delay to simulate network request
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return mock data for now
      return _getMockRecentGuides();
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error fetching recent guides: $e');
      }
      throw ApiException('Failed to fetch recent guides: $e');
    }
  }

  /// Fetch guide details by ID
  Future<Guide?> fetchGuideById(String guideId) async {
    try {
      if (kDebugMode) {
        print('API: Fetching guide $guideId (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request
      // final response = await http.get(
      //   Uri.parse('$_baseUrl${_endpoints['guides']}/$guideId'),
      //   headers: _authenticatedHeaders,
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 300));
      return _getMockGuideById(guideId);
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error fetching guide $guideId: $e');
      }
      throw ApiException('Failed to fetch guide: $e');
    }
  }

  /// Update guide progress
  Future<void> updateGuideProgress(String guideId, int completedSteps) async {
    try {
      if (kDebugMode) {
        print('API: Updating guide $guideId progress to $completedSteps (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request
      // final response = await http.patch(
      //   Uri.parse('$_baseUrl${_endpoints['guides']}/$guideId/progress'),
      //   headers: _authenticatedHeaders,
      //   body: jsonEncode({'completed_steps': completedSteps}),
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 200));
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error updating guide progress: $e');
      }
      throw ApiException('Failed to update guide progress: $e');
    }
  }

  // ============================================================================
  // SEARCH API
  // ============================================================================

  /// Search guides in database
  Future<List<SearchResult>> searchGuides(String query) async {
    try {
      if (kDebugMode) {
        print('API: Searching guides for "$query" (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request
      // final response = await http.get(
      //   Uri.parse('$_baseUrl${_endpoints['search']}?q=${Uri.encodeComponent(query)}'),
      //   headers: _authenticatedHeaders,
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 800));
      return _getMockSearchResults(query);
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error searching guides: $e');
      }
      throw ApiException('Failed to search guides: $e');
    }
  }

  /// Search external sources (YouTube, iFixit, etc.)
  Future<List<SearchResult>> searchExternal(String query) async {
    try {
      if (kDebugMode) {
        print('API: Searching external sources for "$query" (mock implementation)');
      }
      
      // TODO: Integrate with external APIs (YouTube, Google Custom Search, etc.)
      // This would involve multiple API calls to different services
      
      await Future.delayed(const Duration(milliseconds: 1200));
      return _getMockExternalResults(query);
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error searching external sources: $e');
      }
      throw ApiException('Failed to search external sources: $e');
    }
  }

  /// Fetch categories hierarchy
  Future<List<app_models.Category>> fetchCategories() async {
    try {
      if (kDebugMode) {
        print('API: Fetching categories (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request
      // final response = await http.get(
      //   Uri.parse('$_baseUrl${_endpoints['categories']}'),
      //   headers: _defaultHeaders,
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 400));
      return _getMockCategories();
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error fetching categories: $e');
      }
      throw ApiException('Failed to fetch categories: $e');
    }
  }

  // ============================================================================
  // CHAT & MANUAL API
  // ============================================================================

  /// Send message to chatbot
  Future<ChatMessage> sendChatMessage(String message, {String? manualId}) async {
    try {
      if (kDebugMode) {
        print('API: Sending chat message (mock implementation)');
      }
      
      // TODO: Replace with actual HTTP request to AI service
      // final response = await http.post(
      //   Uri.parse('$_baseUrl${_endpoints['chat']}'),
      //   headers: _authenticatedHeaders,
      //   body: jsonEncode({
      //     'message': message,
      //     'manual_id': manualId,
      //   }),
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 1500));
      return _getMockChatResponse(message);
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error sending chat message: $e');
      }
      throw ApiException('Failed to send chat message: $e');
    }
  }

  /// Upload manual file
  Future<Manual> uploadManual(String filePath, String fileName) async {
    try {
      if (kDebugMode) {
        print('API: Uploading manual $fileName (mock implementation)');
      }
      
      // TODO: Replace with actual multipart file upload
      // final request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse('$_baseUrl${_endpoints['manuals']}'),
      // );
      // request.headers.addAll(_authenticatedHeaders);
      // request.files.add(await http.MultipartFile.fromPath('file', filePath));
      
      await Future.delayed(const Duration(milliseconds: 2000));
      return _getMockUploadedManual(fileName);
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error uploading manual: $e');
      }
      throw ApiException('Failed to upload manual: $e');
    }
  }

  /// Process manual with OCR
  Future<String> processManualOCR(String manualId) async {
    try {
      if (kDebugMode) {
        print('API: Processing manual $manualId with OCR (mock implementation)');
      }
      
      // TODO: Replace with actual OCR service call
      await Future.delayed(const Duration(milliseconds: 3000));
      return 'This is the extracted text from the manual. It contains step-by-step instructions for repair procedures.';
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error processing manual OCR: $e');
      }
      throw ApiException('Failed to process manual with OCR: $e');
    }
  }

  // ============================================================================
  // USER & AUTHENTICATION API
  // ============================================================================

  /// Sign in user
  Future<AuthResult> signIn(String email, String password) async {
    try {
      if (kDebugMode) {
        print('API: Signing in user (mock implementation)');
      }
      
      // TODO: Replace with actual authentication
      // final response = await http.post(
      //   Uri.parse('$_baseUrl${_endpoints['auth']}/signin'),
      //   headers: _defaultHeaders,
      //   body: jsonEncode({
      //     'email': email,
      //     'password': password,
      //   }),
      // ).timeout(_defaultTimeout);
      
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      setAuthToken(token);
      
      return AuthResult(
        success: true,
        token: token,
        user: UserProfile(
          id: 'user_123',
          email: email,
          displayName: 'John Doe',
          profilePictureUrl: null,
        ),
      );
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error signing in: $e');
      }
      throw ApiException('Failed to sign in: $e');
    }
  }

  /// Sign up user
  Future<AuthResult> signUp(String email, String password, String displayName) async {
    try {
      if (kDebugMode) {
        print('API: Signing up user (mock implementation)');
      }
      
      // TODO: Replace with actual user registration
      await Future.delayed(const Duration(milliseconds: 1200));
      
      final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      setAuthToken(token);
      
      return AuthResult(
        success: true,
        token: token,
        user: UserProfile(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          displayName: displayName,
          profilePictureUrl: null,
        ),
      );
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error signing up: $e');
      }
      throw ApiException('Failed to sign up: $e');
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      if (kDebugMode) {
        print('API: Signing out user (mock implementation)');
      }
      
      // TODO: Replace with actual sign out
      await Future.delayed(const Duration(milliseconds: 300));
      clearAuthToken();
      
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      if (kDebugMode) {
        print('API Error signing out: $e');
      }
      throw ApiException('Failed to sign out: $e');
    }
  }

  // ============================================================================
  // MOCK DATA METHODS (TO BE REMOVED WHEN BACKEND IS READY)
  // ============================================================================

  List<Guide> _getMockRecentGuides() {
    return [
      Guide(
        id: 'guide_1',
        title: 'iPhone Screen Replacement',
        lastOpened: DateTime.now().subtract(const Duration(hours: 2)),
        totalSteps: 8,
        completedSteps: 3,
        isBookmarked: true,
      ),
      Guide(
        id: 'guide_2',
        title: 'Washing Machine Drain Repair',
        lastOpened: DateTime.now().subtract(const Duration(days: 1)),
        totalSteps: 5,
        completedSteps: 5,
        isBookmarked: false,
      ),
    ];
  }

  Guide? _getMockGuideById(String guideId) {
    final guides = _getMockRecentGuides();
    try {
      return guides.firstWhere((guide) => guide.id == guideId);
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      return null;
    }
  }

  List<SearchResult> _getMockSearchResults(String query) {
    if (query.toLowerCase().contains('phone')) {
      return [
        SearchResult(
          id: 'search_1',
          title: 'iPhone Screen Replacement Guide',
          description: 'Complete step-by-step guide for iPhone screen repair',
          type: SearchResultType.guide,
          relevanceScore: 0.95,
        ),
      ];
    }
    return [];
  }

  List<SearchResult> _getMockExternalResults(String query) {
    return [
      SearchResult(
        id: 'ext_1',
        title: 'How to Fix $query - YouTube',
        description: 'Professional repair tutorial',
        type: SearchResultType.external,
        sourceUrl: 'https://youtube.com/watch?v=example',
        sourceName: 'YouTube',
        relevanceScore: 0.88,
      ),
    ];
  }

  List<app_models.Category> _getMockCategories() {
    return [
      app_models.Category(
        id: 'electronics',
        name: 'Electronics',
        description: 'Electronic device repairs',
        iconName: 'devices',
        subcategories: [],
      ),
    ];
  }

  ChatMessage _getMockChatResponse(String userMessage) {
    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: 'I understand you need help with "$userMessage". Here are some suggestions...',
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
  }

  Manual _getMockUploadedManual(String fileName) {
    return Manual(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      name: fileName,
      filePath: '/mock/path/$fileName',
      type: ManualType.pdf,
      uploadedAt: DateTime.now(),
      fileSize: 1024000, // 1MB
    );
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Authentication result model
class AuthResult {
  final bool success;
  final String? token;
  final UserProfile? user;
  final String? error;
  
  const AuthResult({
    required this.success,
    this.token,
    this.user,
    this.error,
  });
}

/// User profile model
class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String? profilePictureUrl;
  
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.profilePictureUrl,
  });
}