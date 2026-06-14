import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class VolumeSlider extends StatefulWidget {
  final SongPlayer _songPlayer;

  const VolumeSlider({
    super.key,
    required this._songPlayer
  });

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(),
      child: ListenableBuilder(
        listenable: widget._songPlayer,
        builder: (context, child) {
          return Slider(
            value: widget._songPlayer.currentVolume,
            min: 0,
            max: widget._songPlayer.maxVolume,
            onChanged: (newVolume) => {
              setState(() {
                widget._songPlayer.setVolume(newVolume);
              })
            },
          );
        }
      ),
    );
  }
}