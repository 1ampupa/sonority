import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sonority/gui/widgets/menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _greetingQuote;

  static const List<String> greetingsQuotes = [
    "Hi there.",
    "Hello there.",
    "Hey there!",
    "Howdy!",
    "What's up!",
    "Ready to dive in?",
    "Your personal sonic escape.",
    "Your playlist is waiting...",
    "Reset your vibe.",
    "Lost in the sound.",
    "Vibe on"
  ];

  @override
  void initState() {
    super.initState();
    _greetingQuote = _getGreetingsQuote();
  }

  String _getGreetingsQuote() => greetingsQuotes[Random().nextInt(greetingsQuotes.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.directional(start: 40, end: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(_greetingQuote, style: TextStyle(fontSize: 20)),
                  Text(
                    "SONORITY",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: "Anton",
                      fontSize: 90,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 32,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuButton(
                    icon: Icons.music_note,
                    label: "My songs",
                    color: Theme.of(context).colorScheme.primary,
                    boolText: true,
                    onPressed: () => context.go('/mysongs'),
                  ),
                  MenuButton(
                    icon: Icons.settings,
                    label: "Settings",
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () => context.go('/settings')
                  ),
                  MenuButton(
                    icon: Icons.info,
                    label: "Credits",
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () => context.go('/credits')
                  ),
                ],
              ),
              Divider(height: 32, color: Colors.transparent),
              Center(child: Text("2026 Sonority, created by 1ampupa.")),
            ],
          ),
        ),
      ),
    );
  }
}
