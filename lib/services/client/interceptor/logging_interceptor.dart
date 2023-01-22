import 'dart:async';
import 'dart:developer';

import 'package:chopper/chopper.dart';

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    log(request.toString());
    log('Body:${request.body}');

    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    log(response.body.toString());

    return response;
  }
}
