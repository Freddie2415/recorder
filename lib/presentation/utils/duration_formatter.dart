class DurationFormatter {
  static String format(Duration d) {
    var seconds = d.inSeconds;
    var milliseconds = (d.inMilliseconds % 100).toString().padLeft(2, '0');

    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }

    if (tokens.isNotEmpty || seconds != 0) {
      tokens.add('${seconds}s');
    }

    tokens.add('${milliseconds}ms');

    return tokens.join(' ');
  }
}
