import 'package:equatable/equatable.dart';

import '../../core/tr.dart';

/// Egyszeri, felugró üzenet a blocból a widgetnek (toast). A `seq` minden új üzenetnél nő,
/// így a BlocListener akkor is jelez, ha ugyanaz a szöveg jön kétszer. A szöveg fordítási kulcs vagy kész szöveg.
class Notice extends Equatable {
  const Notice(this.seq, this.title, {this.body, this.tone = 'info'});

  final int seq;
  final Tr title;
  final Tr? body;

  /// info | ok | warn | danger
  final String tone;

  @override
  List<Object?> get props => [seq, title, body, tone];
}
