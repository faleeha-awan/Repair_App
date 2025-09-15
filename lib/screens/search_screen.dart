import 'package:flutter/material.dart';
import 'package:my_app/services/supabase_steps_service.dart';
import 'package:my_app/utils/logger.dart';
import '../models/category.dart';
import '../models/search_result.dart';
import '../models/guide.dart';
import '../services/search_service.dart';
import '../services/supabase_categories_service.dart';
import '../services/supabase_guides_service.dart';
import '../screens/guide_steps_screen.dart';

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

  Future<void> _loadCategories() async {
    // optional: show a loading spinner by setting a flag here with setState
    try {
      final cats = await CategoryService.fetchCategories(); // await the DB call
      setState(() {
        _categories = cats; // update UI data
      });
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      Logger.error('Error loading categories', error: e);
      // good place to show a SnackBar/Toast, or fallback to mock if needed
      setState(() {
        _categories = []; // or keep previous
      });
    }
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
      // ⚠️ Consider logging this error with Logger.error for better debugging
      Logger.error('Error performing database search', error: e);
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
      // ⚠️ Consider logging this error with Logger.error for better debugging
      Logger.error('Error performing web search', error: e);
      setState(() {
        _isSearchingWeb = false;
      });
    }
  }

  Future <void> _navigateToCategory(Category category) async {
    setState(() {
      _navigationStack.add(category);
      _showSearchResults = false;
      _searchController.clear();
      _currentQuery = '';
      _categoryGuides = []; //clear while loading
    });

    // Load guides for this category if it has guides
     try{
          final guides = await GuideService.fetchGuidesForCategory(category.id);
          setState(() {
             _categoryGuides = guides;
          });
        }
        catch (e){
          // ⚠️ Consider logging this error with Logger.error for better debugging
          Logger.error('Error fetching guides for category', error: e);
          setState(() {
            _categoryGuides = [];
          });
        }
    
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.public,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search the Web',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find repair guides from YouTube, iFixit, Reddit, and more',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _searchController.text.isNotEmpty
                        ? () => _performWebSearch(_searchController.text)
                        : null,
                    icon: const Icon(Icons.search, size: 18),
                    label: Text('Search Web for "${_currentQuery}"'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
      elevation: result.type == SearchResultType.external ? 2 : 1,
      child: InkWell(
        onTap: () => _openSearchResult(result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and source badge row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source icon for web results
                  if (result.type == SearchResultType.external) ...[
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 12, top: 2),
                      decoration: BoxDecoration(
                        color: _getSourceColor(result.sourceName).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        _getSourceIcon(result.sourceName),
                        size: 16,
                        color: _getSourceColor(result.sourceName),
                      ),
                    ),
                  ],
                  // Title
                  Expanded(
                    child: Text(
                      result.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: result.type == SearchResultType.external
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Source badge for web results
                  if (result.type == SearchResultType.external) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getSourceColor(result.sourceName).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getSourceColor(result.sourceName).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        result.sourceName ?? 'Web',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getSourceColor(result.sourceName),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                result.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Bottom row with URL preview and relevance
              Row(
                children: [
                  // URL preview for web results
                  if (result.type == SearchResultType.external && result.sourceUrl != null) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _formatUrl(result.sourceUrl!),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  
                  // Relevance score
                  if (result.relevanceScore != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRelevanceColor(result.relevanceScore!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: _getRelevanceColor(result.relevanceScore!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(result.relevanceScore! * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getRelevanceColor(result.relevanceScore!),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get source-specific icons
  IconData _getSourceIcon(String? sourceName) {
    switch (sourceName?.toLowerCase()) {
      case 'youtube':
        return Icons.play_circle_outline;
      case 'reddit':
        return Icons.forum;
      case 'ifixit':
        return Icons.build_circle;
      case 'google maps':
        return Icons.location_on;
      default:
        return Icons.public;
    }
  }

  // Helper method to get source-specific colors
  Color _getSourceColor(String? sourceName) {
    switch (sourceName?.toLowerCase()) {
      case 'youtube':
        return Colors.red;
      case 'reddit':
        return Colors.orange;
      case 'ifixit':
        return Colors.blue;
      case 'google maps':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  // Helper method to get relevance-based colors
  Color _getRelevanceColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.grey;
  }

  // Helper method to format URLs for display
  String _formatUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String domain = uri.host;
      if (domain.startsWith('www.')) {
        domain = domain.substring(4);
      }
      return domain;
    } catch (e) {
      // ⚠️ Consider logging this error with Logger.error for better debugging
      Logger.error('Failed to parse URL for display', error: e);
      return url;
    }
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
    if (result.type == SearchResultType.external) {
      // For web results, show a more detailed message with source
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _getSourceIcon(result.sourceName),
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Opening ${result.sourceName ?? 'Web'} Link',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      result.title,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: _getSourceColor(result.sourceName),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'COPY URL',
            textColor: Colors.white,
            onPressed: () {
              // In a real app, you would copy the URL to clipboard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // For internal guides, keep the existing behavior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening guide: ${result.title}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _openGuide(Guide guide) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening guide: ${guide.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  
    try{
      //Fecth steps for this guide
      final steps = await StepService.fetchStepsForGuide(guide.id);

      //Navigate to the steps screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuideStepsScreen(
            guide: guide,
            steps: steps,
          ),
        ),
      );
    }catch(e){
      // ⚠️ Consider logging this error with Logger.error for better debugging
      Logger.error('Failed to load steps for guide', error: e);
      //Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text ('Failed to load steps for ${guide.title}')),
      );
    }
  }
}