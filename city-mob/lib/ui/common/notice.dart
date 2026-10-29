import 'package:equatable/equatable.dart';

import '../../core/tr.dart';

/// One-off popup message from the bloc to the widget (toast). `seq` grows with every new message,
/// so the BlocListener fires even if the same text comes twice. The text is a translation key or final text.
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
