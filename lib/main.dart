import 'package:flutter/material.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'screens/main_navigation_screen.dart';
import 'services/theme_service.dart';
import 'services/local_storage_service.dart';
import 'utils/theme_extensions.dart';

const Color primarySeedColor = Color(0xFF20130D); // your color (dark brownish)
const Color secondarySeedColor = Color.fromARGB(255, 87, 70, 63); // optional (blue)
const Color tertiarySeedColor = Color.fromARGB(255, 236, 235, 235); // optional (green)

final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
  brightness: Brightness.light,
  primaryKey: primarySeedColor,
  tones: FlexTones.vivid(Brightness.light), // more colorful
);

final ColorScheme schemeDark = SeedColorScheme.fromSeeds(
  brightness: Brightness.dark,
  primaryKey: primarySeedColor,
  tones: FlexTones.vivid(Brightness.dark),
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await ThemeService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Repair Guide App',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeService().themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          home: const MainNavigationScreen(),
          // Enhanced accessibility and navigation
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 2.0,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: schemeLight,
      useMaterial3: true,
      
      // Add theme extensions
      extensions: const [
        AppSpacing.light,
        AppBorderRadius.light,
        AppElevation.light,
      ],
      
      // Enhanced AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: schemeLight.primary,
        foregroundColor: schemeLight.onPrimary,
        elevation: 2,
        shadowColor: schemeLight.shadow,
        surfaceTintColor: schemeLight.surfaceTint,
        titleTextStyle: TextStyle(
          color: schemeLight.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Enhanced Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: schemeLight.shadow.withValues(alpha: 0.1),
        surfaceTintColor: schemeLight.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      
      // Enhanced Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 44), // Accessibility: minimum touch target
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 44), // Accessibility: minimum touch target
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(64, 44), // Accessibility: minimum touch target
        ),
      ),
      
      // Enhanced Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: schemeLight.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeLight.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeLight.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeLight.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Enhanced List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // Enhanced Divider theme
      dividerTheme: DividerThemeData(
        color: schemeLight.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
      
      // Enhanced page transitions for smooth navigation
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      
      // Enhanced animation and interaction
      splashFactory: InkRipple.splashFactory,
      
      // Enhanced text theme with better accessibility
      textTheme: _buildTextTheme(schemeLight),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: schemeDark,
      useMaterial3: true,
      
      // Add theme extensions
      extensions: const [
        AppSpacing.dark,
        AppBorderRadius.dark,
        AppElevation.dark,
      ],
      
      // Enhanced AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: schemeDark.primary,
        foregroundColor: schemeDark.onPrimary,
        elevation: 2,
        shadowColor: schemeDark.shadow,
        surfaceTintColor: schemeDark.surfaceTint,
        titleTextStyle: TextStyle(
          color: schemeDark.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Enhanced Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: schemeDark.shadow.withValues(alpha: 0.2),
        surfaceTintColor: schemeDark.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      
      // Enhanced Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 44), // Accessibility: minimum touch target
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 44), // Accessibility: minimum touch target
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(64, 44), // Accessibility: minimum touch target
        ),
      ),
      
      // Enhanced Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: schemeDark.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeDark.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeDark.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeDark.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Enhanced List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // Enhanced Divider theme
      dividerTheme: DividerThemeData(
        color: schemeDark.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
      
      // Enhanced page transitions for smooth navigation
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      
      // Enhanced animation and interaction
      splashFactory: InkRipple.splashFactory,
      
      // Enhanced text theme with better accessibility
      textTheme: _buildTextTheme(schemeDark),
    );
  }

  TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}


