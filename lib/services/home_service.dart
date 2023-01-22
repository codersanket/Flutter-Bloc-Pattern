import 'package:chopper/chopper.dart';

part 'home_service.chopper.dart';

@ChopperApi()
abstract class HomeService extends ChopperService {
  static HomeService create(ChopperClient? client) => _$HomeService(client);

  @Get(path: '/products/categories')
  Future<Response<List<String>>> getCategories();

  @Get(
    path: '/products',
  )
  Future<Response<List<String>>> getProducts({
    @Query() required int limit,
  });
}
