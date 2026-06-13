import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sonority/core/enums/song_repeat_mode_enums.dart';

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

  bool showVolumeSlider = true;

  @override
  void initState() {
    super.initState();
  }

  // Shuffle Icon
  Icon shuffleIcon() {
    return Icon(
      Icons.shuffle,
      color: _songPlayer.isShuffle
          ? Theme.of(
              context,
            ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1)
          : Theme.of(context).colorScheme.secondary,
    );
  }

  // Shuffle Button
  IconButton shuffleButton() {
    return IconButton(
      icon: shuffleIcon(),
      iconSize: 25,
      padding: EdgeInsets.all(0),
      tooltip: _songPlayer.isShuffle ? "Disable Shuffle" : "Enable Shuffle",
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
      tooltip: "Previous",
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
      tooltip: "Rewind",
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
      tooltip: _songPlayer.isPlaying ? "Pause" : "Resume",
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
      tooltip: "Skip",
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
      tooltip: "Next",
      onPressed: () {
        _songPlayer.next();
        setState(() {});
      },
    );
  }

  // Repeat Mode Icon
  Icon repeatModesIcon() {
    return switch (_songPlayer.repeatMode) {
      SongRepeatMode.none => Icon(
        Icons.repeat,
        color: Theme.of(context).colorScheme.secondary,
      ),
      SongRepeatMode.all => Icon(
        Icons.repeat,
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1),
      ),
      SongRepeatMode.one => Icon(
        Icons.repeat_one,
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(red: .50, green: .45, blue: 1),
      ),
    };
  }

  // Repeat Modes Tooltip
  String getRepeatModesTooltip() {
    return switch (_songPlayer.repeatMode) {
      SongRepeatMode.none => "Enable Repeat",
      SongRepeatMode.all => "Enable Repeat One",
      SongRepeatMode.one => "Disable Repeat",
    };
  }

  // Repeat Mode Button
  IconButton repeatModesButton() {
    return IconButton(
      icon: repeatModesIcon(),
      iconSize: 25,
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(0),
      tooltip: getRepeatModesTooltip(),
      onPressed: () {
        _songPlayer.toggleRepeatMode();
        setState(() {});
      },
    );
  }

  // Playback Slider
  SliderTheme playbackSlider() {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          pressedElevation: 12,
        ),
      ),
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

  // Volume Slider
  SliderTheme volumeSlider() {
    return SliderTheme(
      data: SliderThemeData(),
      child: Slider(
        value: _songPlayer.currentVolume,
        min: 0,
        max: 0.75,
        onChanged: (newVolume) => {
          setState(() {
            _songPlayer.setVolume(newVolume);
          })
        },
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
              child: repeatModesButton(),
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

  Row additionalControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: showVolumeSlider,
          child: Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: volumeSlider(),
            ),
          ),
        ),
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
