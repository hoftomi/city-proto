import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../ui/auth/bloc/auth_bloc.dart';
import 'di/di.dart';
import 'router/app_router.dart';

/// Az app gyökere: a munkamenet (AuthBloc) és a router.
class TronApp extends StatefulWidget {
  const TronApp({super.key});

  @override
  State<TronApp> createState() => _TronAppState();
}

class _TronAppState extends State<TronApp> {
  final AuthBloc _auth = getIt<AuthBloc>()..add(const AuthStarted());
  late final GoRouter _router = buildRouter(_auth);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _auth,
      child: MaterialApp.router(
        title: 'Trón nélkül',
        debugShowCheckedModeBanner: false,
        // Krónika IV: egyetlen világos téma („Nappal”).
        theme: buildTheme(),
        themeMode: ThemeMode.light,
        routerConfig: _router,
      ),
    );
  }
}
