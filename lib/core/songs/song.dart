import 'package:sonority/utils/logger.dart';

class Song {
  final String title;
  final String artist;
  final int? duration;
  final String path;

  const Song({
    required this.title,
    required this.artist,
    required this.duration,

    required this.path
  });

  String get readableDuration {
    if (duration != null) {
      String stringMinute, stringSecond;
      var minute = ((duration! / 1000) / 60).floor();
      var second = ((duration! / 1000) % 60).floor();

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
}
