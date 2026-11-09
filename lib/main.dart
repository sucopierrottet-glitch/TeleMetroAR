import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_strings.dart';
import 'screens/home_navigation_screen.dart';
import 'screens/welcome_landing_screen.dart';
import 'services/sensor_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.configureOfflineFonts();
  runApp(const TeleMetroApp());
}

class TeleMetroApp extends StatefulWidget {
  final SensorService? sensorService;

  const TeleMetroApp({super.key, this.sensorService});

  @override
  State<TeleMetroApp> createState() => _TeleMetroAppState();
}

class _TeleMetroAppState extends State<TeleMetroApp> {
  static const _kLangKey = 'telemetro_lang_code';

  late final SensorService _sensorService;
  String _langCode = 'es';
  bool _enteredApp = false;

  @override
  void initState() {
    super.initState();
    _sensorService = widget.sensorService ?? SensorService();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLangKey);
    if (saved != null && AppStrings.supportedCodes.contains(saved)) {
      if (!mounted) return;
      setState(() {
        _langCode = saved;
      });
    }
  }

  Future<void> _changeLanguage(String code) async {
    if (!AppStrings.supportedCodes.contains(code)) return;
    setState(() {
      _langCode = code;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLangKey, code);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_langCode);

    return MaterialApp(
      title: strings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: Locale(_langCode),
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('pt'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _enteredApp
          ? HomeNavigationScreen(
              strings: strings,
              onSelectLanguage: _changeLanguage,
              sensorService: _sensorService,
            )
          : WelcomeLandingScreen(
              strings: strings,
              onSelectLanguage: _changeLanguage,
              onEnterApp: () {
                setState(() {
                  _enteredApp = true;
                });
              },
            ),
    );
  }
}
