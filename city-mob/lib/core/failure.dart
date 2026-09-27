import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'tr.dart';

/// Felhasználónak megjeleníthető hiba: a backend ProblemDetail `detail` mezője (a szerver által már lefordított szöveg),
/// vagy a kapcsolat, illetve a bejelentkezés hibája fordítási kulccsal. A repositoryk ezt adják vissza Either bal oldalán.
class Failure extends Equatable {
  const Failure(this.message, {this.status = 0, this.code});

  final Tr message;

  /// HTTP-státusz, vagy 0, ha nem a szervertől jött.
  final int status;

  /// A ProblemDetail opcionális gépi kódja (például `house_name`), amely alapján a kliens dönthet.
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
