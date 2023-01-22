// ignore_for_file: inference_failure_on_function_invocation

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';
import 'package:infinity_box/repositories/index.dart';
import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/cache_service.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_service.dart';

void main() {
  group(
    'AppBloc Test',
    () {
      late AuthService authService;
      late CacheService cacheService;
      late Isar isar;
      late AuthRepository authRepository;

      setUp(() {
        authService = MockService.authService;
        cacheService = MockService.cacheService;
        isar = MockIsar();
        authRepository = AuthRepository(authService, cacheService, isar);
      });

      test('Initial State is AppState.initial', () {
        expect(AppBloc(authRepository).state, const AppState.initial());
      });

      blocTest('Check Initialize State If there is a no user available ',
          setUp: () {
            when(cacheService.get<String>(authToken))
                .thenAnswer((realInvocation) => null);
          },
          build: () => AppBloc(authRepository),
          act: (bloc) => bloc.add(
                const AppEvent.initialize(),
              ),
          expect: () => [const AppState.initialized()]);

      blocTest('Check Initialize State If there is a user available ',
          setUp: () {
            when(cacheService.get<String>(authToken))
                .thenAnswer((realInvocation) => 'Token');
          },
          build: () => AppBloc(authRepository),
          act: (bloc) => bloc.add(
                const AppEvent.initialize(),
              ),
          expect: () =>
              [const AppState.initialized(), const AppState.authenticated()]);
    },
  );
}
