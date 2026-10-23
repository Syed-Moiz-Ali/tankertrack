/// Minimal structured log with a breadcrumb ring (no external deps in P0).
enum LogLevel { debug, info, warn, error }

class LogEntry {
  LogEntry(this.level, this.message, this.time);
  final LogLevel level;
  final String message;
  final DateTime time;
}

class AppLog {
  static final List<LogEntry> _ring = [];
  static const int capacity = 200;

  static List<LogEntry> get breadcrumbs => List.unmodifiable(_ring);

  static void _add(LogLevel level, String message) {
    _ring.add(LogEntry(level, message, DateTime.now().toUtc()));
    if (_ring.length > capacity) _ring.removeAt(0);
  }

  static void debug(String message) => _add(LogLevel.debug, message);
  static void info(String message) => _add(LogLevel.info, message);
  static void warn(String message) => _add(LogLevel.warn, message);
  static void error(String message) => _add(LogLevel.error, message);

  static void clearForTest() => _ring.clear();
}
