import '../models/category.dart';
import '../models/search_result.dart';
import '../models/guide.dart';

class SearchService {
  // Mock categories data
  static List<Category> getMockCategories() {
    return [
      Category(
        id: 'electronics',
        name: 'Electronics',
        description: 'Repair guides for electronic devices',
        iconName: 'devices',
        subcategories: [
          Category(
            id: 'smartphones',
            name: 'Smartphones',
            description: 'Phone repair guides',
            iconName: 'phone_android',
            guideIds: ['guide_1', 'guide_2'],
          ),
          Category(
            id: 'laptops',
            name: 'Laptops',
            description: 'Laptop repair guides',
            iconName: 'laptop',
            guideIds: ['guide_3', 'guide_4'],
          ),
          Category(
            id: 'tablets',
            name: 'Tablets',
            description: 'Tablet repair guides',
            iconName: 'tablet',
            guideIds: ['guide_5'],
          ),
        ],
      ),
      Category(
        id: 'appliances',
        name: 'Home Appliances',
        description: 'Repair guides for household appliances',
        iconName: 'home',
        subcategories: [
          Category(
            id: 'kitchen',
            name: 'Kitchen Appliances',
            description: 'Kitchen appliance repairs',
            iconName: 'kitchen',
            subcategories: [
              Category(
                id: 'refrigerators',
                name: 'Refrigerators',
                iconName: 'kitchen',
                guideIds: ['guide_6'],
              ),
              Category(
                id: 'microwaves',
                name: 'Microwaves',
                iconName: 'microwave',
                guideIds: ['guide_7'],
              ),
            ],
          ),
          Category(
            id: 'laundry',
            name: 'Laundry',
            description: 'Washing machine and dryer repairs',
            iconName: 'local_laundry_service',
            guideIds: ['guide_8', 'guide_9'],
          ),
        ],
      ),
      Category(
        id: 'automotive',
        name: 'Automotive',
        description: 'Car and vehicle repair guides',
        iconName: 'directions_car',
        subcategories: [
          Category(
            id: 'engine',
            name: 'Engine',
            description: 'Engine repair guides',
            iconName: 'settings',
            guideIds: ['guide_10'],
          ),
          Category(
            id: 'electrical',
            name: 'Electrical',
            description: 'Car electrical system repairs',
            iconName: 'electrical_services',
            guideIds: ['guide_11'],
          ),
        ],
      ),
      Category(
        id: 'furniture',
        name: 'Furniture',
        description: 'Furniture repair and restoration',
        iconName: 'chair',
        guideIds: ['guide_12', 'guide_13'],
      ),
    ];
  }

  // Mock search in database
  static Future<List<SearchResult>> searchDatabase(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (query.isEmpty) return [];

    // Mock search results based on query
    final mockResults = <SearchResult>[];
    
    if (query.toLowerCase().contains('phone') || query.toLowerCase().contains('iphone')) {
      mockResults.addAll([
        SearchResult(
          id: 'db_1',
          title: 'iPhone Screen Replacement Guide',
          description: 'Complete step-by-step guide to replace a cracked iPhone screen safely.',
          type: SearchResultType.guide,
          relevanceScore: 0.95,
        ),
        SearchResult(
          id: 'db_2',
          title: 'Fix iPhone Battery Issues',
          description: 'Troubleshoot and replace iPhone battery problems.',
          type: SearchResultType.guide,
          relevanceScore: 0.87,
        ),
      ]);
    }

    if (query.toLowerCase().contains('laptop') || query.toLowerCase().contains('computer')) {
      mockResults.addAll([
        SearchResult(
          id: 'db_3',
          title: 'Laptop Keyboard Repair',
          description: 'Fix stuck or broken laptop keyboard keys.',
          type: SearchResultType.guide,
          relevanceScore: 0.92,
        ),
        SearchResult(
          id: 'db_4',
          title: 'Laptop Overheating Solutions',
          description: 'Diagnose and fix laptop overheating issues.',
          type: SearchResultType.guide,
          relevanceScore: 0.85,
        ),
      ]);
    }

    if (query.toLowerCase().contains('washing') || query.toLowerCase().contains('machine')) {
      mockResults.addAll([
        SearchResult(
          id: 'db_5',
          title: 'Washing Machine Drain Problems',
          description: 'Fix common washing machine drainage issues.',
          type: SearchResultType.guide,
          relevanceScore: 0.90,
        ),
      ]);
    }

    // Add some generic results for any query
    if (mockResults.isEmpty && query.length > 2) {
      mockResults.addAll([
        SearchResult(
          id: 'db_generic_1',
          title: 'General Repair Tips for ${query.toUpperCase()}',
          description: 'Basic troubleshooting and repair techniques.',
          type: SearchResultType.guide,
          relevanceScore: 0.60,
        ),
        SearchResult(
          id: 'db_generic_2',
          title: 'Common ${query.toUpperCase()} Issues',
          description: 'Most frequent problems and their solutions.',
          type: SearchResultType.guide,
          relevanceScore: 0.55,
        ),
      ]);
    }

    // Sort by relevance score
    mockResults.sort((a, b) => (b.relevanceScore ?? 0).compareTo(a.relevanceScore ?? 0));
    
    return mockResults;
  }

  // Mock search web
  static Future<List<SearchResult>> searchWeb(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (query.isEmpty) return [];

    // Mock external search results
    return [
      SearchResult(
        id: 'web_1',
        title: 'How to Fix $query - YouTube Tutorial',
        description: 'Professional repair tutorial with detailed steps and tips.',
        type: SearchResultType.external,
        sourceUrl: 'https://youtube.com/watch?v=example',
        sourceName: 'YouTube',
        relevanceScore: 0.88,
      ),
      SearchResult(
        id: 'web_2',
        title: '$query Repair Guide - iFixit',
        description: 'Comprehensive repair guide with tools and parts list.',
        type: SearchResultType.external,
        sourceUrl: 'https://ifixit.com/guide/example',
        sourceName: 'iFixit',
        relevanceScore: 0.85,
      ),
      SearchResult(
        id: 'web_3',
        title: 'DIY $query Repair Tips - Reddit',
        description: 'Community discussion and tips from experienced repairers.',
        type: SearchResultType.external,
        sourceUrl: 'https://reddit.com/r/repair/example',
        sourceName: 'Reddit',
        relevanceScore: 0.75,
      ),
    ];
  }

  // Get mock guides for a category
  static List<Guide> getGuidesForCategory(String categoryId) {
    // Mock guides data - in real app this would come from database
    final mockGuides = {
      'guide_1': Guide(
        id: 'guide_1',
        title: 'iPhone Screen Replacement',
        lastOpened: DateTime.now().subtract(const Duration(days: 1)),
        totalSteps: 8,
        completedSteps: 0,
        isBookmarked: false,
      ),
      'guide_2': Guide(
        id: 'guide_2',
        title: 'Android Phone Battery Replacement',
        lastOpened: DateTime.now().subtract(const Duration(days: 2)),
        totalSteps: 6,
        completedSteps: 0,
        isBookmarked: false,
      ),
      'guide_3': Guide(
        id: 'guide_3',
        title: 'Laptop Keyboard Repair',
        lastOpened: DateTime.now().subtract(const Duration(days: 3)),
        totalSteps: 5,
        completedSteps: 0,
        isBookmarked: false,
      ),
      'guide_4': Guide(
        id: 'guide_4',
        title: 'Laptop Screen Replacement',
        lastOpened: DateTime.now().subtract(const Duration(days: 4)),
        totalSteps: 10,
        completedSteps: 0,
        isBookmarked: false,
      ),
      'guide_5': Guide(
        id: 'guide_5',
        title: 'iPad Screen Repair',
        lastOpened: DateTime.now().subtract(const Duration(days: 5)),
        totalSteps: 7,
        completedSteps: 0,
        isBookmarked: false,
      ),
    };

    final category = _findCategoryById(getMockCategories(), categoryId);
    if (category == null) return [];

    return category.guideIds
        .map((id) => mockGuides[id])
        .where((guide) => guide != null)
        .cast<Guide>()
        .toList();
  }

  static Category? _findCategoryById(List<Category> categories, String id) {
    for (final category in categories) {
      if (category.id == id) return category;
      
      final found = _findCategoryById(category.subcategories, id);
      if (found != null) return found;
    }
    return null;
  }
}