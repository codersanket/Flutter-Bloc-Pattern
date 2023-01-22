import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:infinity_box/services/index.dart';

import 'mock_dto.dart';

class MockResponses {
  static Response<AuthDto> loginResponse =
      Response(http.Response('', 200), MockDto.authDto);

  static Response<AuthDto> errorResponseDto =
      Response(http.Response('', 401), MockDto.authDto);

  Response<List<String>> categories =
      Response(http.Response('', 200), const ['Mobile', 'Laptop']);

  Response<List<String>> products =
      Response(http.Response('', 200), const ['Mobile', 'Laptop']);
}
