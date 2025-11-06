import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anylife/utils/theme_manager.dart';
import 'package:anylife/utils/measurement_manager.dart';
import 'screens/charselect_screen.dart';
import 'app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => MeasurementManager()),
      ],
      child: const AnylifeApp(),
    ),
  );
}

class AnylifeApp extends StatelessWidget {
  const AnylifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      title: 'Anylife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      home: const CharSelectScreen(),
    );
  }
}
