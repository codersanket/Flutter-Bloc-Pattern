import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:infinity_box/repositories/results/api_received_exception.dart';
import 'package:infinity_box/services/data/auth_dto.dart';

typedef _JsonFactory<T> = T Function(Map<String, dynamic> json);

final List<Map<Object, _JsonFactory<Object?>>> jsonDecoderMappings = [
  {AuthDto: AuthDto.fromJson},
];

class FormSerializableConverter extends JsonSerializableConverter {
  static final instance = FormSerializableConverter._();

  FormSerializableConverter._() : super._();

  @override
  Request convertRequest(Request request) {
    var req = applyHeader(
      request,
      contentTypeKey,
      formEncodedHeaders,
      override: false,
    );

    if (req.body is Map<String, String>) {
      return req;
    }

    if (req.body is Map) {
      final body = <String, String>{};

      (req.body as Map).forEach((dynamic key, dynamic val) {
        body[key.toString()] = val.toString();
      });

      req = req.copyWith(body: body);
    }

    return req;
  }
}

class CustomSerializableConverter extends JsonConverter {
  static const instance = CustomSerializableConverter._();

  const CustomSerializableConverter._();

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(
    Response<dynamic> response,
  ) async {
    if (response.bodyString.isEmpty) {
      return Response(response.base, null, error: response.error);
    }

    final jsonRes = await super.convertResponse<Object, Item>(response);

    return jsonRes.copyWith<ResultType>(
      body: json
          .decode(response.bodyString)
          .where((dynamic element) => element != null)
          .map<String>(
            (dynamic item) => item is Map ? jsonEncode(item) : item as String,
          )
          .toList(),
    );
  }
}

class JsonSerializableConverter extends JsonConverter {
  final jsonDecoder = CustomJsonDecoder(jsonDecoderMappings);
  static final instance = JsonSerializableConverter._();

  JsonSerializableConverter._();

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(
    Response<dynamic> response,
  ) async {
    if (response.bodyString.isEmpty) {
      return Response(response.base, null, error: response.error);
    }

    final jsonRes = await super.convertResponse<Object, Item>(response);

    final jsonMap = jsonRes.body as Map<String, dynamic>;

    if (jsonMap.containsKey('errorCode')) {
      final res = jsonRes.base as http.Response;
      final newBase = http.Response(res.body, 400, request: res.request);

      return Response(newBase, null, error: jsonRes.body);
    }

    if (jsonMap.containsKey('statusCode') &&
        jsonMap.containsKey('message') &&
        jsonMap.containsKey('description')) {
      throw ApiErrorReceivedException(response.bodyString);
    }

    return jsonRes.copyWith<ResultType>(
      body: jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

class CustomJsonDecoder {
  final List<Map<Object, _JsonFactory<Object?>>> fromJson;

  const CustomJsonDecoder(this.fromJson);

  dynamic decode<T>(Object? entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }
    if (entity is T) {
      return entity;
    }
    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = _getFromJson<T>();
    try {
      return jsonFactory(values);
    } catch (ex) {
      rethrow;
    }
  }

  _JsonFactory<T> _getFromJson<T>() {
    for (final list in fromJson) {
      if (list[T] != null) {
        return list[T]! as _JsonFactory<T>;
      }
    }

    return throw Exception(
      "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?",
    );
  }

  List<T> _decodeList<T>(Iterable<Object?> values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}
