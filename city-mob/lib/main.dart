import 'package:flutter/material.dart';

import 'api/session.dart';
import 'app_state.dart';
import 'screens/lobby_screen.dart';
import 'screens/login_screen.dart';
import 'theme/tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await session.load();
  runApp(SessionScope(session: session, child: const TronApp()));
}

class TronApp extends StatelessWidget {
  const TronApp({super.key});

  @override
  Widget build(BuildContext context) {
    final s = SessionScope.of(context);
    return MaterialApp(
      // Belépéskor és kilépéskor új navigációs verem indul.
      key: ValueKey(s.loggedIn),
      title: 'Trón nélkül',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      // Kijelentkezéskor (vagy lejárt tokennél) a navigációs verem is újraindul.
      home: s.loggedIn ? const LobbyScreen(key: ValueKey('lobby')) : const LoginScreen(key: ValueKey('login')),
    );
  }
}
