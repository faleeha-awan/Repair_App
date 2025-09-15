import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../utils/accessibility_utils.dart';
import '../utils/responsive_utils.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final String currentLanguageCode;
  final Function(String) onLanguageSelected;

  const LanguageSelectionDialog({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageSelectionDialog> createState() => _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  String? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLargeScreen = ResponsiveUtils.isLargeScreen(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Semantics(
        header: true,
        child: Text(
          l10n.selectLanguage,
          style: (isLargeScreen ? textTheme.headlineSmall : textTheme.titleLarge)?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: SizedBox(
        width: isLargeScreen ? 400 : double.maxFinite,
        child: Semantics(
          label: 'List of available languages',
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: LanguageService.supportedLanguages.entries.map((entry) {
                final languageCode = entry.key;
                final languageData = entry.value;
                final isSelected = _selectedLanguageCode == languageCode;

                return Semantics(
                  label: '${languageData['name']} (${languageData['nativeName']})${isSelected ? ', selected' : ''}',
                  button: true,
                  selected: isSelected,
                  child: ListTile(
                    leading: Radio<String>(
                      value: languageCode,
                      groupValue: _selectedLanguageCode,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguageCode = value;
                        });
                        AccessibilityUtils.announceAction(
                          context,
                          '${languageData['name']} selected',
                        );
                      },
                      activeColor: colorScheme.primary,
                    ),
                    title: Text(
                      languageData['name']!,
                      style: (isLargeScreen ? textTheme.bodyLarge : textTheme.bodyMedium)?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      languageData['nativeName']!,
                      style: (isLargeScreen ? textTheme.bodyMedium : textTheme.bodySmall)?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 16 : 8,
                      vertical: isLargeScreen ? 8 : 4,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = languageCode;
                      });
                      AccessibilityUtils.announceAction(
                        context,
                        '${languageData['name']} selected',
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        Semantics(
          label: 'Cancel language selection',
          button: true,
          child: TextButton(
            onPressed: () {
              AccessibilityUtils.announceAction(context, 'Language selection cancelled');
              Navigator.of(context).pop();
            },
            child: Text(l10n.cancel),
          ),
        ),
        Semantics(
          label: 'Confirm language selection',
          button: true,
          child: ElevatedButton(
            onPressed: _selectedLanguageCode != null
                ? () {
                    final selectedLanguage = LanguageService.supportedLanguages[_selectedLanguageCode!];
                    AccessibilityUtils.announceAction(
                      context,
                      'Language changed to ${selectedLanguage?['name']}',
                    );
                    widget.onLanguageSelected(_selectedLanguageCode!);
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(l10n.select),
          ),
        ),
      ],
    );
  }
}