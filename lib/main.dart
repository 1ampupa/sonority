import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/song_player.dart';
import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/routing/router.dart';

final GetIt locator = GetIt.instance;

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

  // Modules register

  locator.registerSingleton<SongsManager>(SongsManager());
  await locator<SongsManager>().initialiseSongsManager();

  locator.registerSingleton<SongPlayer>(
    SongPlayer(songsManager: locator<SongsManager>()),
  );
  locator<SongPlayer>().setup();

  logger.i("App is ready!");

  runApp(const SonorityApp());
}

class SonorityApp extends StatelessWidget {
  const SonorityApp({super.key});

  // Build an app

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: router,
    );
  }
}
