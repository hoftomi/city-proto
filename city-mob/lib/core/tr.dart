import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

/// Megjeleníthető szöveg a blocokból és a service-ekből: fordítási kulcs paraméterekkel (a feliratok a backend
/// /api/i18n végpontjáról jönnek, easy_localization), vagy a szervertől kész szöveg (például a ProblemDetail `detail`
/// mezője, a jelentések). A widget a [text]-et jeleníti meg, így a blocok nem függnek a betöltött nyelvtől.
class Tr extends Equatable {
  const Tr(this.key, [this.args = const {}]) : raw = null;

  /// Kész, már lefordított szöveg (a szervertől).
  const Tr.raw(String this.raw)
      : key = '',
        args = const {};

  final String key;
  final Map<String, String> args;
  final String? raw;

  String get text => raw ?? key.tr(namedArgs: args);

  @override
  List<Object?> get props => [key, args, raw];

  @override
  String toString() => raw ?? '$key$args';
}
