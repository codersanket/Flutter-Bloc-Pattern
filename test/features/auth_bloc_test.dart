// ignore_for_file: inference_failure_on_function_invocation

import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';
import 'package:infinity_box/features/auth/bloc/auth_bloc.dart';
import 'package:infinity_box/repositories/index.dart';
import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/cache_service.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_response.dart';
import '../mocks/mock_service.dart';
import '../mocks/mock_service.mocks.dart';

void main() {
  group(
    'AuthBloc Tests',
    () {
      late AuthRepository authRepository;
      late AuthService authService;
      late CacheService cacheService;
      late Isar isar;
      late ModalHelper helper;

      setUp(() {
        cacheService = MockService.cacheService;
        authService = MockService.authService;
        isar = MockIsar();
        helper = MockService.modalHelper;
        authRepository = AuthRepository(authService, cacheService, isar);

        when(helper.showSnackBar('Something went wrong'))
            .thenAnswer((realInvocation) => ScaffoldMessengerState());

        when(helper.showLoadingWidget())
            .thenAnswer((realInvocation) => Future.value);
        when(helper.removeLoader())
            .thenAnswer((realInvocation) => Future.value);
      });

      test('Initial Auth State', () {
        expect(AuthBloc(authRepository, MockService.modalHelper).state,
            AuthState.initial());
      });

      blocTest(
        'Login Event',
        setUp: () {
          when(authService.login('', '')).thenAnswer(
              (realInvocation) async => MockResponses.loginResponse);
        },
        build: () => AuthBloc(authRepository, helper),
        act: (bloc) => bloc.add(
          const AuthEvent.login('', ''),
        ),
        expect: () => [],
      );
    },
  );
}
