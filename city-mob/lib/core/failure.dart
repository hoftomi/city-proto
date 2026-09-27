import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Felhasználónak megjeleníthető hiba: a backend ProblemDetail `detail` mezője (magyar szöveg),
/// vagy a kapcsolat, illetve a bejelentkezés hibája. A repositoryk ezt adják vissza Either bal oldalán.
class Failure extends Equatable {
  const Failure(this.message, {this.status = 0});

  final String message;

  /// HTTP-státusz, vagy 0, ha nem a szervertől jött.
  final int status;

  bool get unauthorized => status == 401;

  static const offline = Failure('Nem érem el a szervert. Ellenőrizd a kapcsolatot.');
  static const unknown = Failure('Hiba történt. Próbáld újra.');

  factory Failure.from(Object error) {
    if (error is Failure) return error;
    if (error is DioException) {
      final r = error.response;
      if (r == null) return offline;
      final data = r.data;
      final detail = data is Map ? data['detail'] : null;
      if (r.statusCode == 401) return Failure(detail?.toString() ?? 'A munkamenet lejárt. Jelentkezz be újra.', status: 401);
      return Failure(detail?.toString() ?? 'Hiba történt (${r.statusCode}).', status: r.statusCode ?? 0);
    }
    return unknown;
  }

  @override
  List<Object?> get props => [message, status];

  @override
  String toString() => message;
}
