part of 'app_bloc.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.authenticated() = AuthenticatedAppEvent;
  const factory AppEvent.initialize() = Initialize;
  const factory AppEvent.logOut() = LogOut;
}
