//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:tron_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:tron_api/src/model/problem_detail.dart';

class I18nApi {

  final Dio _dio;

  const I18nApi(this._dio);

  /// A kliens összes felirata egy nyelven (easy_localization formátum)
  /// Névterenként beágyazott kulcs–szöveg párok (például {\&quot;lobby\&quot;:{\&quot;title\&quot;:\&quot;Játékok\&quot;}}). A paraméterek {név} alakúak. Ismeretlen nyelvnél a magyar változat jön. Bejelentkezés nélkül is elérhető, mert a belépőképernyő is ebből dolgozik.
  ///
  /// Parameters:
  /// * [lang] - Nyelvkód, például hu
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Map<String, Object>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Map<String, Object>>> getTranslations({ 
    required String lang,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/i18n/{lang}'.replaceAll('{' r'lang' '}', lang.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Map<String, Object>? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<Map<String, Object>, Object>(rawData, 'Map<String, Object>', growable: true);

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Map<String, Object>>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
