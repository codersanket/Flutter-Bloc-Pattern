import 'package:chopper/chopper.dart';
import './index.dart';

part 'auth_service.chopper.dart';

@ChopperApi()
abstract class AuthService extends ChopperService {
  static AuthService create(ChopperClient? client) => _$AuthService(client);

  @Post(path: '/auth/login')
  Future<Response<AuthDto>> login(
    @Field() String username,
    @Field() String password,
  );
}
