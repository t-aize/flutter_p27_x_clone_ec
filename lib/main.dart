import 'package:flutter/material.dart';
import 'package:x_clone_ec/pages/login_page.dart';
import 'package:x_clone_ec/app_settings.dart';
import 'package:x_clone_ec/persistence/settings_persistence.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _persistence = SettingsPersistence();
  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadBackgroundColor();
  }

  Future<void> _loadBackgroundColor() async {
    try {
      final color = await _persistence.loadBackgroundColor();
      if (mounted) setState(() => _backgroundColor = Color(color));
    } catch (error) {
      debugPrint('Chargement de la couleur impossible : $error');
    }
  }

  Future<void> _changeBackgroundColor(Color color) async {
    await _persistence.saveBackgroundColor(color.toARGB32());
    if (mounted) setState(() => _backgroundColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
      backgroundColor: _backgroundColor,
      changeBackgroundColor: _changeBackgroundColor,
      child: MaterialApp(
        title: 'Clone X',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          ),
          scaffoldBackgroundColor: _backgroundColor,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.grey,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
