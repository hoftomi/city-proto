import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

/// Displayable text from blocs and services: a translation key with params (labels come from the backend
/// /api/i18n endpoint, easy_localization), or ready-made text from the server (e.g. the ProblemDetail `detail`
/// field, reports). The widget displays [text], so blocs don't depend on the loaded language.
class Tr extends Equatable {
  const Tr(this.key, [this.args = const {}]) : raw = null;

  /// Ready, already translated text (from the server).
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
