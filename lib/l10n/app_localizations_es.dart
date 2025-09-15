// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Guía de Reparación';

  @override
  String get home => 'Inicio';

  @override
  String get search => 'Buscar';

  @override
  String get myGuides => 'Mis Guías';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Perfil';

  @override
  String get welcomeMessage => 'Estamos aquí para guiarte paso a paso';

  @override
  String get welcomeDescription =>
      'Encuentra guías de reparación, sube manuales y obtén ayuda experta.';

  @override
  String get recentGuides => 'Guías Recientes';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get noRecentGuides => 'Aún no hay guías recientes';

  @override
  String get startExploring => '¡Comienza a explorar para verlas aquí!';

  @override
  String get userInformation => 'Información del Usuario';

  @override
  String get signInToAccess => 'Inicia sesión para acceder a tu perfil';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get appSettings => 'Configuración de la App';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkThemeEnabled => 'Tema oscuro activado';

  @override
  String get lightThemeEnabled => 'Tema claro activado';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get manageNotifications => 'Gestionar preferencias de notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get german => 'Alemán';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugués';

  @override
  String get chinese => 'Chino';

  @override
  String get japanese => 'Japonés';

  @override
  String get korean => 'Coreano';

  @override
  String get arabic => 'Árabe';

  @override
  String get cancel => 'Cancelar';

  @override
  String get select => 'Seleccionar';

  @override
  String languageChanged(String language) {
    return 'Idioma cambiado a $language';
  }
}
