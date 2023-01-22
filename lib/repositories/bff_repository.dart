import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chopper/chopper.dart';
import './index.dart';

const _clientTimeoutSeconds = 30;
typedef BffTokenCallback = void Function(String)?;

abstract class BffRepository {
  BffRepository();

  FutureOr<ApiResult<T, FailureResult>> guardApiCall<T, TSource>({
    required Future<Response<TSource>> Function() invoker,
    FutureOr<T> Function(TSource)? mapper,
    bool handleExpiration = true,
    FutureOr<T> Function(Response<TSource>)? responseMapper,
    T? defaultValue,
  }) async {
    try {
      final response = await invoker()
          .timeout(const Duration(seconds: _clientTimeoutSeconds));

      if (response.isSuccessful) {
        final body = response.body;
        if (body != null && mapper != null) {
          final successResult = await mapper(body);

          return ApiResult.success(successResult);
        } else if (responseMapper != null) {
          final successResult = await responseMapper(response);

          return ApiResult.success(successResult);
        } else if (defaultValue != null) {
          ApiResult.success(defaultValue);
        } else {
          return ApiResult.success(response.body as T);
        }
      } else if (response.statusCode == HttpStatus.unauthorized) {
        if (response.error
            .toString()
            .contains('username or password is incorrect')) {
          return Future.value(
            ApiResult.failure(
              FailureResult(
                reason: response.error.toString(),
                debugMessage: response.error.toString(),
                statusCode: 101,
              ),
            ),
          );
        }

        return handleExpiration
            ? guardApiCall(
                invoker: invoker,
                defaultValue: defaultValue,
                mapper: mapper,
                responseMapper: responseMapper,
                handleExpiration: false,
              )
            : Future.value(
                ApiResult.failure(
                  FailureResult(
                    reason: 'Token Expired',
                    debugMessage: 'Please Re-login',
                    statusCode: response.statusCode,
                  ),
                ),
              );
      }

      return const ApiResult.failure(
        FailureResult(reason: 'UnKnown', debugMessage: 'Something went wrong'),
      );
    } on SocketException catch (_) {
      return const ApiResult.failure(
        FailureResult(
          reason: 'No Internet Connection',
          debugMessage: 'No Internet',
        ),
      );
    } on TimeoutException catch (_) {
      return const ApiResult.failure(
        FailureResult(
          reason: 'Time Out',
          debugMessage: 'Timed Out Exception',
        ),
      );
    } catch (e) {
      log(e.toString());

      return const ApiResult.failure(
        FailureResult(
          reason: 'Something went wrong',
          debugMessage: 'Something went wrong',
        ),
      );
    }
  }
}
