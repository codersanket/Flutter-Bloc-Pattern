import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

@freezed
class ApiResult<T, E extends Exception> with _$ApiResult<T, E> {
  bool get isSuccess => this is _Success;
  bool get isFailed => this is _Failure;

  T get success => (this as _Success).data as T;

  E get failure => (this as _Failure).error as E;
  const ApiResult._();
  const factory ApiResult.success(T data) = _Success;
  const factory ApiResult.failure(E error) = _Failure;
}
