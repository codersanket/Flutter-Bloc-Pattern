import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

abstract class ServiceLocator {
  //ignore:avoid-global-state
  static GetIt getIt = GetIt.asNewInstance();

  static void initialize() {
    getIt.reset();
    getIt = GetIt.asNewInstance();
  }

  T get<T extends Object>() => getIt.get<T>();

  T getWithParam<T extends Object, P extends Object>({P? param}) =>
      getIt.get<T>(param1: param);

  T getWithParams<T extends Object, P extends Object, P1 extends Object>({
    P? param1,
    P1? param2,
  }) =>
      getIt.get<T>(param1: param1, param2: param2);

  Future<T> getAsync<T extends Object>() => getIt.getAsync<T>();

  @visibleForTesting
  @protected
  Future<void> allReady() {
    return getIt.allReady();
  }

  @mustCallSuper
  static Future<void> reset() => getIt.reset();

  @visibleForTesting
  @protected
  void registerSingleton<T extends Object>(T instance) {
    getIt.registerSingleton(instance);
  }

  @visibleForTesting
  @protected
  void registerSingletonAsync<T extends Object>(
    ValueGetter<Future<T>> factoryFunc, {
    Iterable<Type>? dependsOn,
  }) =>
      getIt.registerSingletonAsync(factoryFunc, dependsOn: dependsOn);

  @visibleForTesting
  @protected
  void registerFactory<T extends Object>(ValueGetter<T> factoryFunc) =>
      getIt.registerFactory(factoryFunc);

  @visibleForTesting
  @protected
  void registerLazySingleton<T extends Object>(
    ValueGetter<T> factoryFunc, {
    DisposingFunc<T>? dispose,
  }) =>
      getIt.registerLazySingleton(factoryFunc, dispose: dispose);

  @visibleForTesting
  @protected
  void registerFactoryParam<T extends Object, P1, P2>(
    T Function(P1, P2) factoryFunc, {
    String? instanceName,
  }) =>
      getIt.registerFactoryParam(factoryFunc, instanceName: instanceName);
}
