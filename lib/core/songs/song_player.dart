import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sonority/utils/duration_formatter.dart';

import 'package:sonority/utils/logger.dart';

import 'package:sonority/core/songs/songs_manager.dart';
import 'package:sonority/core/songs/song.dart';
import 'package:sonority/core/enums/song_repeat_mode_enums.dart';

class SongPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final SongsManager songsManager;

  final DurationFormatter _durationFormatter = GetIt.instance<DurationFormatter>();

  // State Variables
  bool _isLoaded = false;
  int _currentIndex = 0;

  bool _isPlaying = false;
  double _currentPosition = 0;
  String _readableCurrentPosition = "0:00";
  bool isDraggingSlider = false;
  bool isPlayingBeforeDraggingSlider = false;

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

    // If it's already playing the loaded song then just replay it.
    if (_currentIndex == index && _isLoaded) {
      seekTo(0);
      return;
    }

    _currentIndex = index;
    _currentPosition = 0;

    try {
      Song targetSong = songsManager.songsList[_currentIndex];
      
      await _audioPlayer.setSource(DeviceFileSource(targetSong.path));
      _isLoaded = true;
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
      int targetPosition = currentPosition.inSeconds + (targetDirection * duration);
      seekTo(targetPosition.toDouble());
    }

    notifyListeners();
  }

  void seekTo(double newDurationAsSecond) async {
    if (isDraggingSlider) return;

    Duration targetPosition = Duration(seconds: newDurationAsSecond.toInt());
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
    if (isDraggingSlider) return;

    _currentPosition = currentPosition.inSeconds.toDouble();
    _readableCurrentPosition = _durationFormatter.formatDuration(currentPosition);

    notifyListeners();
  }

  // Getter methods

  bool get isLoaded => _isLoaded;

  bool get isPlaying => _isPlaying;

  bool get isShuffle => _isShuffle;

  SongRepeatMode get repeatMode => _currentSongRepeatMode;

  int get currentIndex => _currentIndex;

  Song get currentSong => songsManager.songsList[_currentIndex];

  double get currentPosition => _currentPosition;

  String get readableCurrentPosition => _readableCurrentPosition;
}
