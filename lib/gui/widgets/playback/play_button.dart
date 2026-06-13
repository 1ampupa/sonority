import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class PlayButton extends StatefulWidget {
  final SongPlayer _songPlayer;

  const PlayButton({
    super.key,
    required this._songPlayer
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  // Pause Icon
  Stack pauseIcon(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 22,
        ),
        Icon(
          Icons.pause,
          color: Theme.of(context).colorScheme.secondary,
          size: 32,
        ),
      ],
    );
  }

  // Resume Icon
  Stack resumeIcon(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: 22,
        ),
        Icon(
          Icons.play_arrow,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 32,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget._songPlayer.isPlaying ? pauseIcon(context) : resumeIcon(context),
      padding: EdgeInsets.all(0),
      tooltip: widget._songPlayer.isPlaying ? "Pause" : "Resume",
      onPressed: () {
        widget._songPlayer.togglePauseResume();
        setState(() {});
      },
    );
  }
}