import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'tr.dart';

/// User-displayable error: the backend ProblemDetail `detail` field (text already translated by the server),
/// or a connection or sign-in error with a translation key. Repositories return this on the left of Either.
class Failure extends Equatable {
  const Failure(this.message, {this.status = 0, this.code});

  final Tr message;

  /// HTTP status, or 0 if it didn't come from the server.
  final int status;

  /// Optional machine code of the ProblemDetail (e.g. `house_name`) the client can branch on.
  final String? code;

  bool get unauthorized => status == 401;

  static const offline = Failure(Tr('error.offline'));
  static const unknown = Failure(Tr('error.unknown'));

  factory Failure.from(Object error) {
    if (error is Failure) return error;
    if (error is DioException) {
      final r = error.response;
      if (r == null) return offline;
      final data = r.data;
      final detail = data is Map ? data['detail']?.toString() : null;
      final message = detail != null ? Tr.raw(detail) : r.statusCode == 401 ? const Tr('error.session_expired') : Tr('error.status', {'code': '${r.statusCode}'});
      return Failure(message, status: r.statusCode ?? 0, code: data is Map ? data['code']?.toString() : null);
    }
    return unknown;
  }

  @override
  List<Object?> get props => [message, status, code];

  @override
  String toString() => message.toString();
}
