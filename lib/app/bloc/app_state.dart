part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState.initial() = Initial;
  const factory AppState.initialized() = Initialized;
  const factory AppState.authenticated() = Authenticated;
}
