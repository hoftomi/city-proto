part of 'join_bloc.dart';

sealed class JoinEvent extends Equatable {
  const JoinEvent();

  @override
  List<Object?> get props => [];
}

/// A képernyő megnyitásakor: a játék kínálata (tinktúrák, hátterek, kezdőhelyek) és a térkép.
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

/// A névmezőben Entert nyomott: a hiba ettől kezdve látszik.
class JoinNameSubmitted extends JoinEvent {
  const JoinNameSubmitted();
}

class JoinTinctureSelected extends JoinEvent {
  const JoinTinctureSelected(this.tincture);
  final String tincture;

  @override
  List<Object?> get props => [tincture];
}

class JoinBackgroundSelected extends JoinEvent {
  const JoinBackgroundSelected(this.background);
  final String background;

  @override
  List<Object?> get props => [background];
}

class JoinStartSelected extends JoinEvent {
  const JoinStartSelected(this.start);
  final String start;

  @override
  List<Object?> get props => [start];
}

/// A Kereskedőház induló árucikke.
class JoinStartGoodSelected extends JoinEvent {
  const JoinStartGoodSelected(this.good);
  final String good;

  @override
  List<Object?> get props => [good];
}

/// Tovább a következő lépésre; az utolsón a jelentkezés beküldése.
class JoinNextPressed extends JoinEvent {
  const JoinNextPressed();
}

/// Vissza az előző lépésre.
class JoinBackPressed extends JoinEvent {
  const JoinBackPressed();
}
