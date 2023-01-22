import 'package:infinity_box/shared/shared_preferance_user.dart';

/// Service for [key:value] saving data in local storage.
class CacheService {
  final SharedPreferencesService _sharedPrefsService;

  CacheService(this._sharedPrefsService);

  Future<bool> set<T>(
    String key,
    T value,
  ) {
    return _sharedPrefsService.set(key, value);
  }

  T? get<T>(
    String key,
  ) {
    return _sharedPrefsService.get(key);
  }

  Future<bool> clear() {
    return _sharedPrefsService.clear();
  }

  Future<bool> remove(String key) {
    return _sharedPrefsService.remove(key);
  }
}
