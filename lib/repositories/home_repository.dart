import 'dart:convert';

import 'package:infinity_box/model/index.dart';
import 'package:infinity_box/services/index.dart';

import './index.dart';

part 'home_repository_mapper.dart';

class HomeRepository extends BffRepository {
  final HomeService _homeService;

  HomeRepository(this._homeService);

  Future<ApiResult<List<String>, FailureResult>> getCategories() async {
    return guardApiCall<List<String>, List<String>>(
      invoker: _homeService.getCategories,
      mapper: (p0) => p0,
    );
  }

  Future<ApiResult<List<ProductModel>, FailureResult>> getProducts([
    int limit = 5,
  ]) async {
    return guardApiCall<List<ProductModel>, List<String>>(
      invoker: () => _homeService.getProducts(limit: limit),
      mapper: (p0) => p0.toModel,
    );
  }
}
