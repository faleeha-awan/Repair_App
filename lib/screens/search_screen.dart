import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/search_result.dart';
import '../models/guide.dart';
import '../services/search_service.dart';

//the state itself (the main widget)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

//state object (holds changing values)
// referred to as state class
class _SearchScreenState extends State<SearchScreen> {
  // variables that will change 
  // initializing them here
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<Category> _categories = [];
  final List<Category> _navigationStack = [];
  List<SearchResult> _databaseResults = [];
  List<SearchResult> _webResults = [];
  List<Guide> _categoryGuides = [];
  
  bool _isSearching = false;
  bool _isSearchingWeb = false;
  bool _showSearchResults = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadCategories() {
    setState(() {
      _categories = SearchService.getMockCategories();
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _showSearchResults = false;
        _databaseResults = [];
        _webResults = [];
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
      _currentQuery = query;
      _databaseResults = [];
    });

    try {
      final results = await SearchService.searchDatabase(query);
      setState(() {
        _databaseResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _performWebSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearchingWeb = true;
      _webResults = [];
    });

    try {
      final results = await SearchService.searchWeb(query);
      setState(() {
        _webResults = results;
        _isSearchingWeb = false;
      });
    } catch (e) {
      setState(() {
        _isSearchingWeb = false;
      });
    }
  }

  void _navigateToCategory(Category category) {
    setState(() {
      _navigationStack.add(category);
      _showSearchResults = false;
      _searchController.clear();
      _currentQuery = '';
      
      // Load guides for this category if it has guides
      if (category.hasGuides) {
        _categoryGuides = SearchService.getGuidesForCategory(category.id);
      } else {
        _categoryGuides = [];
      }
    });
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _navigationStack.removeLast();
        _categoryGuides = [];
        
        // If we're back to a category that has guides, load them
        if (_navigationStack.isNotEmpty && _navigationStack.last.hasGuides) {
          _categoryGuides = SearchService.getGuidesForCategory(_navigationStack.last.id);
        }
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _showSearchResults = false;
      _searchController.clear();
      _currentQuery = '';
      _databaseResults = [];
      _webResults = [];
    });
    _searchFocusNode.unfocus();
  }

  List<Category> get _currentCategories {
    if (_navigationStack.isEmpty) {
      return _categories;
    } else {
      return _navigationStack.last.subcategories;
    }
  }

  String get _currentCategoryName {
    if (_navigationStack.isEmpty) {
      return 'Categories';
    } else {
      return _navigationStack.last.name;
    }
  }

  //method that returns widget (builds the screen that appears on the app)
  //telling flutter how the screen should look with the current data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showSearchResults ? 'Search Results' : _currentCategoryName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: _navigationStack.isNotEmpty || _showSearchResults
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _showSearchResults ? _clearSearch : _navigateBack,
              )
            : null,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _showSearchResults
                ? _buildSearchResults()
                : _buildCategoryNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search repair guides...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: _performSearch,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _searchController.text.isNotEmpty
                ? () => _performWebSearch(_searchController.text)
                : null,
            icon: const Icon(Icons.public, size: 18),
            label: const Text('Web'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Database Results Section
          _buildDatabaseResultsSection(),
          
          const SizedBox(height: 24),
          
          // Web Results Section
          _buildWebResultsSection(),
        ],
      ),
    );
  }

  Widget _buildDatabaseResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.storage,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Database Results',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isSearching) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        
        if (_isSearching)
          _buildLoadingPlaceholder()
        else if (_databaseResults.isEmpty)
          _buildEmptyResults('No guides found in database for "$_currentQuery"')
        else
          ..._databaseResults.map((result) => _buildSearchResultCard(result)),
      ],
    );
  }

  Widget _buildWebResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.public,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Web Results',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isSearchingWeb) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        
        if (_isSearchingWeb)
          _buildLoadingPlaceholder()
        else if (_webResults.isEmpty && !_isSearchingWeb)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Click "Web" button to search external sources',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ..._webResults.map((result) => _buildSearchResultCard(result)),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Column(
      children: List.generate(3, (index) => 
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(SearchResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openSearchResult(result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (result.type == SearchResultType.external) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.public,
                            size: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            result.sourceName ?? 'Web',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (result.relevanceScore != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Relevance: ${(result.relevanceScore! * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryNavigation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_navigationStack.isNotEmpty) ...[
            _buildBreadcrumb(),
            const SizedBox(height: 16),
          ],
          
          if (_categoryGuides.isNotEmpty) ...[
            _buildGuidesSection(),
            const SizedBox(height: 24),
          ],
          
          if (_currentCategories.isNotEmpty) ...[
            _buildCategoriesSection(),
          ] else if (_categoryGuides.isEmpty) ...[
            _buildEmptyCategory(),
          ],
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _navigationStack.map((cat) => cat.name).join(' > '),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guides in this category',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._categoryGuides.map((guide) => _buildGuideCard(guide)),
      ],
    );
  }

  Widget _buildGuideCard(Guide guide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openGuide(guide),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.build,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${guide.totalSteps} steps',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _navigationStack.isEmpty ? 'Browse Categories' : 'Subcategories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _currentCategories.length,
          itemBuilder: (context, index) {
            final category = _currentCategories[index];
            return _buildCategoryCard(category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
    final iconData = _getIconData(category.iconName);
    
    return Card(
      child: InkWell(
        onTap: () => _navigateToCategory(category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (category.hasSubcategories || category.hasGuides) ...[
                const SizedBox(height: 4),
                Text(
                  category.hasSubcategories 
                      ? '${category.subcategories.length} subcategories'
                      : '${category.guideIds.length} guides',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCategory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No content available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This category is empty. Check back later for new guides.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'devices':
        return Icons.devices;
      case 'phone_android':
        return Icons.phone_android;
      case 'laptop':
        return Icons.laptop;
      case 'tablet':
        return Icons.tablet;
      case 'home':
        return Icons.home;
      case 'kitchen':
        return Icons.kitchen;
      case 'microwave':
        return Icons.microwave;
      case 'local_laundry_service':
        return Icons.local_laundry_service;
      case 'directions_car':
        return Icons.directions_car;
      case 'settings':
        return Icons.settings;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'chair':
        return Icons.chair;
      default:
        return Icons.category;
    }
  }

  void _openSearchResult(SearchResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.type == SearchResultType.external
              ? 'Opening external link: ${result.title}'
              : 'Opening guide: ${result.title}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openGuide(Guide guide) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening guide: ${guide.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}