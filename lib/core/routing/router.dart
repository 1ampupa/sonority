import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';

import 'package:sonority/gui/screens/home_screen.dart';
import 'package:sonority/gui/screens/songs_list_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'mysongs',
          builder: (BuildContext context, GoRouterState state) {
            return const SongsListScreen();
          },
        ),
      ],
    ),
  ],
);
