import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../ui/auth/bloc/auth_bloc.dart';
import '../../ui/game/bloc/game_bloc.dart';
import '../../ui/game/city/city_page.dart';
import '../../ui/game/game_shell_page.dart';
import '../../ui/game/map/map_page.dart';
import '../../ui/game/orders/orders_page.dart';
import '../../ui/game/ranking/ranking_page.dart';
import '../../ui/game/reports/reports_page.dart';
import '../../ui/game_detail/game_detail_page.dart';
import '../../ui/join/join_page.dart';
import '../../ui/lobby/lobby_page.dart';
import '../../ui/login/login_page.dart';
import '../../ui/splash/splash_page.dart';
import '../di/di.dart';
import 'routes.dart';

/// Navigation (go_router). Routes by sign-in state: unknown → loading, signed out → sign-in,
/// signed in → game picker. The game's five tabs are branches of a StatefulShellRoute; GameBloc wraps the whole game.
GoRouter buildRouter(AuthBloc auth) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: _StreamListenable(auth.stream),
    redirect: (context, state) {
      final status = auth.state.status;
      final at = state.matchedLocation;
      if (status == AuthStatus.unknown) return at == Routes.splash ? null : Routes.splash;
      if (status == AuthStatus.signedOut) return at == Routes.login ? null : Routes.login;
      if (at == Routes.login || at == Routes.splash) return Routes.lobby;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: Routes.lobby,
        builder: (_, _) => const LobbyPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => GameDetailPage(gameId: s.pathParameters['id']!),
            routes: [
              GoRoute(path: 'join', builder: (_, s) => JoinPage(gameId: s.pathParameters['id']!)),
            ],
          ),
        ],
      ),
      // The game: under the /games/:id/play parent the tabs are relative (parameterless) paths, so go_router
      // fills the branches' base paths with the parent's :id parameter (a shell branch can't be a parameterized path).
      GoRoute(
        path: '/games/:id/play',
        redirect: (_, s) => s.uri.pathSegments.length <= 3 ? Routes.map(s.pathParameters['id']!) : null,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) {
              final id = state.pathParameters['id']!;
              return BlocProvider<GameBloc>(
                key: ValueKey('game/$id'),
                create: (_) => getIt<GameBloc>()..add(GameStarted(id)),
                child: GameShellPage(shell: shell),
              );
            },
            branches: [
              StatefulShellBranch(routes: [GoRoute(path: 'map', builder: (_, _) => const MapPage())]),
              StatefulShellBranch(routes: [
                GoRoute(path: 'city', builder: (_, s) => CityPage(cityId: s.uri.queryParameters['c'], district: s.uri.queryParameters['d'])),
              ]),
              StatefulShellBranch(routes: [GoRoute(path: 'reports', builder: (_, _) => const ReportsPage())]),
              StatefulShellBranch(routes: [GoRoute(path: 'orders', builder: (_, _) => const OrdersPage())]),
              StatefulShellBranch(routes: [GoRoute(path: 'ranking', builder: (_, _) => const RankingPage())]),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Bloc state changes forwarded to the router (re-evaluates the redirect).
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
