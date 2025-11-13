import 'package:flutter/material.dart';
import 'package:foxterrier_verband/pages/main_screen.dart';

void main() {
  runApp(const FoxTerrierApp());
}

class FoxTerrierApp extends StatefulWidget {
  const FoxTerrierApp({super.key});

  @override
  State<FoxTerrierApp> createState() => _FoxTerrierAppState();
}

class _FoxTerrierAppState extends State<FoxTerrierApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deutscher Foxterrier-Verband e.V.',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2D5016),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2D5016),
          secondary: const Color(0xFF4A7C2C),
          tertiary: const Color(0xFFD4AF37),
          surface: Color(0xFFF6FFF8),
          background: Color(0xFFF6FFF8),
        ),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF4A7C2C),
        scaffoldBackgroundColor: const Color(0xFF0A0E0D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF4A7C2C),
          secondary: const Color(0xFF5D9B3C),
          tertiary: const Color(0xFFD4AF37),
          surface: const Color(0xFF1A1F1E),
          background: const Color(0xFF0A0E0D),
        ),
        fontFamily: 'SF Pro Display',
      ),
      home: MainScreen(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
