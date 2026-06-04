import 'package:audioplayers/audioplayers.dart';

import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/songs/song.dart';
import 'package:sonority/core/enums/repeat_mode_enums.dart';

class SongPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final SongsManager songsManager;

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool isShuffle = false;
  RepeatMode currentRepeatMode = RepeatMode.none;

  void setup() {
    _audioPlayer.setVolume(0.15);
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
  }
  
  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
  }

  void toggleShuffle() {
    isShuffle = !isShuffle;
  }

  void toggleRepeatMode() {
    currentRepeatMode = switch (currentRepeatMode) {
      RepeatMode.none => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.none
    };
  }

  bool get isPlaying => _isPlaying;

  int get currentIndex => _currentIndex;

  Song get currentSong => songsManager.songsList[_currentIndex];
}
