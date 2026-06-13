import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class RewindButton extends StatelessWidget {
  final SongPlayer _songPlayer;

  const RewindButton({
    super.key,
    required this._songPlayer
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.fast_rewind),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: "Rewind",
      onPressed: () {
        _songPlayer.seek(false, 5);
      },
      onLongPress: () {
        _songPlayer.seek(false, 10);
      },
    );
  }

}