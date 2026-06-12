import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

import 'package:sonority/utils/duration_formatter.dart';
import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/song_player.dart';
import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/routing/router.dart';

import 'package:sonority/gui/widgets/mini_song_player_stack.dart';
import 'package:sonority/gui/widgets/playback_controller_column.dart';

final GetIt locator = GetIt.instance;

void main() async {
  // Waiting for framework
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowsOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(800, 600),
      center: true,
      title: 'Sonority',
    );

    windowManager.waitUntilReadyToShow(windowsOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Modules register

  // DurationFormatter
  locator.registerSingleton<DurationFormatter>(DurationFormatter());

  // SongsManager
  locator.registerSingleton<SongsManager>(SongsManager());  
  await locator<SongsManager>().initialiseSongsManager();

  // SongPlayer
  locator.registerSingleton<SongPlayer>(SongPlayer(songsManager: locator<SongsManager>()));
  await locator<SongPlayer>().setup();

  // PlaybackControllerColumn
  locator.registerSingleton<PlaybackControllerColumn>(PlaybackControllerColumn());

  // MiniSongPlayerStack
  locator.registerSingleton<MiniSongPlayerStack>(MiniSongPlayerStack());

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
          onPrimary: Color(0xFFDBE7FF),
          secondary: Color(0xFFDBE7FF),
          secondaryContainer: Color(0xFFDBE7FF),
          onSecondary: Color(0xFF151515),
          tertiary: Color(0xFF202020),
          tertiaryContainer: Color(0xFF202020),
          onTertiary: Color(0xFFDBE7FF),
          onTertiaryContainer: Color(0xFFDBE7FF),
        ),

        tooltipTheme: const TooltipThemeData(
          preferBelow: false,
          waitDuration: Duration(milliseconds: 500),
        )
      ),
      routerConfig: router,
    );
  }
}
