# Test Backlog

This document tracks test suggestions and requirements for future implementation.

## Web Search Tests

**Priority:** Medium  
**Component:** SearchService.searchWeb()  
**Location:** `tests_sandbox/web_search_test.dart`

### Test Cases:
1. **Basic Functionality**
   - Should return web search results for phone query
   - Should return web search results for laptop query
   - Should return empty results for empty query

2. **Data Quality**
   - Results should be sorted by relevance score
   - All results should have SearchResultType.external
   - Results should include source names and URLs

3. **Source Integration**
   - Should include YouTube results for device queries
   - Should include iFixit results for repair queries
   - Should handle various source types (Reddit, Google Maps, etc.)

### Implementation Notes:
- Tests currently use mock data from SearchService
- Will need real API integration testing when web search is implemented
- Consider adding timeout and error handling tests
- May need to mock HTTP calls for consistent testing

### Dependencies:
- Requires SearchResult model with proper fields
- Needs SearchResultType enum
- SearchService.searchWeb() method implementation

---

## Future Test Categories

### Database Search Tests
- Test SearchService.searchDatabase() functionality
- Verify local database query performance
- Test search result ranking and filtering

### Category Navigation Tests
- Test category hierarchy navigation
- Verify guide loading for categories
- Test breadcrumb functionality

### Guide Management Tests
- Test guide opening and progress tracking
- Verify bookmark functionality
- Test step completion tracking