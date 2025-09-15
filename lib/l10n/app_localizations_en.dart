// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Repair Guide';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get myGuides => 'My Guides';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get welcomeMessage => 'We\'re here to guide you step by step';

  @override
  String get welcomeDescription =>
      'Find repair guides, upload manuals, and get expert help.';

  @override
  String get recentGuides => 'Recent Guides';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentGuides => 'No recent guides yet';

  @override
  String get startExploring => 'Start exploring to see them here!';

  @override
  String get userInformation => 'User Information';

  @override
  String get signInToAccess => 'Sign in to access your profile';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get appSettings => 'App Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkThemeEnabled => 'Dark theme enabled';

  @override
  String get lightThemeEnabled => 'Light theme enabled';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage notification preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get german => 'German';

  @override
  String get italian => 'Italian';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get korean => 'Korean';

  @override
  String get arabic => 'Arabic';

  @override
  String get cancel => 'Cancel';

  @override
  String get select => 'Select';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }
}
