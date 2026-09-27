import 'package:equatable/equatable.dart';

/// Egyszeri, felugró üzenet a blocból a widgetnek (toast). A `seq` minden új üzenetnél nő,
/// így a BlocListener akkor is jelez, ha ugyanaz a szöveg jön kétszer.
class Notice extends Equatable {
  const Notice(this.seq, this.title, {this.body, this.tone = 'info'});

  final int seq;
  final String title;
  final String? body;

  /// info | ok | warn | danger
  final String tone;

  @override
  List<Object?> get props => [seq, title, body, tone];
}
