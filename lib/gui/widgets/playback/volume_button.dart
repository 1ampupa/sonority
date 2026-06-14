import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class VolumeButton extends StatefulWidget {
  final SongPlayer _songPlayer;

  const VolumeButton({
    super.key,
    required this._songPlayer
  });

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  Icon getVolumeIcon() {
    if (widget._songPlayer.currentVolume <= 0) {
      return Icon(Icons.volume_off);
    } else if (widget._songPlayer.currentVolume <= widget._songPlayer.maxVolume/2) {
      return Icon(Icons.volume_down);
    }
    return Icon(Icons.volume_up);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._songPlayer,
      builder: (context, child) {
        return IconButton(
          icon: getVolumeIcon(),
          iconSize: 25,
          padding: EdgeInsets.all(0),
          tooltip: widget._songPlayer.isMuted ? "Unmute" : "Mute",
          onPressed: () {
            widget._songPlayer.toggleMute();
            setState(() {});
          },
        );
      }
    );
  }
}
