import 'package:flutter/material.dart';

// Custom theme extensions for consistent styling
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static const AppSpacing light = AppSpacing(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );

  static const AppSpacing dark = AppSpacing(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}

@immutable
class AppBorderRadius extends ThemeExtension<AppBorderRadius> {
  const AppBorderRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  static const AppBorderRadius light = AppBorderRadius(
    xs: 4.0,
    sm: 8.0,
    md: 12.0,
    lg: 16.0,
    xl: 24.0,
  );

  static const AppBorderRadius dark = AppBorderRadius(
    xs: 4.0,
    sm: 8.0,
    md: 12.0,
    lg: 16.0,
    xl: 24.0,
  );

  @override
  AppBorderRadius copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppBorderRadius(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppBorderRadius lerp(ThemeExtension<AppBorderRadius>? other, double t) {
    if (other is! AppBorderRadius) {
      return this;
    }
    return AppBorderRadius(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
    );
  }
}

@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.none,
    required this.low,
    required this.medium,
    required this.high,
  });

  final double none;
  final double low;
  final double medium;
  final double high;

  static const AppElevation light = AppElevation(
    none: 0.0,
    low: 2.0,
    medium: 4.0,
    high: 8.0,
  );

  static const AppElevation dark = AppElevation(
    none: 0.0,
    low: 2.0,
    medium: 4.0,
    high: 8.0,
  );

  @override
  AppElevation copyWith({
    double? none,
    double? low,
    double? medium,
    double? high,
  }) {
    return AppElevation(
      none: none ?? this.none,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
    );
  }

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) {
      return this;
    }
    return AppElevation(
      none: lerpDouble(none, other.none, t) ?? none,
      low: lerpDouble(low, other.low, t) ?? low,
      medium: lerpDouble(medium, other.medium, t) ?? medium,
      high: lerpDouble(high, other.high, t) ?? high,
    );
  }
}

// Helper function to get theme extensions
extension ThemeExtensions on ThemeData {
  AppSpacing get spacing => extension<AppSpacing>() ?? AppSpacing.light;
  AppBorderRadius get borderRadius => extension<AppBorderRadius>() ?? AppBorderRadius.light;
  AppElevation get elevation => extension<AppElevation>() ?? AppElevation.light;
}

// Helper function for lerping doubles
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

// Consistent component styles
class AppStyles {
  static BoxDecoration cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(theme.borderRadius.md),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: theme.elevation.low,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  static BoxDecoration containerDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(theme.borderRadius.md),
    );
  }

  static BoxDecoration inputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(theme.borderRadius.sm),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.5),
      ),
    );
  }

  static TextStyle headingStyle(BuildContext context, {bool isLarge = false}) {
    final theme = Theme.of(context);
    return (isLarge ? theme.textTheme.headlineMedium : theme.textTheme.headlineSmall)!
        .copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle bodyStyle(BuildContext context, {bool isLarge = false}) {
    final theme = Theme.of(context);
    return (isLarge ? theme.textTheme.bodyLarge : theme.textTheme.bodyMedium)!
        .copyWith(
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle captionStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  // Accessibility-compliant button styles
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: theme.elevation.low,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.lg,
        vertical: theme.spacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.sm),
      ),
      minimumSize: const Size(88, 44), // Accessibility minimum
    );
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      side: BorderSide(color: theme.colorScheme.primary),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.lg,
        vertical: theme.spacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.sm),
      ),
      minimumSize: const Size(88, 44), // Accessibility minimum
    );
  }

  // Consistent spacing helpers
  static Widget verticalSpacing(BuildContext context, {bool isLarge = false}) {
    final theme = Theme.of(context);
    return SizedBox(height: isLarge ? theme.spacing.xl : theme.spacing.lg);
  }

  static Widget horizontalSpacing(BuildContext context, {bool isLarge = false}) {
    final theme = Theme.of(context);
    return SizedBox(width: isLarge ? theme.spacing.xl : theme.spacing.lg);
  }
}