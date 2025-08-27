import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../services/local_storage_service.dart';
import '../utils/dummy_data.dart';

class MyGuidesScreen extends StatefulWidget {
  const MyGuidesScreen({super.key});

  @override
  State<MyGuidesScreen> createState() => _MyGuidesScreenState();
}

class _MyGuidesScreenState extends State<MyGuidesScreen> {
  List<Guide> _savedGuides = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGuides();
  }

  Future<void> _loadSavedGuides() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Try to load from local storage first
      List<Guide> savedGuides = await LocalStorageService.getSavedGuides();
      
      // If no saved guides in storage, use dummy data for testing
      if (savedGuides.isEmpty) {
        savedGuides = DummyData.savedGuides;
        // Save dummy data to local storage for persistence
        await LocalStorageService.saveSavedGuides(savedGuides);
      }

      setState(() {
        _savedGuides = savedGuides;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to dummy data if there's an error
      setState(() {
        _savedGuides = DummyData.savedGuides;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeGuide(String guideId) async {
    try {
      // Remove from local storage
      await LocalStorageService.removeSavedGuide(guideId);
      
      // Update UI
      setState(() {
        _savedGuides.removeWhere((guide) => guide.id == guideId);
      });

      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guide removed from saved guides'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove guide'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToGuideDetail(Guide guide) {
    // Navigate to placeholder Guide Detail View screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuideDetailPlaceholderScreen(guide: guide),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Guides'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedGuides.isEmpty
              ? _buildEmptyState()
              : _buildGuidesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No saved guides yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Search and bookmark guides to access them here.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidesList() {
    return RefreshIndicator(
      onRefresh: _loadSavedGuides,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _savedGuides.length,
        itemBuilder: (context, index) {
          final guide = _savedGuides[index];
          return _buildGuideCard(guide);
        },
      ),
    );
  }

  Widget _buildGuideCard(Guide guide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToGuideDetail(guide),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.build,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Guide info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last accessed: ${_formatDate(guide.lastOpened)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remove button
                  IconButton(
                    onPressed: () => _showRemoveDialog(guide),
                    icon: Icon(
                      Icons.bookmark_remove,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    tooltip: 'Remove from saved guides',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${guide.completedSteps} of ${guide.totalSteps} steps',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '${(guide.progressPercentage * 100).round()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: guide.progressPercentage,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveDialog(Guide guide) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Guide'),
          content: Text('Are you sure you want to remove "${guide.title}" from your saved guides?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeGuide(guide.id);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Placeholder Guide Detail View Screen
class GuideDetailPlaceholderScreen extends StatelessWidget {
  final Guide guide;

  const GuideDetailPlaceholderScreen({
    super.key,
    required this.guide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guide Details',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Title', guide.title),
                    _buildDetailRow('Total Steps', '${guide.totalSteps}'),
                    _buildDetailRow('Completed Steps', '${guide.completedSteps}'),
                    _buildDetailRow('Progress', '${(guide.progressPercentage * 100).round()}%'),
                    _buildDetailRow('Last Opened', _formatDate(guide.lastOpened)),
                    _buildDetailRow('Bookmarked', guide.isBookmarked ? 'Yes' : 'No'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.construction,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Guide Detail View',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is a placeholder screen for the detailed guide view.\nStep-by-step instructions will be implemented here.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}