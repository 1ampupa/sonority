import 'package:get_it/get_it.dart';
import 'package:sonority/utils/duration_formatter.dart';

final DurationFormatter _durationFormatter = GetIt.instance<DurationFormatter>();

class Song {
  final String _title;
  final String _artist;
  final double? _durationInMs;
  final String _path;

  const Song({
    required this._title,
    required this._artist,
    required this._durationInMs,

    required this._path
  });

  // Getter Methods

  String get readableDuration {
    return _durationFormatter.formatDuration(Duration(seconds: duration.toInt()));
  }

  String get title => _title;

  String get artist => _artist;

  String get path => _path;

  double get durationInMs => _durationInMs ?? 0.0;

  double get duration => (_durationInMs ?? 0.0) / 1000;
}
