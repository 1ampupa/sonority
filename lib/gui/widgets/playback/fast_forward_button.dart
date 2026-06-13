import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class FastForwardButton extends StatelessWidget {
  final SongPlayer _songPlayer;

  const FastForwardButton({
    super.key,
    required this._songPlayer
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.fast_forward),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: "Skip",
      onPressed: () {
        _songPlayer.seek(true, 5);
      },
      onLongPress: () {
        _songPlayer.seek(true, 10);
      },
    );
  }

}