import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/datasource/auth/identity_datasource.dart';
import 'session_events.dart';

/// Minden kérésre ráteszi a Firebase ID tokent (Authorization: Bearer); a token lejárat előtt magától megújul.
/// 401-es válasznál jelez a SessionEvents-en, és az AuthBloc kiléptet.
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
      // Token nélkül megy tovább; a szerver 401-et ad, ha kellett volna.
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && err.requestOptions.headers.containsKey('Authorization')) _events.expire();
    handler.next(err);
  }
}
