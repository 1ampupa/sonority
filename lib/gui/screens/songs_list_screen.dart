import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:sonority/core/songs/song_player.dart';

import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/gui/widgets/mini_song_player_stack.dart';
import 'package:sonority/gui/widgets/song_list_tile.dart';

import 'package:sonority/gui/widgets/sonority_app_bar.dart';
import 'package:sonority/gui/widgets/loading_column.dart';

class SongsListScreen extends StatefulWidget {
  const SongsListScreen({super.key});

  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  final SongsManager _songsManager = GetIt.instance<SongsManager>();
  final SongPlayer _songPlayer = GetIt.instance<SongPlayer>();
  final MiniSongPlayerStack _miniSongPlayerStack =
      GetIt.instance<MiniSongPlayerStack>();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchLocalSongs();
  }

  Future<void> fetchLocalSongs() async {
    await _songsManager.fetchLocalSongs();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SonorityAppBar(title: "My songs"),
        body: SafeArea(
          child: !_isLoading ? songsListColumn() : LoadingColumn(),
        ),
      ),
    );
  }

  Column songsListColumn() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(5.0),
            physics: const BouncingScrollPhysics(),
            itemCount: _songsManager.songsList.length,
            itemBuilder: (context, index) {
              final song = _songsManager.songsList[index];
              final isCurrentSong =
                  index == _songPlayer.currentIndex && _songPlayer.isPlaying;

              return Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: SongListTile(
                  song: song,
                  isCurrentSong: isCurrentSong,
                  index: index,
                  onTap: () {
                    _songPlayer.play(index);
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
        _miniSongPlayerStack,
      ],
    );
  }
}
