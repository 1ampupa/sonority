class DurationFormatter {

  // Format Duration as a readable string
  String formatDuration(Duration currentPosition) {
    String stringMinute, stringSecond;
    int wholePosition = currentPosition.inSeconds;

    int minutes = wholePosition ~/ 60;
    int seconds = wholePosition % 60;

    stringMinute = minutes.toString();

    if (seconds < 10) {
      stringSecond = "0$seconds";
    } else {
      stringSecond = seconds.toString();
    }

    return "$stringMinute:$stringSecond";
  }

}