import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // Waiting for framework
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowsOptions = const WindowOptions(
    size: Size(1000, 750),
    minimumSize: Size(1000, 750),
    center: true,
    title: 'Sonority'
  );

  windowManager.waitUntilReadyToShow(windowsOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const SonorityApp());
}

class SonorityApp extends StatelessWidget {
  const SonorityApp({super.key});

  // Build an app

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF151515)
      )
    );
  }
}
