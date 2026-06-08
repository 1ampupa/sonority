import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/songs/song.dart';
import 'package:sonority/core/enums/song_repeat_mode_enums.dart';

class SongPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final SongsManager songsManager;

  bool _isLoaded = false;
  int _currentIndex = 0;

  bool _isPlaying = false;
  double _currentPosition = 0;
  String _readableCurrentPosition = "0:00";
  bool isDraggingSlider = false;

  bool _isShuffle = false;
  SongRepeatMode _currentSongRepeatMode = SongRepeatMode.none;

  Future<void> setup() async {
    await _audioPlayer.setVolume(0.15);

    _upateRepeatMode();

    _audioPlayer.onPlayerComplete.listen((_) => onSongComplete());
    _audioPlayer.onPositionChanged.listen((position) => updatePosition(position));
  }

  SongPlayer({required this.songsManager});

  // Playback controller

  Future<void> play(int index) async {
    if (songsManager.songsList.isEmpty) return;
    _currentIndex = index;
    _currentPosition = 0;

    Song targetSong = songsManager.songsList[_currentIndex];

    try {
      await _audioPlayer.setSource(DeviceFileSource(targetSong.path));
      _isLoaded = true;
      _audioPlayer.seek(Duration(seconds: 0));
      _audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      logger.e("Failed to play a song: $e");
    }
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void togglePauseResume() {
    _isPlaying ? pause() : resume();
  }

  void seek(bool direction, int duration) async {
    Duration? currentPosition = await _audioPlayer.getCurrentPosition();
    int targetDirection = direction ? 1 : -1;

    if (currentPosition != null) {
      Duration targetPosition = currentPosition + Duration(seconds: targetDirection * duration);
      await _audioPlayer.seek(targetPosition);
    }

    notifyListeners();
  }

  void seekTo(double newDuration) async {
    if (isDraggingSlider) return;

    Duration targetPosition = Duration(seconds: newDuration.toInt());
    await _audioPlayer.seek(targetPosition);

    notifyListeners();
  }

  void next() {
    if (_currentIndex < songsManager.songsList.length - 1) {
      play(_currentIndex + 1);
    } else {
      play(0);
    }

    notifyListeners();
  }

  void previous() {
    if (_currentIndex > 0) {
      play(_currentIndex - 1);
    } else {
      play(songsManager.songsList.length - 1); // Play the last song in the list
    }

    notifyListeners();
  }
 
  void stop() {
    _audioPlayer.release();
    _isPlaying = false;
    _isLoaded = false;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeatMode() {
    _currentSongRepeatMode = switch (_currentSongRepeatMode) {
      SongRepeatMode.none => SongRepeatMode.all,
      SongRepeatMode.all => SongRepeatMode.one,
      SongRepeatMode.one => SongRepeatMode.none
    };
    _upateRepeatMode();
    notifyListeners();
  }

  void _upateRepeatMode() async {
    final releaseMode = switch (_currentSongRepeatMode) {
      SongRepeatMode.one => ReleaseMode.loop,
      _ => ReleaseMode.stop
    };

    await _audioPlayer.setReleaseMode(releaseMode);
  }

  void onSongComplete() {
    next();
  }

  void updatePosition(Duration currentPosition) async {
    if (isDraggingSlider) {
      return;
    }

    String stringMinute, stringSecond;
    int wholePosition = currentPosition.inSeconds;

    _currentPosition = wholePosition.toDouble();

    int minutes = wholePosition ~/ 60;
    int seconds = wholePosition % 60;

    stringMinute = minutes.toString();

    if (seconds < 10) {
      stringSecond = "0$seconds";
    } else {
      stringSecond = seconds.toString();
    }

    _readableCurrentPosition = "$stringMinute:$stringSecond";

    notifyListeners();
  }

  bool get isLoaded => _isLoaded;

  bool get isPlaying => _isPlaying;

  bool get isShuffle => _isShuffle;

  SongRepeatMode get repeatMode => _currentSongRepeatMode;

  int get currentIndex => _currentIndex;

  Song get currentSong => songsManager.songsList[_currentIndex];

  double get currentPosition => _currentPosition;

  String get readableCurrentPosition => _readableCurrentPosition;
}
