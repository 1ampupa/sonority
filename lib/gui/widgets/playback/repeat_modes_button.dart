import 'package:flutter/material.dart';
import 'package:sonority/core/enums/song_loop_mode_enums.dart';
import 'package:sonority/core/songs/song_player.dart';

class RepeatModesButton extends StatefulWidget {
  final SongPlayer _songPlayer;

  const RepeatModesButton({
    super.key,
    required this._songPlayer
  });

  @override
  State<RepeatModesButton> createState() => _RepeatModesButtonState();
}

class _RepeatModesButtonState extends State<RepeatModesButton> {
  // Repeat Mode Icon
  Icon repeatModesIcon(BuildContext context) {
    return switch (widget._songPlayer.repeatMode) {
      SongLoopMode.none => Icon(
        Icons.repeat,
        color: Theme.of(context).colorScheme.secondary,
      ),
      SongLoopMode.all => Icon(
        Icons.repeat,
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1),
      ),
      SongLoopMode.one => Icon(
        Icons.repeat_one,
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1),
      ),
    };
  }

  // Repeat Modes Tooltip
  String getRepeatModesTooltip() {
    return switch (widget._songPlayer.repeatMode) {
      SongLoopMode.none => "Enable Repeat",
      SongLoopMode.all => "Enable Repeat One",
      SongLoopMode.one => "Disable Repeat",
    };
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: repeatModesIcon(context),
      iconSize: 25,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: getRepeatModesTooltip(),
      onPressed: () {
        widget._songPlayer.toggleRepeatMode();
        setState(() {});
      },
    );
  }
}