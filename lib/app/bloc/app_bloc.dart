import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../repositories/index.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  late StreamSubscription<bool> _authStream;
  AppBloc(this._authRepository) : super(const AppState.initial()) {
    on<Initialize>(_initialize);

    on<AuthenticatedAppEvent>(_authenticated);

    on<LogOut>(_logOut);

    _authStream = _authRepository.isAuthenticated.distinct().listen((event) {
      if (event) add(const AppEvent.authenticated());
    });
  }

  @override
  Future<void> close() {
    _authStream.cancel();

    return super.close();
  }

  Future<void> _initialize(
    Initialize initialize,
    Emitter<AppState> emit,
  ) async {
    await _authRepository.initialize();
    emit(const AppState.initialized());
  }

  Future<void> _logOut(LogOut logOut, Emitter<AppState> emit) async {
    await _authRepository.signOut();
    emit(const AppState.initialized());
  }

  Future<void> _authenticated(
    AuthenticatedAppEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppState.authenticated());
  }
}
