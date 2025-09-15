# API Integration Guide

This document provides a comprehensive guide for integrating the Repair Guide App with backend services and external APIs.

## Overview

The app is designed with a clean separation between UI and data layers, making it easy to integrate with backend services. All API integration points are centralized in the `ApiService` class, which currently uses mock data but is ready for real API integration.

## Current Architecture

### Service Layer
- **ApiService**: Centralized API client with mock implementations
- **LocalStorageService**: Handles local data persistence
- **ThemeService**: Manages app theming
- **SearchService**: Handles search functionality (currently mock)

### Configuration
- **AppConfig**: Centralized configuration for API endpoints, timeouts, and feature flags
- **AppConstants**: UI constants and static values
- **ErrorHandler**: Centralized error handling and user feedback

### Models
All data models are defined with JSON serialization support:
- **Guide**: Repair guide information
- **Category**: Hierarchical categories for guides
- **SearchResult**: Search result data
- **ChatMessage**: Chat conversation data
- **Manual**: Uploaded manual information
- **UserPreferences**: User settings and preferences

## API Integration Points

### 1. Authentication API

**Current Status**: Mock implementation ready for backend integration

**Endpoints to implement**:
```dart
// Sign in
POST /api/v1/auth/signin
Body: { "email": "user@example.com", "password": "password" }
Response: { "token": "jwt_token", "user": {...} }

// Sign up
POST /api/v1/auth/signup
Body: { "email": "user@example.com", "password": "password", "displayName": "John Doe" }
Response: { "token": "jwt_token", "user": {...} }

// Sign out
POST /api/v1/auth/signout
Headers: { "Authorization": "Bearer jwt_token" }
```

**Integration steps**:
1. Replace mock methods in `ApiService.signIn()`, `ApiService.signUp()`, `ApiService.signOut()`
2. Update `AppConfig.apiBaseUrl` with your backend URL
3. Implement proper JWT token storage and refresh logic

### 2. Guides API

**Current Status**: Mock data with local storage fallback

**Endpoints to implement**:
```dart
// Get recent guides
GET /api/v1/guides/recent
Headers: { "Authorization": "Bearer jwt_token" }
Response: [{ "id": "guide_1", "title": "iPhone Repair", ... }]

// Get guide by ID
GET /api/v1/guides/{id}
Headers: { "Authorization": "Bearer jwt_token" }
Response: { "id": "guide_1", "title": "iPhone Repair", "steps": [...] }

// Update guide progress
PATCH /api/v1/guides/{id}/progress
Headers: { "Authorization": "Bearer jwt_token" }
Body: { "completed_steps": 5 }
```

**Integration steps**:
1. Replace mock methods in `ApiService.fetchRecentGuides()`, `ApiService.fetchGuideById()`, `ApiService.updateGuideProgress()`
2. Add HTTP client calls using the `http` package
3. Implement proper error handling for network failures

### 3. Search API

**Current Status**: Mock search with category hierarchy

**Endpoints to implement**:
```dart
// Search guides in database
GET /api/v1/search?q={query}&category={category}&limit={limit}
Response: [{ "id": "result_1", "title": "...", "relevance": 0.95 }]

// Get categories
GET /api/v1/categories
Response: [{ "id": "electronics", "name": "Electronics", "subcategories": [...] }]

// Get guides for category
GET /api/v1/categories/{id}/guides
Response: [{ "id": "guide_1", "title": "...", ... }]
```

**External search integration**:
- YouTube API for video tutorials
- Google Custom Search for web results
- iFixit API for repair guides

**Integration steps**:
1. Replace mock methods in `ApiService.searchGuides()`, `ApiService.fetchCategories()`
2. Add external API keys to `AppConfig`
3. Implement rate limiting and caching for external APIs

### 4. Chat & Manual API

**Current Status**: Mock chat responses and file upload simulation

**Endpoints to implement**:
```dart
// Send chat message
POST /api/v1/chat
Headers: { "Authorization": "Bearer jwt_token" }
Body: { "message": "How do I fix this?", "manual_id": "manual_123" }
Response: { "id": "msg_1", "content": "Here's how...", "timestamp": "..." }

// Upload manual
POST /api/v1/manuals
Headers: { "Authorization": "Bearer jwt_token", "Content-Type": "multipart/form-data" }
Body: FormData with file
Response: { "id": "manual_1", "name": "manual.pdf", "url": "..." }

// Process manual with OCR
POST /api/v1/manuals/{id}/ocr
Headers: { "Authorization": "Bearer jwt_token" }
Response: { "text": "Extracted text content..." }
```

**AI Service Integration**:
- OpenAI GPT for chat responses
- Google Cloud Vision or AWS Textract for OCR
- Text-to-speech services for audio playback

**Integration steps**:
1. Replace mock methods in `ApiService.sendChatMessage()`, `ApiService.uploadManual()`, `ApiService.processManualOCR()`
2. Implement multipart file upload for manuals
3. Add AI service API keys and configuration

## Configuration Setup

### 1. Environment Configuration

Update `lib/config/app_config.dart`:

```dart
// Update these URLs for your backend
static const String apiBaseUrl = kDebugMode 
    ? 'https://your-dev-api.com'     // Development
    : 'https://your-prod-api.com';   // Production

// Add your API keys
static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
static const String googleSearchApiKey = 'YOUR_GOOGLE_SEARCH_API_KEY';
static const String openaiApiKey = 'YOUR_OPENAI_API_KEY';
```

### 2. Feature Flags

Enable/disable features during development:

```dart
static const bool enableExternalSearch = true;
static const bool enableChatbot = true;
static const bool enableManualUpload = true;
static const bool useMockData = false; // Set to false when backend is ready
```

## Error Handling

The app includes comprehensive error handling:

### Network Errors
```dart
try {
  final result = await ApiService().fetchRecentGuides();
} catch (e) {
  if (e is ApiException) {
    ErrorHandler.handleApiError(context, e);
  } else {
    ErrorHandler.handleNetworkError(context);
  }
}
```

### File Upload Errors
```dart
try {
  final manual = await ApiService().uploadManual(filePath, fileName);
} catch (e) {
  ErrorHandler.handleFileError(context, e.toString());
}
```

## Testing Strategy

### Unit Tests
Test API service methods with mock responses:

```dart
test('should fetch recent guides', () async {
  // Mock HTTP response
  when(mockClient.get(any)).thenAnswer((_) async => 
    http.Response(jsonEncode(mockGuidesData), 200));
  
  final guides = await apiService.fetchRecentGuides();
  expect(guides.length, equals(2));
});
```

### Integration Tests
Test complete user flows:

```dart
testWidgets('should display recent guides after loading', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  expect(find.text('Recent Guides'), findsOneWidget);
  expect(find.byType(GuideCard), findsWidgets);
});
```

## Performance Considerations

### Caching Strategy
- Implement local caching for frequently accessed data
- Use HTTP cache headers for API responses
- Cache search results to reduce API calls

### Offline Support
- Store critical data locally using `LocalStorageService`
- Implement sync mechanism when connection is restored
- Show appropriate offline indicators

### Image Optimization
- Implement image caching for guide thumbnails
- Use progressive loading for large images
- Compress uploaded images before sending to API

## Security Best Practices

### API Security
- Use HTTPS for all API communications
- Implement proper JWT token refresh logic
- Validate all user inputs before sending to API
- Use API rate limiting to prevent abuse

### Data Protection
- Encrypt sensitive data in local storage
- Implement proper user session management
- Follow GDPR/privacy regulations for user data

### File Upload Security
- Validate file types and sizes on both client and server
- Scan uploaded files for malware
- Use secure file storage with proper access controls

## Monitoring and Analytics

### Logging
The app includes comprehensive logging via `Logger` class:

```dart
Logger.api('Fetching recent guides');
Logger.performance('Guide fetch completed', duration);
Logger.error('API call failed', error: e);
```

### Analytics Integration
Add analytics tracking for user behavior:

```dart
// Track feature usage
Logger.featureUsage('search_guides', metadata: {'query': searchQuery});

// Track user actions
Logger.userAction('guide_bookmarked', context: {'guide_id': guideId});
```

## Deployment Checklist

### Before Production
- [ ] Replace all mock data with real API calls
- [ ] Update API URLs in `AppConfig`
- [ ] Add real API keys and credentials
- [ ] Enable production error reporting
- [ ] Test all user flows with real backend
- [ ] Implement proper authentication flow
- [ ] Set up monitoring and logging
- [ ] Configure app store metadata

### Environment Variables
Consider using environment variables for sensitive configuration:

```dart
static String get apiBaseUrl => 
  const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.repairguide.app');

static String get youtubeApiKey => 
  const String.fromEnvironment('YOUTUBE_API_KEY', defaultValue: '');
```

## Support and Maintenance

### Debugging
- Use `Logger` class for structured logging
- Enable debug mode for detailed API logs
- Use Flutter Inspector for UI debugging

### Updates
- Follow semantic versioning for API changes
- Implement graceful degradation for API version mismatches
- Use feature flags for gradual rollouts

### Monitoring
- Monitor API response times and error rates
- Track user engagement and feature usage
- Set up alerts for critical errors

## Next Steps

1. **Set up backend infrastructure** (Node.js, Python, etc.)
2. **Implement authentication system** with JWT tokens
3. **Create database schema** for guides, users, and chat data
4. **Set up file storage** for manual uploads (AWS S3, Google Cloud Storage)
5. **Integrate AI services** for chat and OCR functionality
6. **Implement search indexing** for fast guide discovery
7. **Add real-time features** using WebSockets for chat
8. **Set up CI/CD pipeline** for automated testing and deployment

This guide provides a solid foundation for transforming the current scaffold into a fully functional repair guide application with backend integration.