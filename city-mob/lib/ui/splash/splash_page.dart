import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../widgets/game_widgets.dart';

/// Induláskor, amíg az AuthBloc visszaállítja a mentett munkamenetet.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Scaffold(
      body: TnScreen(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('app.title'.tr(), style: TnText.hero(c.ink)),
            const SizedBox(height: 16),
            SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: c.frame)),
          ]),
        ),
      ),
    );
  }
}
