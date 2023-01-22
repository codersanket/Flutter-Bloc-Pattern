// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_box/features/home/bloc/home_bloc.dart';
import 'package:infinity_box/repositories/index.dart';
import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';

import '../mocks/mock_service.dart';

void main() {
  group('Home Bloc Test', () {
    late HomeRepository homeRepository;
    late ModalHelper helper;
    late HomeService service;

    setUp(() {
      service = MockService.homeService;
      helper = MockService.modalHelper;
      homeRepository = HomeRepository(service);
    });

    test('Initial BLoC test', () {
      expect(HomeBloc(helper, homeRepository).state, const HomeState.loading());
    });
  });
}
