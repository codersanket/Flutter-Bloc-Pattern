import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends RequestInterceptor {
  final ValueGetter<Future<String>> _tokenProvider;
  AuthInterceptor(this._tokenProvider);
  @override
  FutureOr<Request> onRequest(Request request) async {
    final token = await _tokenProvider.call();
    if (token.isNotEmpty) {
      request.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return request;
  }
}
