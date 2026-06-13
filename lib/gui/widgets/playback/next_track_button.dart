import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class NextTrackButton extends StatelessWidget {
  final SongPlayer _songPlayer;

  const NextTrackButton({
    super.key,
    required this._songPlayer
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_next),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: "Next",
      onPressed: () {
        _songPlayer.next();
      },
    );
  }

}