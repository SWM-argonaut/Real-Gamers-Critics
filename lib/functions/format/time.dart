String durationFormat(Duration? duration) {
  String _str = "";

  if (duration == null) {
    return "Nan";
  }

  if (duration.inHours > 0) {
    _str += "${duration.inHours}h ";
  }

  return _str += "${duration.inMinutes.remainder(60)}m";
}
