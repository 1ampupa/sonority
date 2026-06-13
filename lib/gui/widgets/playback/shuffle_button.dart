import 'package:flutter/material.dart';

import 'package:sonority/core/songs/song_player.dart';

class ShuffleButton extends StatefulWidget{
  final SongPlayer _songPlayer;

  const ShuffleButton({
    super.key,
    required this._songPlayer
  });

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  // Shuffle Icon
  Icon shuffleIcon(BuildContext context) {
    return Icon(
      Icons.shuffle,
      color: widget._songPlayer.isShuffle
          ? Theme.of(
              context,
            ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1)
          : Theme.of(context).colorScheme.secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: shuffleIcon(context),
      iconSize: 25,
      padding: EdgeInsets.all(0),
      tooltip: widget._songPlayer.isShuffle ? "Disable Shuffle" : "Enable Shuffle",
      onPressed: () {
        widget._songPlayer.toggleShuffle();
        setState(() {});
      },
    );
  }
}