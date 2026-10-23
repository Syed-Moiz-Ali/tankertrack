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

  @override
  String toString() => 'AppError($kind, $message)';
}
