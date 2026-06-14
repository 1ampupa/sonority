import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:sonority/core/songs/song_player.dart';

import 'package:sonority/gui/widgets/playback/fast_forward_button.dart';
import 'package:sonority/gui/widgets/playback/next_track_button.dart';
import 'package:sonority/gui/widgets/playback/play_button.dart';
import 'package:sonority/gui/widgets/playback/playback_slider.dart';
import 'package:sonority/gui/widgets/playback/previous_track_button.dart';
import 'package:sonority/gui/widgets/playback/repeat_modes_button.dart';
import 'package:sonority/gui/widgets/playback/rewind_button.dart';
import 'package:sonority/gui/widgets/playback/shuffle_button.dart';
import 'package:sonority/gui/widgets/playback/volume_button.dart';
import 'package:sonority/gui/widgets/playback/volume_slider.dart';

class PlaybackPanelColumn extends StatefulWidget {
  const PlaybackPanelColumn({super.key});

  @override
  State<PlaybackPanelColumn> createState() => _PlaybackPanelColumnState();
}

class _PlaybackPanelColumnState extends State<PlaybackPanelColumn> {
  final SongPlayer _songPlayer = GetIt.instance<SongPlayer>();

  // Widgets

  late final PlayButton _playButton = PlayButton(songPlayer: _songPlayer);

  late final RewindButton _rewindButton = RewindButton(songPlayer: _songPlayer);
  late final FastForwardButton _fastForwardButton = FastForwardButton(songPlayer: _songPlayer);

  late final PreviousTrackButton _previousTrackButton = PreviousTrackButton(songPlayer: _songPlayer);
  late final NextTrackButton _nextTrackButton = NextTrackButton(songPlayer: _songPlayer);

  late final ShuffleButton _shuffleButton = ShuffleButton(songPlayer: _songPlayer);
  late final RepeatModesButton _repeatModesButton = RepeatModesButton(songPlayer: _songPlayer);

  late final PlaybackSlider _playbackSlider = PlaybackSlider(songPlayer: _songPlayer);

  late final VolumeButton _volumeButton = VolumeButton(songPlayer: _songPlayer);
  late final VolumeSlider _volumeSlider = VolumeSlider(songPlayer: _songPlayer);

  // Settings

  bool useMinimalLayout =
      false; // False = Set all layout-related settings to false

  // Layout-related settings
  bool showSeekButtons = false;
  bool showShuffleAndRepeatButtons = true;

  bool showVolumeSlider = true;

  @override
  void initState() {
    super.initState();
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
              child: _shuffleButton,
            ),
            _previousTrackButton,
            Visibility(visible: showSeekButtons, child: _rewindButton),
            _playButton,
            Visibility(visible: showSeekButtons, child: _fastForwardButton),
            _nextTrackButton,
            Visibility(
              visible: showShuffleAndRepeatButtons,
              child: _repeatModesButton,
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
                  child: _playbackSlider,
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
        if (showVolumeSlider) ...[
          _volumeButton,
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 60,
                maxWidth: 180,
              ),
              child: _volumeSlider,
            ),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.clear),
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
