import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';
import 'package:sonority/utils/logger.dart';

class MiniSongPlayerStack extends StatefulWidget {

  const MiniSongPlayerStack({
    super.key
  });

  @override
  State<MiniSongPlayerStack> createState() => _MiniSongPlayerStackState();

}

class _MiniSongPlayerStackState extends State<MiniSongPlayerStack> {
  final SongPlayer _songPlayer = GetIt.instance<SongPlayer>();

  @override
  void initState() {
    super.initState();
  }

  Stack miniSongPlayerStack() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            constraints: BoxConstraints(minWidth: 100, minHeight: 90, maxHeight: 90),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 1,
                    child: _songInfoContainer(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _playbackController(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _additionalControls(),
                  )
                ]
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _songInfoContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _songPlayer.currentSong.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onTertiary,
            overflow: TextOverflow.ellipsis
          ),
        ),
        Text(
          _songPlayer.currentSong.artist,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onTertiary,
            overflow: TextOverflow.ellipsis
          )
        )
      ],
    );
  }
  
  Column _playbackController() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 7,
          children: [
            IconButton(
              icon: Icon(Icons.shuffle),
              iconSize: 20,
              onPressed: () {
                _songPlayer.toggleShuffle();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_previous),
              iconSize: 30,
              onPressed: () {
                _songPlayer.previous();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_rewind),
              iconSize: 30,
              onPressed: () {
                _songPlayer.seek(false, 5);
                setState(() {});
              },
              onLongPress: () {
                _songPlayer.seek(false, 10);
                setState(() {});
              }
            ),
            IconButton(
              icon: _songPlayer.isPlaying
                    ? Icon(Icons.pause_circle_filled, color:Theme.of(context).colorScheme.primary,)
                    : Icon(Icons.play_circle_fill),
              iconSize: 50,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _songPlayer.togglePauseResume();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              iconSize: 30,
              onPressed: () {
                _songPlayer.seek(true, 5);
                setState(() {});
              },
              onLongPress: () {
                _songPlayer.seek(true, 10);
                setState(() {});
              }
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              iconSize: 30,
              onPressed: () {
                _songPlayer.next();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.repeat),
              iconSize: 20,
              onPressed: () {
                _songPlayer.toggleRepeatMode();
                setState(() {});
              },
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_songPlayer.readableCurrentPosition),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Slider(
                    value: _songPlayer.currentPosition.clamp(0, _songPlayer.currentSong.duration),
                    min: 0.0,
                    max: _songPlayer.currentSong.duration,
                    onChangeStart: (_) {
                      setState(() {
                        _songPlayer.isDraggingSlider = true;
                      });
                      _songPlayer.pause();
                    },
                    onChanged: (newValue) {
                      setState(() {
                        _songPlayer.isDraggingSlider = false;
                        _songPlayer.seekTo(newValue);
                      });
                    },
                    onChangeEnd: (_) {
                      setState(() {
                        _songPlayer.isDraggingSlider = false;
                      });
                      _songPlayer.resume();
                    },
                  ),
                ),
              ),
              Text(_songPlayer.currentSong.readableDuration),
            ],
          ),
        )
      ],
    );
  }

  Column _additionalControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => logger.i("Press longer to stop"),
          onLongPress: () => _songPlayer.stop()
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _songPlayer,
      builder: ((context, child) {
        return Visibility(
          visible: _songPlayer.isLoaded,
          child: miniSongPlayerStack()
        );
      })
    );
  }
}
