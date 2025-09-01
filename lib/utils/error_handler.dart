import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Centralized error handling for the application
/// Provides consistent error handling, logging, and user feedback
class ErrorHandler {
  // Prevent instantiation
  ErrorHandler._();

  /// Handle and display errors to the user
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    bool showSnackBar = true,
    VoidCallback? onRetry,
  }) {
    final errorMessage = _getErrorMessage(error, customMessage);
    
    // Log error for debugging
    _logError(error, errorMessage);
    
    // Show user-friendly message
    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(context, errorMessage, onRetry);
    }
  }

  /// Handle API errors specifically
  static void handleApiError(
    BuildContext context,
    ApiException error, {
    String? customMessage,
    bool showSnackBar = true,
    VoidCallback? onRetry,
  }) {
    String userMessage;
    
    // Provide specific messages based on status code
    switch (error.statusCode) {
      case 400:
        userMessage = customMessage ?? 'Invalid request. Please check your input.';
        break;
      case 401:
        userMessage = customMessage ?? 'Please sign in to continue.';
        break;
      case 403:
        userMessage = customMessage ?? 'You don\'t have permission to access this.';
        break;
      case 404:
        userMessage = customMessage ?? 'The requested content was not found.';
        break;
      case 429:
        userMessage = customMessage ?? 'Too many requests. Please try again later.';
        break;
      case 500:
      case 502:
      case 503:
        userMessage = customMessage ?? 'Server error. Please try again later.';
        break;
      default:
        userMessage = customMessage ?? 'Something went wrong. Please try again.';
    }
    
    _logError(error, userMessage);
    
    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(context, userMessage, onRetry);
    }
  }

  /// Handle network connectivity errors
  static void handleNetworkError(
    BuildContext context, {
    String? customMessage,
    bool showSnackBar = true,
    VoidCallback? onRetry,
  }) {
    const userMessage = 'No internet connection. Please check your network and try again.';
    final message = customMessage ?? userMessage;
    
    _logError('Network Error', message);
    
    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(
        context, 
        message, 
        onRetry,
        icon: Icons.wifi_off,
      );
    }
  }

  /// Handle file upload errors
  static void handleFileError(
    BuildContext context,
    String error, {
    String? customMessage,
    bool showSnackBar = true,
  }) {
    String userMessage;
    
    if (error.contains('size')) {
      userMessage = 'File is too large. Please select a smaller file.';
    } else if (error.contains('type') || error.contains('format')) {
      userMessage = 'File type not supported. Please select a PDF or image file.';
    } else if (error.contains('permission')) {
      userMessage = 'Permission denied. Please allow file access.';
    } else {
      userMessage = customMessage ?? 'Failed to process file. Please try again.';
    }
    
    _logError('File Error', error);
    
    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(context, userMessage, null);
    }
  }

  /// Handle validation errors
  static void handleValidationError(
    BuildContext context,
    String field,
    String error, {
    bool showSnackBar = true,
  }) {
    final userMessage = 'Invalid $field: $error';
    
    _logError('Validation Error', userMessage);
    
    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(context, userMessage, null);
    }
  }

  /// Show success message
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show info message
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show warning message
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning,
              color: Theme.of(context).colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  static String _getErrorMessage(dynamic error, String? customMessage) {
    if (customMessage != null) return customMessage;
    
    if (error is ApiException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred';
    }
  }

  static void _logError(dynamic error, String message) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('Details: $error');
      }
    }
    
    // TODO: Send to crash reporting service in production
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  static void _showErrorSnackBar(
    BuildContext context,
    String message,
    VoidCallback? onRetry, {
    IconData icon = Icons.error,
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Theme.of(context).colorScheme.onError,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
}

/// Custom exception types for better error handling
class ValidationException implements Exception {
  final String field;
  final String message;
  
  const ValidationException(this.field, this.message);
  
  @override
  String toString() => 'ValidationException: $field - $message';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class FileException implements Exception {
  final String message;
  final String? fileName;
  
  const FileException(this.message, [this.fileName]);
  
  @override
  String toString() => 'FileException: $message${fileName != null ? ' ($fileName)' : ''}';
}