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
      child: ListenableBuilder(
        listenable: widget._songPlayer,
        builder: (context, child) {
          return Slider(
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
                widget._songPlayer.seekTo(newValue);
              });
            },
            onChangeEnd: (_) {
              if (_isPlayingBeforeDrag) {
                widget._songPlayer.resume();
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.secondary,
          );
        }
      ),
    );
  }
}
