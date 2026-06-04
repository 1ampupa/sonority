import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:sonority/utils/logger.dart';
import 'package:sonority/core/songs/song.dart';

class SongsManager {
  List<Song> songsList = [];

  Directory? _appSongsDir;

  Future<void> initialiseSongsManager() async {
    try {
      // Get path of local app data (AppData)
      final Directory localDir = await getApplicationSupportDirectory();
      logger.i(localDir.path);

      // Create a SonorityMusic folder and local songs folder inside AppData
      _appSongsDir = Directory('${localDir.path}/Sonority/songs');

      if (!await _appSongsDir!.exists()) {
        await _appSongsDir!.create(recursive: true);
        logger.i(
          "Created SonorityMusic folder inside user's AppData at ${_appSongsDir!.path}",
        );
      }

      // Fetch Songs from the local AppData
      await fetchLocalSongs();
    } catch (e) {
      logger.f("Failed to initialise Songs Manager: $e");
    }
  }

  Future<void> fetchLocalSongs() async {
    if (_appSongsDir == null) return;

    try {
      songsList.clear();

      // Fetch all files
      final List<FileSystemEntity> files = _appSongsDir!.listSync();

      for (var file in files) {
        // Check if object is a file and ends with audio extension
        if (file is File &&
            (file.path.endsWith('.mp3') || file.path.endsWith('.wav'))) {
          // Get song metadata
          final metadata = await MetadataRetriever.fromFile(File(file.path));
          String? trackName = metadata.trackName;

          String songTitle = (trackName == null || trackName.trim().isEmpty)
                              ? p.basenameWithoutExtension(file.path)
                              : trackName;
          String songArtist = (metadata.trackArtistNames == null || metadata.trackArtistNames!.isEmpty || metadata.trackArtistNames!.join().trim().isEmpty)
                              ? "Local files"
                              : metadata.trackArtistNames!.join(', ');
          int? songDuration = metadata.trackDuration;

          songsList.add(Song(
            path: file.path,
            title: songTitle,
            artist: songArtist,
            duration: songDuration
          ));
        }
      }

      logger.i("Fetched ${songsList.length} songs");
    } catch (e) {
      logger.e("Failed to fetch songs: $e");
    }
  }
}
