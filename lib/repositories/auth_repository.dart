import 'dart:async';
import 'package:infinity_box/services/index.dart';
import 'package:infinity_box/shared/cache_service.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/subjects.dart';
import './index.dart';

const String authToken = 'authToken';

class AuthRepository extends BffRepository {
  final AuthService _authService;
  final Isar _isar;
  final _isAuthenticated = BehaviorSubject.seeded(false);
  String _token = '';
  final CacheService _cacheService;
  Stream<bool> get isAuthenticated => _isAuthenticated.asBroadcastStream();
  String get token => _token;
  AuthRepository(this._authService, this._cacheService, this._isar) : super();

  Future<ApiResult<String, FailureResult>> login(
    String username,
    String passWord,
  ) async {
    return guardApiCall<String, AuthDto>(
      invoker: () => _authService.login(username, passWord),
      mapper: (p0) {
        _token = p0.token;
        _isAuthenticated.value = true;
        _cacheService.set(authToken, token);

        return token;
      },
    );
  }

  Future<void> signOut() async {
    await _cacheService.remove(authToken);
    await _clearAll();
    _isAuthenticated.value = false;
  }

  Future<void> initialize() async {
    final token = _cacheService.get<String>(authToken);
    if (token != null) {
      _token = token;
      _isAuthenticated.value = true;
    }
  }

  Future<void> _clearAll() => _isar.writeTxn(_isar.clear);
}
