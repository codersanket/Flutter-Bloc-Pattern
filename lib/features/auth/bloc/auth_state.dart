part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    String? username,
    String? password,
    FailureResult? result,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState();
}
