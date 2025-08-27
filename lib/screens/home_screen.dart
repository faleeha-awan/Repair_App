import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../services/local_storage_service.dart';
import '../utils/accessibility_utils.dart';
import '../utils/responsive_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Guide> _recentGuides = [];
  bool _isLoading = true;
  final String _welcomeMessage = "We're here to guide you step by step";

  @override
  void initState() {
    super.initState();
    _loadRecentGuides();
    _loadDummyDataIfEmpty();
  }

  Future<void> _loadRecentGuides() async {
    try {
      final guides = await LocalStorageService.getRecentGuides();
      setState(() {
        _recentGuides = guides;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDummyDataIfEmpty() async {
    final guides = await LocalStorageService.getRecentGuides();
    if (guides.isEmpty) {
      // Add some dummy data for testing
      final dummyGuides = [
        Guide(
          id: '1',
          title: 'Fix iPhone Screen Replacement',
          thumbnailUrl: null,
          lastOpened: DateTime.now().subtract(const Duration(hours: 2)),
          totalSteps: 8,
          completedSteps: 3,
          isBookmarked: true,
        ),
        Guide(
          id: '2',
          title: 'Repair Washing Machine Drain',
          thumbnailUrl: null,
          lastOpened: DateTime.now().subtract(const Duration(days: 1)),
          totalSteps: 5,
          completedSteps: 5,
          isBookmarked: false,
        ),
        Guide(
          id: '3',
          title: 'Fix Laptop Keyboard Keys',
          thumbnailUrl: null,
          lastOpened: DateTime.now().subtract(const Duration(days: 3)),
          totalSteps: 6,
          completedSteps: 2,
          isBookmarked: true,
        ),
      ];

      for (final guide in dummyGuides) {
        await LocalStorageService.addRecentGuide(guide);
      }
      
      _loadRecentGuides();
    }
  }

  Future<void> _removeGuide(String guideId) async {
    await LocalStorageService.removeRecentGuide(guideId);
    _loadRecentGuides();
  }

  void _openGuide(Guide guide) {
    // Navigate to My Guides tab or guide detail view
    // For now, just show a snackbar as placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening guide: ${guide.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveUtils.isLargeScreen(context);
    final padding = isLargeScreen ? const EdgeInsets.all(24.0) : const EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Home'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _isLoading
          ? Semantics(
              label: 'Loading recent guides',
              child: const Center(child: CircularProgressIndicator()),
            )
          : RefreshIndicator(
              onRefresh: _loadRecentGuides,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Message Section
                    _buildWelcomeSection(context, isLargeScreen),
                    SizedBox(height: isLargeScreen ? 32 : 24),
                    
                    // Recent Guides Section
                    _buildRecentGuidesSection(context, isLargeScreen),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, bool isLargeScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconSize = isLargeScreen ? 40.0 : 32.0;
    final padding = isLargeScreen ? 24.0 : 20.0;

    return Semantics(
      label: 'Welcome section',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Repair service icon',
              child: Icon(
                Icons.home_repair_service,
                size: iconSize,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: isLargeScreen ? 16 : 12),
            Semantics(
              header: true,
              child: Text(
                _welcomeMessage,
                style: (isLargeScreen 
                    ? textTheme.headlineMedium 
                    : textTheme.headlineSmall)?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: isLargeScreen ? 12 : 8),
            Text(
              'Find repair guides, upload manuals, and get expert help.',
              style: (isLargeScreen 
                  ? textTheme.bodyLarge 
                  : textTheme.bodyMedium)?.copyWith(
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentGuidesSection(BuildContext context, bool isLargeScreen) {
    final textTheme = Theme.of(context).textTheme;
    final spacing = isLargeScreen ? 20.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Recent Guides',
                style: (isLargeScreen 
                    ? textTheme.headlineSmall 
                    : textTheme.titleLarge)?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (_recentGuides.isNotEmpty)
              Semantics(
                label: 'View all recent guides',
                button: true,
                child: TextButton(
                  onPressed: () {
                    AccessibilityUtils.announceAction(context, 'Navigating to My Guides tab');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigate to My Guides tab'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing),
        
        _recentGuides.isEmpty
            ? _buildEmptyState(context, isLargeScreen)
            : _buildGuidesList(context, isLargeScreen),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isLargeScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconSize = isLargeScreen ? 64.0 : 48.0;
    final padding = isLargeScreen ? 40.0 : 32.0;

    return Semantics(
      label: 'No recent guides available. Start exploring to see guides here.',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Semantics(
              label: 'Search icon indicating no guides found',
              child: Icon(
                Icons.search,
                size: iconSize,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: isLargeScreen ? 20 : 16),
            Text(
              'No recent guides yet',
              style: (isLargeScreen 
                  ? textTheme.titleLarge 
                  : textTheme.titleMedium)?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isLargeScreen ? 12 : 8),
            Text(
              'Start exploring to see them here!',
              style: (isLargeScreen 
                  ? textTheme.bodyLarge 
                  : textTheme.bodyMedium)?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidesList(BuildContext context, bool isLargeScreen) {
    final spacing = isLargeScreen ? 16.0 : 12.0;

    return Semantics(
      label: 'List of ${_recentGuides.length} recent guides',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _recentGuides.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) {
          final guide = _recentGuides[index];
          return GuideCard(
            guide: guide,
            onTap: () => _openGuide(guide),
            onRemove: () => _removeGuide(guide.id),
            isLargeScreen: isLargeScreen,
          );
        },
      ),
    );
  }
}

class GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isLargeScreen;

  const GuideCard({
    super.key,
    required this.guide,
    required this.onTap,
    required this.onRemove,
    this.isLargeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final thumbnailSize = isLargeScreen ? 80.0 : 60.0;
    final padding = isLargeScreen ? 20.0 : 16.0;
    final progressPercentage = (guide.progressPercentage * 100).round();

    return Semantics(
      label: 'Guide: ${guide.title}. Progress: $progressPercentage percent complete. Last opened ${_formatLastOpened(guide.lastOpened)}. ${guide.isBookmarked ? 'Bookmarked.' : ''}',
      button: true,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                // Thumbnail or placeholder
                Semantics(
                  label: 'Guide thumbnail for ${guide.title}',
                  child: Container(
                    width: thumbnailSize,
                    height: thumbnailSize,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: guide.thumbnailUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              guide.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderThumbnail(context);
                              },
                            ),
                          )
                        : _buildPlaceholderThumbnail(context),
                  ),
                ),
                SizedBox(width: isLargeScreen ? 20 : 16),
                
                // Guide information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          guide.title,
                          style: (isLargeScreen 
                              ? textTheme.titleLarge 
                              : textTheme.titleMedium)?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: isLargeScreen ? 8 : 4),
                      
                      // Progress indicator
                      Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              label: 'Progress: $progressPercentage percent complete',
                              value: '$progressPercentage%',
                              child: LinearProgressIndicator(
                                value: guide.progressPercentage,
                                backgroundColor: colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: isLargeScreen ? 12 : 8),
                          Text(
                            '${guide.completedSteps}/${guide.totalSteps}',
                            style: (isLargeScreen 
                                ? textTheme.bodyMedium 
                                : textTheme.bodySmall)?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? 8 : 4),
                      
                      // Last opened date
                      Text(
                        _formatLastOpened(guide.lastOpened),
                        style: (isLargeScreen 
                            ? textTheme.bodyMedium 
                            : textTheme.bodySmall)?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Actions
                Column(
                  children: [
                    if (guide.isBookmarked)
                      Semantics(
                        label: 'This guide is bookmarked',
                        child: Icon(
                          Icons.bookmark,
                          color: colorScheme.primary,
                          size: isLargeScreen ? 24 : 20,
                        ),
                      ),
                    SizedBox(height: isLargeScreen ? 12 : 8),
                    Semantics(
                      label: 'Remove ${guide.title} from recent guides',
                      button: true,
                      child: IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onSurfaceVariant,
                          size: isLargeScreen ? 24 : 20,
                        ),
                        tooltip: 'Remove from recent',
                        constraints: BoxConstraints(
                          minWidth: isLargeScreen ? 48 : 44,
                          minHeight: isLargeScreen ? 48 : 44,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderThumbnail(BuildContext context) {
    return Semantics(
      label: 'Repair tool icon placeholder',
      child: Icon(
        Icons.build,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: isLargeScreen ? 36 : 28,
      ),
    );
  }

  String _formatLastOpened(DateTime lastOpened) {
    final now = DateTime.now();
    final difference = now.difference(lastOpened);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}