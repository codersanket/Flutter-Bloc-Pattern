import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_box/repositories/index.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final ModalHelper _helper;
  AuthBloc(this._authRepository, this._helper) : super(AuthState.initial()) {
    on<Login>(_login);
  }

  Future<void> _login(Login login, Emitter<AuthState> emit) async {
    _helper.showLoadingWidget();
    final resp = await _authRepository.login(login.username, login.pass);
    if (resp.isSuccess) {
      log(resp.success);
    } else {
      _helper.showSnackBar(resp.failure.reason);
      log(resp.failure.reason);
    }
    _helper.removeLoader();
  }
}
