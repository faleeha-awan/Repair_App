import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../models/steps.dart';
import '../utils/translation_service.dart';
import '../utils/tts_service.dart';
import '../utils/logger.dart';

class GuideStepsScreen extends StatefulWidget {
  final Guide guide;
  final List<StepModel> steps;

  const GuideStepsScreen({
    super.key,
    required this.guide,
    required this.steps,
  });

  @override
  State<GuideStepsScreen> createState() => _GuideStepsScreenState();
}

class _GuideStepsScreenState extends State<GuideStepsScreen> {
  String _selectedLanguage = 'en';
  final Map<String, String> _translatedTexts = {};
  final Set<String> _loadingTranslations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guide.title),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTranslationBar(),
          Expanded(
            child: widget.steps.isNotEmpty
                ? _buildStepsList()
                : const Center(
                    child: Text(
                      "No steps found for this guide",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.translate,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Language:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isDense: true,
                items: TranslationService.getSupportedLanguageCodes()
                    .map((code) => DropdownMenuItem(
                          value: code,
                          child: Text(
                            TranslationService.getLanguageName(code),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
                onChanged: (String? newLanguage) {
                  if (newLanguage != null) {
                    setState(() {
                      _selectedLanguage = newLanguage;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        final step = widget.steps[index];
        return _buildStepCard(step, index);
      },
    );
  }

  Widget _buildStepCard(StepModel step, int index) {
    final translationKey = '${step.id}_$_selectedLanguage';
    final translatedTitle = _translatedTexts[translationKey] ?? step.title;
    final isTranslating = _loadingTranslations.contains(translationKey);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step header with actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Step ${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (_selectedLanguage != 'en')
                  IconButton(
                    onPressed: isTranslating ? null : () => _translateStep(step),
                    icon: isTranslating
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.translate,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                    tooltip: 'Translate this step',
                  ),
                IconButton(
                  onPressed: () => _speakStep(translatedTitle),
                  icon: Icon(
                    Icons.volume_up,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Read aloud',
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Step image
            if (step.imageUrl != null)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    step.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            
            // Step title
            Text(
              translatedTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _translateStep(StepModel step) async {
    final translationKey = '${step.id}_$_selectedLanguage';
    
    if (_translatedTexts.containsKey(translationKey)) {
      return; // Already translated
    }

    setState(() {
      _loadingTranslations.add(translationKey);
    });

    try {
      final translatedText = await TranslationService.translateText(
        step.title,
        _selectedLanguage,
      );
      
      setState(() {
        _translatedTexts[translationKey] = translatedText;
        _loadingTranslations.remove(translationKey);
      });
    } catch (e) {
      Logger.error('Translation failed for step ${step.id}', error: e);
      setState(() {
        _loadingTranslations.remove(translationKey);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _speakStep(String text) async {
    try {
      await TTSService.speak(text, languageCode: _selectedLanguage);
    } catch (e) {
      Logger.error('Text-to-speech failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Text-to-speech failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    TTSService.stop();
    super.dispose();
  }
}
