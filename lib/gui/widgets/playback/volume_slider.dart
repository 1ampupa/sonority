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
      child: Slider(
        value: widget._songPlayer.currentVolume,
        min: 0,
        max: 0.75,
        onChanged: (newVolume) => {
          setState(() {
            widget._songPlayer.setVolume(newVolume);
          })
        },
      ),
    );
  }
}