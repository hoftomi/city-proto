import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/datasource/auth/identity_datasource.dart';
import 'session_events.dart';

/// Attaches the Firebase ID token to every request (Authorization: Bearer); the token refreshes itself before expiry.
/// On a 401 response it signals on SessionEvents, and AuthBloc signs out.
@lazySingleton
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._identity, this._events);
  final IdentityDataSource _identity;
  final SessionEvents _events;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _identity.idToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    } catch (_) {
      // Proceeds without a token; the server returns 401 if one was needed.
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && err.requestOptions.headers.containsKey('Authorization')) _events.expire();
    handler.next(err);
  }
}
