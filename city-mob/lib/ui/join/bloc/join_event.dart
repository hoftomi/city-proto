part of 'join_bloc.dart';

sealed class JoinEvent extends Equatable {
  const JoinEvent();

  @override
  List<Object?> get props => [];
}

/// On screen open: the game's options (backgrounds, start slots) and the map.
class JoinStarted extends JoinEvent {
  const JoinStarted(this.gameId);
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

class JoinNameChanged extends JoinEvent {
  const JoinNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

/// Enter pressed in the name field: the error is shown from now on.
class JoinNameSubmitted extends JoinEvent {
  const JoinNameSubmitted();
}

class JoinBackgroundSelected extends JoinEvent {
  const JoinBackgroundSelected(this.background);
  final Background background;

  @override
  List<Object?> get props => [background];
}

class JoinStartSelected extends JoinEvent {
  const JoinStartSelected(this.start);
  final String start;

  @override
  List<Object?> get props => [start];
}

/// The Merchant House starting good.
class JoinStartGoodSelected extends JoinEvent {
  const JoinStartGoodSelected(this.good);
  final String good;

  @override
  List<Object?> get props => [good];
}

/// On to the next step; on the last one, submit the join.
class JoinNextPressed extends JoinEvent {
  const JoinNextPressed();
}

/// Back to the previous step.
class JoinBackPressed extends JoinEvent {
  const JoinBackPressed();
}
