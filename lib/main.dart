import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'screens/main_navigation_screen.dart';
import 'services/theme_service.dart';
import 'services/local_storage_service.dart';
import 'services/language_service.dart';
import 'utils/theme_extensions.dart';
import 'utils/logger.dart';
// Error handler will be used when needed
import 'config/app_config.dart';
import 'constants/app_constants.dart';
import 'l10n/app_localizations.dart';

const Color primarySeedColor = Color(0xFF20130D); // your color (dark brownish)
const Color secondarySeedColor = Color.fromARGB(
  255,
  87,
  70,
  63,
); // optional (blue)
const Color tertiarySeedColor = Color.fromARGB(
  255,
  236,
  235,
  235,
); // optional (green)

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
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.error(
      'Flutter Error: ${details.exception}',
      category: 'FLUTTER',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  try {
    //Supabase Initialization
    await Supabase.initialize(
      url: 'https://zkusbrqucelmnpitvowi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InprdXNicnF1Y2VsbW5waXR2b3dpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NDQyODksImV4cCI6MjA2NjAyMDI4OX0.yukkplN9yTjjSypTThSQA95eruB0v6I7k9gc9UVrf2M',
    );

    Logger.info('Initializing app services...');

    await LocalStorageService.init();
    Logger.info('Local storage service initialized');

    await ThemeService().initialize();
    Logger.info('Theme service initialized');

    await LanguageService().initialize();
    Logger.info('Language service initialized');

    Logger.info('App initialization completed successfully');
  } catch (e, stackTrace) {
    Logger.error(
      'Failed to initialize app services',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeService().themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),

          // Localization configuration
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,
          locale: LanguageService().currentLocale,

          home: const MainNavigationScreen(),

          // Enhanced accessibility and navigation
          builder: (context, child) {
            // Set up global error handling for the widget tree
            ErrorWidget.builder = (FlutterErrorDetails details) {
              Logger.error(
                'Widget Error: ${details.exception}',
                category: 'WIDGET',
                error: details.exception,
                stackTrace: details.stack,
              );

              // Return a user-friendly error widget in production
              if (AppConfig.isProduction) {
                return Material(
                  child: Container(
                    color: Colors.red.shade50,
                    child: const Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              }

              // Return default error widget in debug mode
              return ErrorWidget(details.exception);
            };

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: AppConfig.minTextScaleFactor,
                  maxScaleFactor: AppConfig.maxTextScaleFactor,
                ),
              ),
              child: child!,
            );
          },

          // Navigation observer for logging
          navigatorObservers: [_NavigationLogger()],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),

      // Enhanced Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            88,
            44,
          ), // Accessibility: minimum touch target
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            88,
            44,
          ), // Accessibility: minimum touch target
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            64,
            44,
          ), // Accessibility: minimum touch target
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
          borderSide: BorderSide(
            color: schemeLight.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeLight.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Enhanced List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),

      // Enhanced Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            88,
            44,
          ), // Accessibility: minimum touch target
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            88,
            44,
          ), // Accessibility: minimum touch target
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(
            64,
            44,
          ), // Accessibility: minimum touch target
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
          borderSide: BorderSide(
            color: schemeDark.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: schemeDark.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Enhanced List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

/// Navigation observer for logging screen changes
class _NavigationLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && oldRoute != null) {
      _logNavigation('REPLACE', newRoute, oldRoute);
    }
  }

  void _logNavigation(
    String action,
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    final routeName = route.settings.name ?? route.runtimeType.toString();
    final previousRouteName =
        previousRoute?.settings.name ?? previousRoute?.runtimeType.toString();

    Logger.navigation('$action: ${previousRouteName ?? 'null'} -> $routeName');
  }
}
