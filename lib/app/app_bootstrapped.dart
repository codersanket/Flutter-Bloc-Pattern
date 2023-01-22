import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:infinity_box/app/app_route.gr.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';
import 'package:infinity_box/features/auth/bloc/auth_bloc.dart';
import 'package:infinity_box/features/cart/bloc/cart_bloc.dart';
import 'package:infinity_box/features/home/bloc/home_bloc.dart';
import 'package:infinity_box/repositories/auth_repository.dart';
import 'package:infinity_box/repositories/cart_repository.dart';
import 'package:infinity_box/repositories/home_repository.dart';
import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/cache_service.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';
import 'package:infinity_box/shared/service_locator.dart';
import 'package:infinity_box/shared/shared_preferance_user.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt get get => ServiceLocator.getIt;

class AppBootStrapper extends ServiceLocator {
  final _isInitialized = BehaviorSubject.seeded(false);

  static final instance = AppBootStrapper._();
  Stream<bool> get isInitialized => _isInitialized.asBroadcastStream();
  AppBootStrapper._();

  Future<void> initialize() async {
    _isInitialized.value = false;
    try {
      ServiceLocator.initialize();

      await _registerHelpers();
      _registerService();
      _registerRepository();
      _registerBlOC();
      await allReady();

      _isInitialized.value = true;
    } catch (e) {
      log('Not Able to Initialize the App with error $e');
    }
  }

  void _registerService() {
    final client = _createClient(converter: JsonSerializableConverter.instance);

    registerLazySingleton(() => AuthService.create(client));
    registerLazySingleton(() => HomeService.create(
          _createClient(converter: CustomSerializableConverter.instance),
        ));
    registerLazySingleton(() => ProductDatabase(get()));
  }

  void _registerRepository() {
    registerLazySingleton(() => AuthRepository(get(), get(), get()));
    registerLazySingleton(() => HomeRepository(get()));
    registerLazySingleton(() => CartRepository(get()));
  }

  void _registerBlOC() {
    registerFactory(() => AppBloc(get()));
    registerFactory(() => AuthBloc(get(), get()));
    registerFactory(() => HomeBloc(get(), get()));
    registerFactory(() => CartBloc(get(), get()));
  }

  Future<void> _registerHelpers() async {
    registerSingletonAsync(SharedPreferences.getInstance);
    registerSingletonAsync(() => _getLocalDatabase([ProductCollectionSchema]));
    registerFactory(() => SharedPreferencesService(get()));
    registerLazySingleton(() => CacheService(get()));
    registerLazySingleton(AppRouter.new);
    registerLazySingleton(() => ModalHelper(get()));
    await allReady();
  }

  ChopperClient _createClient({Converter? converter}) {
    final interceptors = [
      AuthInterceptor(() async => get<AuthRepository>().token),
      LoggingInterceptor(),
    ];
    final baseUrl = Uri.parse('https://fakestoreapi.com');

    return ChopperClient(
      baseUrl: baseUrl,
      converter: converter,
      interceptors: interceptors,
    );
  }

  // ignore: strict_raw_type
  Future<Isar> _getLocalDatabase(List<CollectionSchema> schemas) async {
    return Isar.open(schemas);
  }
}
