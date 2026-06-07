import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

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
            constraints: BoxConstraints(minWidth: 100, minHeight: 75, maxHeight: 75),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _songPlayer.currentSong.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onTertiary,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Text(
                          _songPlayer.currentSong.artist,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.75),
                            overflow: TextOverflow.ellipsis
                          ),
                        )
                      ],
                    ),
                  )
                ]
              ),
            ),
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
          visible: _songPlayer.isPlaying,
          child: miniSongPlayerStack()
        );
      })
    );
  }
}
