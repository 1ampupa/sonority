import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

class PlaybackSlider extends StatefulWidget {
  final SongPlayer _songPlayer;

  const PlaybackSlider({super.key, required this._songPlayer});

  @override
  State<PlaybackSlider> createState() => _PlaybackSliderState();
}

class _PlaybackSliderState extends State<PlaybackSlider> {
  bool _isPlayingBeforeDrag = false;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          pressedElevation: 12,
        ),
      ),
      child: Slider(
        value: widget._songPlayer.currentPosition.clamp(
          0,
          widget._songPlayer.currentSong.duration,
        ),
        min: 0.0,
        max: widget._songPlayer.currentSong.duration,
        onChangeStart: (_) {
          _isPlayingBeforeDrag = widget._songPlayer.isPlaying;
          if (widget._songPlayer.isPlaying) widget._songPlayer.pause();
        },
        onChanged: (newValue) {
          setState(() {
            widget._songPlayer.updatePosition(Duration(seconds: newValue.toInt()));
          });
        },
        onChangeEnd: (finalValue) {
          widget._songPlayer.seekTo(finalValue);
          if (_isPlayingBeforeDrag) {
            widget._songPlayer.resume();
          }
          setState(() {});
        },
        activeColor: Theme.of(context).colorScheme.primary,
        thumbColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
