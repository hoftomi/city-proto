import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/service/auth_service.dart';
import 'package:tron_nelkul/ui/auth/bloc/auth_bloc.dart';
import 'package:tron_api/tron_api.dart';

class _Service extends Mock implements AuthService {}

void main() {
  final user = UserDto(id: '00000000-0000-0000-0000-000000000001', name: 'Vándor', role: 'PLAYER');
  late _Service service;
  late StreamController<void> expired;

  setUp(() {
    service = _Service();
    expired = StreamController<void>.broadcast();
    when(() => service.sessionExpired).thenAnswer((_) => expired.stream);
    when(() => service.signOut()).thenAnswer((_) async {});
  });
  tearDown(() => expired.close());

  blocTest<AuthBloc, AuthState>('mentett munkamenet nélkül kilépett állapotba kerül',
      build: () {
        when(() => service.restore()).thenAnswer((_) async => null);
        return AuthBloc(service);
      },
      act: (b) => b.add(const AuthStarted()),
      expect: () => [const AuthState(status: AuthStatus.signedOut)]);

  blocTest<AuthBloc, AuthState>('a mentett felhasználóval indul, és frissíti a szerepét',
      build: () {
        when(() => service.restore()).thenAnswer((_) async => user);
        when(() => service.refresh()).thenAnswer((_) async => Right(user.copyWith(role: 'ADMIN')));
        return AuthBloc(service);
      },
      act: (b) => b.add(const AuthStarted()),
      expect: () => [
            AuthState(status: AuthStatus.signedIn, user: user),
            isA<AuthState>().having((s) => s.admin, 'admin', true),
          ]);

  blocTest<AuthBloc, AuthState>('sikeres belépés: a gomb pörög, utána belépett',
      build: () {
        when(() => service.signIn('google')).thenAnswer((_) async => Right(user));
        return AuthBloc(service);
      },
      act: (b) => b.add(const AuthSignInRequested('google')),
      expect: () => [
            const AuthState(busyProvider: 'google'),
            AuthState(status: AuthStatus.signedIn, user: user),
          ]);

  blocTest<AuthBloc, AuthState>('megszakított belépés: nincs hiba, marad kilépve',
      build: () {
        when(() => service.signIn('apple')).thenAnswer((_) async => const Right(null));
        return AuthBloc(service);
      },
      act: (b) => b.add(const AuthSignInRequested('apple')),
      expect: () => [const AuthState(busyProvider: 'apple'), const AuthState()]);

  blocTest<AuthBloc, AuthState>('sikertelen belépés: a hibaüzenet az állapotban',
      build: () {
        when(() => service.signIn('discord')).thenAnswer((_) async => const Left(Failure(Tr('auth.failed'))));
        return AuthBloc(service);
      },
      act: (b) => b.add(const AuthSignInRequested('discord')),
      expect: () => [const AuthState(busyProvider: 'discord'), const AuthState(error: Tr('auth.failed'))]);

  blocTest<AuthBloc, AuthState>('401 után kiléptet, és jelzi, hogy lejárt a munkamenet',
      build: () {
        when(() => service.restore()).thenAnswer((_) async => user);
        when(() => service.refresh()).thenAnswer((_) async => Right(user));
        return AuthBloc(service);
      },
      act: (b) async {
        b.add(const AuthStarted());
        await Future<void>.delayed(Duration.zero);
        expired.add(null);
      },
      skip: 1,
      expect: () => [const AuthState(status: AuthStatus.signedOut, error: Tr('error.session_expired'))],
      verify: (_) => verify(() => service.signOut()).called(1));
}
