/// Classified failures. UI maps each to a finished error state —
/// never a red screen. `offlineQueued` is NOT an error for the user
/// (event saved locally, will sync).
enum AppErrorKind {
  network,
  offlineQueued,
  conflict,
  validation,
  forbidden,
  notFound,
  server,
  unknown,
}

class AppError {
  const AppError(this.kind, {this.message, this.details});

  final AppErrorKind kind;
  final String? message;
  final Map<String, Object?>? details;

  const AppError.network({String? message})
      : this(AppErrorKind.network, message: message);
  const AppError.offlineQueued({String? message})
      : this(AppErrorKind.offlineQueued, message: message);
  const AppError.conflict({String? message, Map<String, Object?>? details})
      : this(AppErrorKind.conflict, message: message, details: details);
  const AppError.validation({String? message, Map<String, Object?>? details})
      : this(AppErrorKind.validation, message: message, details: details);
  const AppError.forbidden({String? message})
      : this(AppErrorKind.forbidden, message: message);
  const AppError.notFound({String? message})
      : this(AppErrorKind.notFound, message: message);
  const AppError.server({String? message})
      : this(AppErrorKind.server, message: message);
  const AppError.unknown({String? message})
      : this(AppErrorKind.unknown, message: message);

  // Hand-written (P1b contracts §2 exception): value equality so tests
  // and Result comparisons are structural.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError &&
          other.kind == kind &&
          other.message == message &&
          _detailsEqual(other.details, details);

  @override
  int get hashCode => Object.hash(kind, message, _detailsHash(details));

  @override
  String toString() => 'AppError($kind, $message)';
}

bool _detailsEqual(Map<String, Object?>? a, Map<String, Object?>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;
  for (final k in a.keys) {
    if (!b.containsKey(k) || b[k] != a[k]) return false;
  }
  return true;
}

int _detailsHash(Map<String, Object?>? details) {
  if (details == null) return 0;
  final sorted = details.keys.toList()..sort();
  return Object.hashAll([for (final k in sorted) Object.hash(k, details[k])]);
}
