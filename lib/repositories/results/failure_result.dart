import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure_result.freezed.dart';

@freezed
class FailureResult with _$FailureResult implements Exception {
  const factory FailureResult({
    required String reason,
    required String debugMessage,
    int? statusCode,
  }) = _FailureResult;
}
