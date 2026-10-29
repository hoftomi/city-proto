part of 'join_bloc.dart';

/// After a successful join: into the game if it is running, otherwise back to the details.
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
    this.background = Background.merchant,
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

  /// The current step (0..3).
  final int step;
  final String name;

  /// The name error (always computed; shown only after `touched`).
  final Tr? nameError;
  final bool touched;
  final Background background;
  final String start;

  /// The Merchant House chosen starting good (if none chosen, the first).
  final String? startGood;

  /// Submitting the join.
  final bool busy;
  final Notice? notice;

  /// Successful join (set once; the widget navigates then).
  final JoinOutcome? outcome;

  bool get ready => detail != null && map != null;
  GameSummary? get game => detail?.game;
  List<Tr> get steps => JoinService.steps;
  bool get lastStep => step == steps.length - 1;

  /// The system back button leaves the screen only on the first step.
  bool get canPop => step == 0;

  String get trimmedName => name.trim();

  /// The error shown under the name field.
  Tr? get shownNameError => touched ? nameError : null;

  /// Whether the Next button is enabled.
  bool get canContinue => !(step == 0 && touched && nameError != null);

  Tr get nextLabel => lastStep ? const Tr('join.confirm') : const Tr('join.next');
  Tr get backLabel => step > 0 ? const Tr('join.back') : const Tr('join.cancel');

  StartSlotDto? get slot => detail?.slot(start);
  BackgroundDto? get backgroundDto => detail?.background(background);
  bool get needsGood => detail?.needsGood(background, start) ?? false;
  GoodOption? get good => detail?.good(background, start, startGood);

  JoinForm get form => (name: name, background: background, start: start, startGood: startGood);

  /// The summary's "Start" row.
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
    Background? background,
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
      [gameId, detail, map, failure, step, name, nameError, touched, background, start, startGood, busy, notice, outcome];
}
