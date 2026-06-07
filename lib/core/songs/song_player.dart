import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/songs/song.dart';
import 'package:sonority/core/enums/song_repeat_mode_enums.dart';

class SongPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final SongsManager songsManager;

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool isShuffle = false;
  SongRepeatMode currentSongRepeatMode = SongRepeatMode.none;

  Future<void> setup() async {
    await _audioPlayer.setVolume(0.15);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  SongPlayer({required this.songsManager});

  // Playback controller

  Future<void> play(int index) async {
    if (songsManager.songsList.isEmpty) return;
    _currentIndex = index;

    Song targetSong = songsManager.songsList[_currentIndex];

    try {
      await _audioPlayer.play(DeviceFileSource(targetSong.path));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      logger.e("Failed to play a song: $e");
    }
  }

  void next() {
    if (_currentIndex < songsManager.songsList.length - 1) {
      play(_currentIndex + 1);
    } else {
      play(0);
    }
  }

  void previous() {
    if (_currentIndex > 0) {
      play(_currentIndex - 1);
    } else {
      play(songsManager.songsList.length - 1); // Play the last song in the list
    }
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }
  
  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void toggleShuffle() {
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void toggleRepeatMode() {
    currentSongRepeatMode = switch (currentSongRepeatMode) {
      SongRepeatMode.none => SongRepeatMode.all,
      SongRepeatMode.all => SongRepeatMode.one,
      SongRepeatMode.one => SongRepeatMode.none
    };
    notifyListeners();
  }

  bool get isPlaying => _isPlaying;

  int get currentIndex => _currentIndex;

  Song get currentSong => songsManager.songsList[_currentIndex];
}
