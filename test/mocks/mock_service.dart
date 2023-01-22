import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/cache_service.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock_service.mocks.dart';

@GenerateMocks(
  [AuthService, HomeService, CacheService, ModalHelper],
)
class MockService {
  static AuthService authService = MockAuthService();
  static HomeService homeService = MockHomeService();
  static CacheService cacheService = MockCacheService();
  static ModalHelper modalHelper = MockModalHelper();
}

class MockIsar extends Mock implements Isar {}

class MockProductDatabase extends Mock implements ProductDatabase {}
