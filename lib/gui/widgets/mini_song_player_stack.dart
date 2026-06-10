import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:sonority/core/songs/song_player.dart';
import 'package:sonority/gui/widgets/playback_controller_column.dart';

class MiniSongPlayerStack extends StatefulWidget {

  const MiniSongPlayerStack({
    super.key
  });

  @override
  State<MiniSongPlayerStack> createState() => _MiniSongPlayerStackState();

}

class _MiniSongPlayerStackState extends State<MiniSongPlayerStack> {
  final SongPlayer _songPlayer = GetIt.instance<SongPlayer>();
  final PlaybackControllerColumn _playbackControllerColumn = GetIt.instance<PlaybackControllerColumn>();

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
            child: _playbackControllerColumn,
          ),
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
