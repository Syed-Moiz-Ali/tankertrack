import 'app_error.dart';

/// Railway result: success carries [value], failure carries [error].
/// Repository and sync-engine APIs return this instead of throwing.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T get value => (this as Ok<T>).value;
  AppError get error => (this as Err<T>).error;

  R fold<R>(R Function(T) onOk, R Function(AppError) onErr) => switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final error) => onErr(error),
      };
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  @override
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.error);
  @override
  final AppError error;
}
