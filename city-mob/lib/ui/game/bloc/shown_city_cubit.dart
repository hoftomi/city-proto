import 'package:flutter_bloc/flutter_bloc.dart';

/// The city currently open on the City tab (null: none yet). Shell-scoped: the GameShellPage provides it, the
/// CityPage reports the city its CityBloc resolved (URL parameter or default), and the shell's top bar shows that
/// city's header while the City branch is active. Branches stay alive in the StatefulShellRoute, so the value
/// survives switching tabs.
class ShownCityCubit extends Cubit<String?> {
  ShownCityCubit() : super(null);

  void show(String? cityId) => emit(cityId);
}
