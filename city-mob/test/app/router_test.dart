import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/app/di/di.dart';
import 'package:tron_nelkul/app/router/app_router.dart';
import 'package:tron_nelkul/app/router/routes.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/ui/auth/bloc/auth_bloc.dart';

class _Auth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

/// A route-fa felépíthető (a go_router a konfigurációt induláskor ellenőrzi), és minden útvonal a várt helyre visz.
void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  setUpAll(configureDependencies);

  Future<GoRouter> app(WidgetTester t, AuthState state) async {
    final auth = _Auth();
    whenListen(auth, const Stream<AuthState>.empty(), initialState: state);
    final router = buildRouter(auth);
    await t.pumpWidget(BlocProvider<AuthBloc>.value(value: auth, child: MaterialApp.router(theme: buildTheme(), routerConfig: router)));
    await t.pump();
    return router;
  }

  String at(GoRouter r) => r.routerDelegate.currentConfiguration.uri.toString();

  testWidgets('kilépve a belépésre irányít', (t) async {
    final r = await app(t, const AuthState(status: AuthStatus.signedOut));
    r.go(Routes.map('g'));
    await t.pump();
    expect(at(r), Routes.login);
  });

  testWidgets('belépve a játék fülei és a városnézet paraméterei', (t) async {
    final r = await app(t, AuthState(status: AuthStatus.signedIn, user: UserDto(id: '00000000-0000-0000-0000-000000000001', name: 'V', role: 'PLAYER')));
    expect(at(r), Routes.lobby);
    for (final path in [Routes.map('g'), Routes.city('g', cityId: 'szelmezo', district: 'kem'), Routes.reports('g'), Routes.orders('g'), Routes.ranking('g')]) {
      r.go(path);
      await t.pump();
      expect(at(r), path);
    }
    r.go('/games/g/play');
    await t.pump();
    expect(at(r), Routes.map('g'), reason: 'a szülő a Térképre irányít');
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 30));
  });
}
