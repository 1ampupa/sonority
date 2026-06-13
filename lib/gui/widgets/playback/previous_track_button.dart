import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class PreviousTrackButton extends StatelessWidget {
  final SongPlayer _songPlayer;

  const PreviousTrackButton({
    super.key,
    required this._songPlayer
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_previous),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: "Previous",
      onPressed: () {
        _songPlayer.previous();
      },
    );
  }

}