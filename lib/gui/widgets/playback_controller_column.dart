import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:sonority/core/songs/song_player.dart';

class PlaybackControllerColumn extends StatefulWidget {
  const PlaybackControllerColumn({super.key});

  @override
  State<PlaybackControllerColumn> createState() =>
      _PlaybackControllerColumnState();
}

class _PlaybackControllerColumnState extends State<PlaybackControllerColumn> {
  final SongPlayer _songPlayer = GetIt.instance<SongPlayer>();

  bool useMinimalLayout = false;

  bool showSeekButtons = false;
  bool showShuffleAndRepeatButtons = true;

  @override
  void initState() {
    super.initState();
  }

  // Shuffle Button
  IconButton shuffleButton() {
    return IconButton(
      icon: Icon(Icons.shuffle),
      iconSize: 20,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.toggleShuffle();
        setState(() {});
      },
    );
  }

  // Previous Track Button
  IconButton previousTrackButton() {
    return IconButton(
      icon: Icon(Icons.skip_previous),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.previous();
        setState(() {});
      },
    );
  }

  // Rewind Button
  IconButton rewindButton() {
    return IconButton(
      icon: Icon(Icons.fast_rewind),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.seek(false, 5);
        setState(() {});
      },
      onLongPress: () {
        _songPlayer.seek(false, 10);
        setState(() {});
      },
    );
  }

  // Pause Icon
  Stack pauseIcon() {
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
  Stack resumeIcon() {
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

  // Pause Resume Button
  IconButton playButton() {
    return IconButton(
      icon: _songPlayer.isPlaying ? pauseIcon() : resumeIcon(),
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.togglePauseResume();
        setState(() {});
      },
    );
  }

  // Fast Forward Button
  IconButton fastForwardButton() {
    return IconButton(
      icon: Icon(Icons.fast_forward),
      iconSize: 30,
      padding: EdgeInsets.all(0),
      color: Theme.of(context).colorScheme.secondary,
      onPressed: () {
        _songPlayer.seek(true, 5);
        setState(() {});
      },
      onLongPress: () {
        _songPlayer.seek(true, 10);
        setState(() {});
      },
    );
  }

  // Next Track Button
  IconButton nextTrackButton() {
    return IconButton(
      icon: Icon(Icons.skip_next),
      iconSize: 30,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.next();
        setState(() {});
      },
    );
  }

  // Repeat Mode Button
  IconButton repeatModeButton() {
    return IconButton(
      icon: Icon(Icons.repeat),
      iconSize: 20,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      onPressed: () {
        _songPlayer.toggleRepeatMode();
        setState(() {});
      },
    );
  }

  // Playback Slider
  SliderTheme playbackSlider() {
    return SliderTheme(
      data: SliderThemeData(),
      child: Slider(
        value: _songPlayer.currentPosition.clamp(
          0,
          _songPlayer.currentSong.duration,
        ),
        min: 0.0,
        max: _songPlayer.currentSong.duration,
        onChangeStart: (_) {
          setState(() {
            _songPlayer.isPlayingBeforeDraggingSlider = _songPlayer.isPlaying;
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
          _songPlayer.isPlayingBeforeDraggingSlider
              ? _songPlayer.resume()
              : _songPlayer.pause();
        },
        activeColor: Theme.of(context).colorScheme.primary,
        thumbColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Column songInfoColumn(BuildContext context) {
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          _songPlayer.currentSong.artist,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onTertiary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Column playbackController(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 7,
          children: [
            Visibility(
              visible: showShuffleAndRepeatButtons,
              child: shuffleButton(),
            ),
            previousTrackButton(),
            Visibility(visible: showSeekButtons, child: rewindButton()),
            playButton(),
            Visibility(visible: showSeekButtons, child: fastForwardButton()),
            nextTrackButton(),
            Visibility(
              visible: showShuffleAndRepeatButtons,
              child: repeatModeButton(),
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _songPlayer.readableCurrentPosition,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: playbackSlider(),
                ),
              ),
              Text(
                _songPlayer.currentSong.readableDuration,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column additionalControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {},
          onLongPress: () => _songPlayer.stop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _songPlayer,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              Expanded(flex: 1, child: songInfoColumn(context)),
              Expanded(flex: 2, child: playbackController(context)),
              Expanded(flex: 1, child: additionalControls(context)),
            ],
          ),
        );
      },
    );
  }
}
