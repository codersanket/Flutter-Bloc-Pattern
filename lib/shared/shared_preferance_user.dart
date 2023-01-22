import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  const SharedPreferencesService(this._prefs);

  Future<bool> set<T>(
    String key,
    T value,
  ) async {
    if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    }

    return false;
  }

  T? get<T>(
    String key,
  ) {
    return _prefs.get(key) as T?;
  }

  Future<bool> clear() {
    return _prefs.clear();
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
