import 'package:sonority/utils/logger.dart';

class Song {
  final String _title;
  final String _artist;
  final int? _durationInMs;
  final String _path;

  const Song({
    required this._title,
    required this._artist,
    required this._durationInMs,

    required this._path
  });

  String get readableDuration {
    if (_durationInMs != null) {
      String stringMinute, stringSecond;
      var minute = ((_durationInMs / 1000) / 60).floor();
      var second = ((_durationInMs / 1000) % 60).floor();

      stringMinute = minute.toString();

      if (second < 10) {
        stringSecond = "0$second";
      } else {
        stringSecond = second.toString();
      }

      return '$stringMinute:$stringSecond';

    } else {
      logger.w("Can't get readable duration.");
      return "--:--";
    }
  }

  String get title => _title;

  String get artist => _artist;

  String get path => _path;

  int? get durationInMs => _durationInMs;
}
