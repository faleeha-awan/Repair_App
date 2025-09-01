import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Centralized logging system for the application
/// Provides structured logging with different levels and categories
class Logger {
  // Prevent instantiation
  Logger._();

  /// Log levels
  static const String _debug = 'DEBUG';
  static const String _info = 'INFO';
  static const String _warning = 'WARNING';
  static const String _error = 'ERROR';

  /// Log categories
  static const String _api = 'API';
  static const String _ui = 'UI';
  static const String _storage = 'STORAGE';
  static const String _navigation = 'NAVIGATION';
  static const String _auth = 'AUTH';
  static const String _file = 'FILE';
  static const String _theme = 'THEME';
  static const String _performance = 'PERFORMANCE';

  // ============================================================================
  // PUBLIC LOGGING METHODS
  // ============================================================================

  /// Log debug information
  static void debug(String message, {String? category, dynamic data}) {
    _log(_debug, message, category: category, data: data);
  }

  /// Log general information
  static void info(String message, {String? category, dynamic data}) {
    _log(_info, message, category: category, data: data);
  }

  /// Log warnings
  static void warning(String message, {String? category, dynamic data}) {
    _log(_warning, message, category: category, data: data);
  }

  /// Log errors
  static void error(String message, {String? category, dynamic error, StackTrace? stackTrace}) {
    _log(_error, message, category: category, data: error);
    if (stackTrace != null && AppConfig.enableDebugLogging) {
      print('Stack trace: $stackTrace');
    }
  }

  // ============================================================================
  // CATEGORY-SPECIFIC LOGGING METHODS
  // ============================================================================

  /// Log API-related events
  static void api(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _api, data: data);
  }

  /// Log UI-related events
  static void ui(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _ui, data: data);
  }

  /// Log storage-related events
  static void storage(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _storage, data: data);
  }

  /// Log navigation events
  static void navigation(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _navigation, data: data);
  }

  /// Log authentication events
  static void auth(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _auth, data: data);
  }

  /// Log file operations
  static void file(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _file, data: data);
  }

  /// Log theme changes
  static void theme(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _theme, data: data);
  }

  /// Log performance metrics
  static void performance(String message, {String level = _info, dynamic data}) {
    _log(level, message, category: _performance, data: data);
  }

  // ============================================================================
  // SPECIALIZED LOGGING METHODS
  // ============================================================================

  /// Log API request
  static void apiRequest(String method, String endpoint, {Map<String, dynamic>? params}) {
    if (!AppConfig.enableDebugLogging) return;
    
    final message = '$method $endpoint';
    _log(_info, message, category: _api, data: params);
  }

  /// Log API response
  static void apiResponse(String endpoint, int statusCode, {dynamic data}) {
    if (!AppConfig.enableDebugLogging) return;
    
    final level = statusCode >= 400 ? _error : _info;
    final message = '$endpoint - Status: $statusCode';
    _log(level, message, category: _api, data: data);
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? context}) {
    if (!AppConfig.enableDebugLogging) return;
    
    _log(_info, 'User action: $action', category: _ui, data: context);
  }

  /// Log screen navigation
  static void screenNavigation(String from, String to) {
    if (!AppConfig.enableDebugLogging) return;
    
    _log(_info, 'Navigation: $from -> $to', category: _navigation);
  }

  /// Log performance timing
  static void performanceTiming(String operation, Duration duration) {
    if (!AppConfig.enablePerformanceMonitoring) return;
    
    final message = '$operation completed in ${duration.inMilliseconds}ms';
    _log(_info, message, category: _performance);
  }

  /// Log memory usage (if available)
  static void memoryUsage(String context, {int? usedMemoryMB}) {
    if (!AppConfig.enablePerformanceMonitoring) return;
    
    final message = usedMemoryMB != null 
        ? '$context - Memory: ${usedMemoryMB}MB'
        : '$context - Memory check';
    _log(_info, message, category: _performance);
  }

  /// Log file operation
  static void fileOperation(String operation, String fileName, {bool success = true, String? error}) {
    final level = success ? _info : _error;
    final message = '$operation: $fileName ${success ? 'succeeded' : 'failed'}';
    _log(level, message, category: _file, data: error);
  }

  /// Log authentication event
  static void authEvent(String event, {bool success = true, String? userId, String? error}) {
    final level = success ? _info : _error;
    final message = 'Auth $event ${success ? 'succeeded' : 'failed'}';
    final data = {
      if (userId != null) 'userId': userId,
      if (error != null) 'error': error,
    };
    _log(level, message, category: _auth, data: data.isNotEmpty ? data : null);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Start timing an operation
  static Stopwatch startTiming(String operation) {
    if (AppConfig.enablePerformanceMonitoring) {
      debug('Starting: $operation', category: _performance);
    }
    return Stopwatch()..start();
  }

  /// End timing an operation
  static void endTiming(String operation, Stopwatch stopwatch) {
    if (AppConfig.enablePerformanceMonitoring) {
      stopwatch.stop();
      performanceTiming(operation, stopwatch.elapsed);
    }
  }

  /// Log app lifecycle events
  static void appLifecycle(String event) {
    info('App lifecycle: $event', category: _ui);
  }

  /// Log feature usage
  static void featureUsage(String feature, {Map<String, dynamic>? metadata}) {
    info('Feature used: $feature', category: _ui, data: metadata);
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  static void _log(String level, String message, {String? category, dynamic data}) {
    // Only log if debugging is enabled
    if (!AppConfig.enableDebugLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final categoryStr = category != null ? '[$category] ' : '';
    final logMessage = '$timestamp [$level] $categoryStr$message';

    // Print to console in debug mode
    if (kDebugMode) {
      print(logMessage);
      if (data != null) {
        print('  Data: $data');
      }
    }

    // TODO: In production, send logs to external service
    // Examples:
    // - Firebase Analytics for user behavior
    // - Sentry for error tracking
    // - Custom logging service
    
    // Store critical logs locally for debugging
    if (level == _error || level == _warning) {
      _storeCriticalLog(logMessage, data);
    }
  }

  static void _storeCriticalLog(String message, dynamic data) {
    // TODO: Store critical logs locally for later analysis
    // This could use SharedPreferences or a local database
    // to keep recent error logs that can be sent to support
    
    if (kDebugMode) {
      print('CRITICAL LOG STORED: $message');
    }
  }
}

/// Performance monitoring helper
class PerformanceMonitor {
  final String _operation;
  final Stopwatch _stopwatch;

  PerformanceMonitor(this._operation) : _stopwatch = Stopwatch()..start();

  /// End monitoring and log the result
  void end() {
    _stopwatch.stop();
    Logger.performanceTiming(_operation, _stopwatch.elapsed);
  }

  /// Get elapsed time without ending monitoring
  Duration get elapsed => _stopwatch.elapsed;
}

/// Extension for easy performance monitoring
extension PerformanceLogging on Future<T> Function<T>() {
  /// Monitor the performance of a future operation
  Future<T> withPerformanceLogging<T>(String operation) async {
    final monitor = PerformanceMonitor(operation);
    try {
      final result = await this();
      monitor.end();
      return result;
    } catch (e) {
      monitor.end();
      Logger.error('Operation failed: $operation', error: e);
      rethrow;
    }
  }
}