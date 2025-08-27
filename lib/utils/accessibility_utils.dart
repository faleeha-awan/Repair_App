import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  // Semantic labels for common UI elements
  static const String homeTabLabel = 'Home tab';
  static const String searchTabLabel = 'Search tab';
  static const String myGuidesTabLabel = 'My Guides tab';
  static const String chatTabLabel = 'Manuals and Chat tab';
  static const String profileTabLabel = 'Profile tab';

  // Screen reader announcements
  static void announceToScreenReader(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // Use SemanticsService for proper screen reader announcements
        SemanticsService.announce(message, TextDirection.ltr);
      }
    });
  }

  // Announce screen changes
  static void announceScreenChange(BuildContext context, String screenName) {
    announceToScreenReader(context, 'Navigated to $screenName screen');
  }

  // Announce actions
  static void announceAction(BuildContext context, String action) {
    announceToScreenReader(context, action);
  }

  // Provide haptic feedback
  static void provideFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.impact:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.success:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.error:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  // Create accessible button
  static Widget createAccessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String semanticLabel,
    String? tooltip,
    bool enabled = true,
    ButtonStyle? style,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: enabled,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: style,
          child: child,
        ),
      ),
    );
  }

  // Create accessible icon button
  static Widget createAccessibleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String semanticLabel,
    String? tooltip,
    bool enabled = true,
    Color? color,
    double? size,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: enabled,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: IconButton(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, color: color, size: size),
          constraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }

  // Create accessible text field
  static Widget createAccessibleTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? semanticLabel,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: semanticLabel ?? labelText,
      textField: true,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }

  // Create accessible card
  static Widget createAccessibleCard({
    required Widget child,
    required VoidCallback onTap,
    required String semanticLabel,
    String? tooltip,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: Card(
          margin: margin,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  // Create accessible list tile
  static Widget createAccessibleListTile({
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    required String semanticLabel,
    String? tooltip,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          minVerticalPadding: 12,
        ),
      ),
    );
  }

  // Create accessible switch
  static Widget createAccessibleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String semanticLabel,
    String? tooltip,
  }) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Create heading with proper semantics
  static Widget createHeading({
    required String text,
    required TextStyle style,
    int level = 1,
    TextAlign? textAlign,
  }) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        semanticsLabel: 'Heading level $level: $text',
      ),
    );
  }

  // Create accessible progress indicator
  static Widget createAccessibleProgress({
    required double value,
    required String semanticLabel,
    Color? backgroundColor,
    Color? valueColor,
  }) {
    final percentage = (value * 100).round();
    return Semantics(
      label: '$semanticLabel: $percentage percent complete',
      value: '$percentage%',
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor != null 
            ? AlwaysStoppedAnimation<Color>(valueColor)
            : null,
      ),
    );
  }

  // Create accessible image
  static Widget createAccessibleImage({
    required ImageProvider image,
    required String semanticLabel,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
      ),
    );
  }

  // Focus management helpers
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static void clearFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Keyboard navigation helpers
  static Widget createKeyboardNavigable({
    required Widget child,
    required VoidCallback onActivate,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            onActivate();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Focus.of(context).hasFocus
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: semanticLabel != null
                ? Semantics(
                    label: semanticLabel,
                    button: true,
                    child: child,
                  )
                : child,
          );
        },
      ),
    );
  }

  // Enhanced keyboard navigation for tab navigation
  static Widget createTabKeyboardNavigable({
    required Widget child,
    required int tabIndex,
    required int currentIndex,
    required Function(int) onTabChanged,
    required String tabLabel,
  }) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            final newIndex = currentIndex > 0 ? currentIndex - 1 : 4;
            onTabChanged(newIndex);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            final newIndex = currentIndex < 4 ? currentIndex + 1 : 0;
            onTabChanged(newIndex);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
                     event.logicalKey == LogicalKeyboardKey.space) {
            onTabChanged(tabIndex);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Focus.of(context).hasFocus
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Semantics(
              label: tabLabel,
              button: true,
              selected: tabIndex == currentIndex,
              child: child,
            ),
          );
        },
      ),
    );
  }

  // Color contrast helpers
  static bool hasGoodContrast(Color foreground, Color background) {
    final foregroundLuminance = foreground.computeLuminance();
    final backgroundLuminance = background.computeLuminance();
    
    final lighter = foregroundLuminance > backgroundLuminance 
        ? foregroundLuminance 
        : backgroundLuminance;
    final darker = foregroundLuminance > backgroundLuminance 
        ? backgroundLuminance 
        : foregroundLuminance;
    
    final contrastRatio = (lighter + 0.05) / (darker + 0.05);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  // Text size helpers
  static double getAccessibleTextSize(BuildContext context, double baseSize) {
    final textScaler = MediaQuery.of(context).textScaler;
    return textScaler.scale(baseSize);
  }
}

enum HapticFeedbackType {
  selection,
  impact,
  success,
  error,
}