import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/local_storage_service.dart';
import '../models/user_preferences.dart';
import '../utils/responsive_utils.dart';
import '../utils/accessibility_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false; // Placeholder for authentication state
  UserPreferences? _userPreferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await LocalStorageService.getUserPreferences();
      setState(() {
        _userPreferences = prefs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    await ThemeService().setTheme(value);
    if (_userPreferences != null) {
      final updatedPrefs = _userPreferences!.copyWith(isDarkMode: value);
      await LocalStorageService.saveUserPreferences(updatedPrefs);
      setState(() {
        _userPreferences = updatedPrefs;
      });
    }
    
    AccessibilityUtils.announceAction(
      context, 
      value ? 'Dark mode enabled' : 'Light mode enabled'
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
          child: const Text('Profile'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _isLoading
          ? Semantics(
              label: 'Loading user preferences',
              child: const Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Information Section
                  _buildUserInfoSection(context, isLargeScreen),
                  SizedBox(height: isLargeScreen ? 32 : 24),
                  
                  // App Settings Section
                  _buildAppSettingsSection(context, isLargeScreen),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, bool isLargeScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final padding = isLargeScreen ? 24.0 : 20.0;

    return Semantics(
      label: 'User information section',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'User Information',
                  style: (isLargeScreen 
                      ? textTheme.headlineSmall 
                      : textTheme.titleLarge)?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: padding),

              if (_isLoggedIn) ...[
                // Logged in user information (placeholder)
                Semantics(
                  label: 'User profile information',
                  child: Row(
                    children: [
                      Semantics(
                        label: 'Profile picture for John Doe',
                        child: CircleAvatar(
                          radius: isLargeScreen ? 40 : 32,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: isLargeScreen ? 40 : 32,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      SizedBox(width: isLargeScreen ? 20 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: (isLargeScreen 
                                  ? textTheme.titleLarge 
                                  : textTheme.titleMedium)?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isLargeScreen ? 8 : 4),
                            Text(
                              'john.doe@example.com',
                              style: (isLargeScreen 
                                  ? textTheme.bodyLarge 
                                  : textTheme.bodyMedium)?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Not logged in state
                Semantics(
                  label: 'Sign in to access your profile',
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: isLargeScreen ? 64 : 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: isLargeScreen ? 20 : 16),
                        Text(
                          'Sign in to access your profile',
                          style: (isLargeScreen 
                              ? textTheme.titleLarge 
                              : textTheme.titleMedium)?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isLargeScreen ? 20 : 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  AccessibilityUtils.announceAction(context, 'Sign in button pressed');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sign in functionality not implemented yet'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text('Sign In'),
                              ),
                            ),
                            SizedBox(width: isLargeScreen ? 16 : 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  AccessibilityUtils.announceAction(context, 'Sign up button pressed');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sign up functionality not implemented yet'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context, bool isLargeScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final padding = isLargeScreen ? 24.0 : 20.0;

    return Semantics(
      label: 'App settings section',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'App Settings',
                  style: (isLargeScreen 
                      ? textTheme.headlineSmall 
                      : textTheme.titleLarge)?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: padding),

              // Dark Mode Toggle
              Semantics(
                label: 'Dark mode setting. Currently ${_userPreferences?.isDarkMode == true ? 'enabled' : 'disabled'}',
                child: ListTile(
                  leading: Icon(
                    _userPreferences?.isDarkMode == true ? Icons.dark_mode : Icons.light_mode,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: (isLargeScreen 
                        ? textTheme.bodyLarge 
                        : textTheme.bodyMedium)?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    _userPreferences?.isDarkMode == true ? 'Dark theme enabled' : 'Light theme enabled',
                    style: (isLargeScreen 
                        ? textTheme.bodyMedium 
                        : textTheme.bodySmall)?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Semantics(
                    label: 'Toggle dark mode',
                    child: Switch(
                      value: _userPreferences?.isDarkMode ?? false,
                      onChanged: _toggleDarkMode,
                    ),
                  ),
                  onTap: () => _toggleDarkMode(!(_userPreferences?.isDarkMode ?? false)),
                ),
              ),

              Divider(height: isLargeScreen ? 32 : 24),

              // Notifications Toggle (placeholder)
              Semantics(
                label: 'Notification settings. Currently ${_userPreferences?.notificationsEnabled == true ? 'enabled' : 'disabled'}',
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    'Notifications',
                    style: (isLargeScreen 
                        ? textTheme.bodyLarge 
                        : textTheme.bodyMedium)?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Manage notification preferences',
                    style: (isLargeScreen 
                        ? textTheme.bodyMedium 
                        : textTheme.bodySmall)?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Semantics(
                    label: 'Toggle notifications',
                    child: Switch(
                      value: _userPreferences?.notificationsEnabled ?? true,
                      onChanged: (value) {
                        AccessibilityUtils.announceAction(
                          context, 
                          value ? 'Notifications enabled' : 'Notifications disabled'
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notifications ${value ? 'enabled' : 'disabled'}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification settings not implemented yet'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              Divider(height: isLargeScreen ? 32 : 24),

              // Language Setting (placeholder)
              Semantics(
                label: 'Language settings. Currently set to ${_userPreferences?.language ?? 'English'}',
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    'Language',
                    style: (isLargeScreen 
                        ? textTheme.bodyLarge 
                        : textTheme.bodyMedium)?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    _userPreferences?.language ?? 'English',
                    style: (isLargeScreen 
                        ? textTheme.bodyMedium 
                        : textTheme.bodySmall)?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: isLargeScreen ? 20 : 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    AccessibilityUtils.announceAction(context, 'Language settings opened');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language settings not implemented yet'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}