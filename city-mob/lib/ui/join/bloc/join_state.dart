part of 'join_bloc.dart';

/// Sikeres jelentkezés után: futó játéknál be a játékba, különben vissza a részletekre.
enum JoinOutcome { enterGame, backToDetail }

class JoinState extends Equatable {
  const JoinState({
    this.gameId,
    this.detail,
    this.map,
    this.failure,
    this.step = 0,
    this.name = '',
    this.nameError,
    this.touched = false,
    this.tincture = '',
    this.background = '',
    this.start = '',
    this.startGood,
    this.busy = false,
    this.notice,
    this.outcome,
  });

  final String? gameId;
  final GameDetail? detail;
  final MapDef? map;
  final Failure? failure;

  /// Az aktuális lépés (0..3).
  final int step;
  final String name;

  /// A név hibája (mindig számolva; csak `touched` után látszik).
  final Tr? nameError;
  final bool touched;
  final String tincture, background, start;

  /// A Kereskedőház választott induló árucikke (ha nem választott, az első).
  final String? startGood;

  /// Épp küldi a jelentkezést.
  final bool busy;
  final Notice? notice;

  /// Sikeres jelentkezés (egyszer áll be; a widget ekkor navigál).
  final JoinOutcome? outcome;

  bool get ready => detail != null && map != null;
  GameSummary? get game => detail?.game;
  List<Tr> get steps => JoinService.steps;
  bool get lastStep => step == steps.length - 1;

  /// A rendszer vissza gombja csak az első lépésen hagyja el a képernyőt.
  bool get canPop => step == 0;

  String get trimmedName => name.trim();

  /// A névmező alatt látható hiba.
  Tr? get shownNameError => touched ? nameError : null;

  /// A Tovább gomb engedélyezett-e.
  bool get canContinue => !(step == 0 && touched && nameError != null);

  Tr get nextLabel => lastStep ? const Tr('join.confirm') : const Tr('join.next');
  Tr get backLabel => step > 0 ? const Tr('join.back') : const Tr('join.cancel');

  StartSlotDto? get slot => detail?.slot(start);
  BackgroundDto? get backgroundDto => detail?.background(background);
  bool get needsGood => detail?.needsGood(background, start) ?? false;
  GoodOption? get good => detail?.good(background, start, startGood);

  JoinForm get form => (name: name, tincture: tincture, background: background, start: start, startGood: startGood);

  /// Az összegzés „Kezdés” sora.
  Tr get startText => game == null ? const Tr.raw('') : (game!.running ? const Tr('join.start_now') : game!.startsAtText);

  JoinState copyWith({
    String? gameId,
    GameDetail? detail,
    MapDef? map,
    Failure? failure,
    bool clearFailure = false,
    int? step,
    String? name,
    Tr? nameError,
    bool clearNameError = false,
    bool? touched,
    String? tincture,
    String? background,
    String? start,
    String? startGood,
    bool? busy,
    Notice? notice,
    JoinOutcome? outcome,
  }) {
    return JoinState(
      gameId: gameId ?? this.gameId,
      detail: detail ?? this.detail,
      map: map ?? this.map,
      failure: clearFailure ? null : failure ?? this.failure,
      step: step ?? this.step,
      name: name ?? this.name,
      nameError: clearNameError ? nameError : nameError ?? this.nameError,
      touched: touched ?? this.touched,
      tincture: tincture ?? this.tincture,
      background: background ?? this.background,
      start: start ?? this.start,
      startGood: startGood ?? this.startGood,
      busy: busy ?? this.busy,
      notice: notice ?? this.notice,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props =>
      [gameId, detail, map, failure, step, name, nameError, touched, tincture, background, start, startGood, busy, notice, outcome];
}
