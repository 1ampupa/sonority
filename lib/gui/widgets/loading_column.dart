import 'dart:math';

import 'package:flutter/material.dart';

class LoadingColumn extends StatefulWidget {

  const LoadingColumn({
    super.key,
  });

  @override
  State<LoadingColumn> createState() => _LoadingColumnState();
}

class _LoadingColumnState extends State<LoadingColumn> {
  late String randomisedText;

  static const List<String> randomTexts = [
    "Loading...",
    "Gathering information...",
    "Please wait...",
    "Just a moment...",
    "Working on it!",
    "Almost done!",
    "Almost there!",
    "Hang tight!"
  ];

  String _getRandomisedText() => randomTexts[Random().nextInt(randomTexts.length)];

  @override
  void initState() {
    super.initState();
    randomisedText = _getRandomisedText();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            spacing: 20,
            children: [
              CircularProgressIndicator(),
              Text(randomisedText)
            ],
          ),
        ),
      ],
    );
  }
}
