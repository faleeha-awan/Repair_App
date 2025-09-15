// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Guide de Réparation';

  @override
  String get home => 'Accueil';

  @override
  String get search => 'Rechercher';

  @override
  String get myGuides => 'Mes Guides';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profil';

  @override
  String get welcomeMessage =>
      'Nous sommes là pour vous guider étape par étape';

  @override
  String get welcomeDescription =>
      'Trouvez des guides de réparation, téléchargez des manuels et obtenez de l\'aide d\'experts.';

  @override
  String get recentGuides => 'Guides Récents';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get noRecentGuides => 'Aucun guide récent pour le moment';

  @override
  String get startExploring => 'Commencez à explorer pour les voir ici !';

  @override
  String get userInformation => 'Informations Utilisateur';

  @override
  String get signInToAccess => 'Connectez-vous pour accéder à votre profil';

  @override
  String get signIn => 'Se Connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get appSettings => 'Paramètres de l\'App';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get darkThemeEnabled => 'Thème sombre activé';

  @override
  String get lightThemeEnabled => 'Thème clair activé';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Gérer les préférences de notification';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get german => 'Allemand';

  @override
  String get italian => 'Italien';

  @override
  String get portuguese => 'Portugais';

  @override
  String get chinese => 'Chinois';

  @override
  String get japanese => 'Japonais';

  @override
  String get korean => 'Coréen';

  @override
  String get arabic => 'Arabe';

  @override
  String get cancel => 'Annuler';

  @override
  String get select => 'Sélectionner';

  @override
  String languageChanged(String language) {
    return 'Langue changée en $language';
  }
}
