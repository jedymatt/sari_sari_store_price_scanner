import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sari_scan/pages/home_page.dart';
import 'package:sari_scan/l10n/app_localizations.dart';
import 'package:sari_scan/db.dart';

const _themeModeKey = 'theme_mode';
const _localeKey = 'locale';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Fire-and-forget: cleanup must never delay or crash app launch. The
  // trash tab purges again on open, so a failed pass here loses nothing.
  purgeTrashAtStartup();
  runApp(const MyApp());
}

/// Best-effort trash purge that reports failures instead of throwing.
Future<void> purgeTrashAtStartup() async {
  try {
    await purgeExpiredTrash();
  } catch (e, stack) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: e,
      stack: stack,
      context: ErrorDescription('purging expired trash at startup'),
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Reads the settings and subscribes [context] to them, so callers rebuild
  /// even when the change leaves the resolved theme/locale identical (System
  /// default -> English on an English device).
  static _AppSettingsScope _watch(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AppSettingsScope>()!;

  /// Reaches the settings without subscribing, for use inside callbacks.
  static _AppSettingsScope _read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_AppSettingsScope>()!;

  static void setThemeMode(BuildContext context, ThemeMode mode) {
    _read(context).state._setThemeMode(mode);
  }

  static ThemeMode themeMode(BuildContext context) => _watch(context).themeMode;

  static void setLocale(BuildContext context, Locale? locale) {
    _read(context).state._setLocale(locale);
  }

  static Locale? locale(BuildContext context) => _watch(context).locale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadLocale();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeModeKey);
    if (index != null && mounted) {
      setState(() {
        _themeMode = ThemeMode.values[index];
      });
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null && mounted) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_themeModeKey, mode.index);
    });
  }

  void _setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
    SharedPreferences.getInstance().then((prefs) {
      if (locale != null) {
        prefs.setString(_localeKey, locale.languageCode);
      } else {
        prefs.remove(_localeKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AppSettingsScope(
      themeMode: _themeMode,
      locale: _locale,
      state: this,
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          _CebuanoMaterialLocalizationsDelegate(),
          _CebuanoCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ceb'),
        ],
        locale: _locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF8C42),
            secondary: const Color(0xFFFFA726),
            surface: const Color(0xFFFFFBF5),
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF8C42),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: const HomePage(),
      ),
    );
  }
}

/// Carries the app-level theme mode and locale down the tree.
///
/// This exists so reading the settings creates a real dependency. The previous
/// `findAncestorStateOfType` lookup returned the value without subscribing, so
/// a page could hold a stale copy indefinitely.
class _AppSettingsScope extends InheritedWidget {
  const _AppSettingsScope({
    required this.themeMode,
    required this.locale,
    required this.state,
    required super.child,
  });

  final ThemeMode themeMode;
  final Locale? locale;
  final _MyAppState state;

  @override
  bool updateShouldNotify(_AppSettingsScope old) =>
      themeMode != old.themeMode || locale != old.locale;
}

// Custom delegate to provide English fallback for Material widgets in Cebuano
class _CebuanoMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _CebuanoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ceb';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Use English Material localizations for Cebuano
    return DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(_CebuanoMaterialLocalizationsDelegate old) => false;
}

// Custom delegate to provide English fallback for Cupertino widgets in Cebuano
class _CebuanoCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CebuanoCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ceb';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    // Use English Cupertino localizations for Cebuano
    return DefaultCupertinoLocalizations();
  }

  @override
  bool shouldReload(_CebuanoCupertinoLocalizationsDelegate old) => false;
}
