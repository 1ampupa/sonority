import 'package:sonority/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'gui/screens/home_screen.dart';

void main() async {
  // Waiting for framework
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowsOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(800, 600),
    center: true,
    title: 'Sonority',
  );

  windowManager.waitUntilReadyToShow(windowsOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  logger.i("App is ready!");

  runApp(const SonorityApp());
}

class SonorityApp extends StatelessWidget {
  const SonorityApp({super.key});

  // Build an app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sonority",

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        fontFamily: 'IBM Plex Sans Thai',

        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF151515),
          primary: Color(0xFF7555FF),
          primaryContainer: Color(0xFF7555FF),
          secondary: Color(0xFFDFE7F8),
          onPrimary: Color(0xFFDFE7F8),
          onSecondary: Color(0xFF151515),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
