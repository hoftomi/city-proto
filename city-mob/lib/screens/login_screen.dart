import 'package:flutter/material.dart';

import '../app_state.dart';
import '../auth/social_auth.dart';
import '../config.dart';
import '../theme/tokens.dart';
import '../widgets/buttons.dart';
import '../widgets/game_widgets.dart';
import '../widgets/login_art.dart';

/// Csak közösségi belépés: Google, Apple (iOS), Discord. Fejlesztéshez: szolgáltató nélküli belépés.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? busy;
  final _devName = TextEditingController(text: 'Vándor');

  Future<void> _run(String id, Future<void> Function() f) async {
    setState(() => busy = id);
    try {
      await f();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(padding: EdgeInsets.zero, children: [
          const SizedBox(height: 300, child: LoginArt()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Trón nélkül', style: TnText.display(c.ink).copyWith(fontSize: 52, height: 1)),
              const SizedBox(height: 8),
              Text('Nem városokat foglalsz. Befolyást építesz bennük.', style: TnText.body(c.inkMuted).copyWith(fontSize: 16)),
              const SizedBox(height: 24),
              _Social(mark: 'G', label: 'Folytatás Google-fiókkal', busy: busy == 'google', enabled: busy == null,
                  onTap: () => _run('google', socialAuth.google)),
              if (SocialAuth.appleAvailable) ...[
                const SizedBox(height: 12),
                _Social(mark: 'A', label: 'Folytatás Apple-fiókkal', busy: busy == 'apple', enabled: busy == null,
                    onTap: () => _run('apple', socialAuth.apple)),
              ],
              const SizedBox(height: 12),
              _Social(mark: 'D', label: 'Folytatás Discord-fiókkal', busy: busy == 'discord', enabled: busy == null,
                  onTap: () => _run('discord', socialAuth.discord)),
              const SizedBox(height: 16),
              Text('Nincs külön jelszó: a fiókodat a választott szolgáltatón keresztül azonosítjuk. '
                  'A folytatással elfogadod a Felhasználási feltételeket és az Adatvédelmi tájékoztatót.', style: TnText.caption(c.inkMuted)),
              if (Config.devLogin) ...[
                const SizedBox(height: 24),
                TnCard(
                  borderColor: c.lineStrong,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Eyebrow('Fejlesztői belépés'),
                    const SizedBox(height: 8),
                    TextField(controller: _devName, decoration: const InputDecoration(labelText: 'Név', border: OutlineInputBorder())),
                    const SizedBox(height: 8),
                    TnButton(label: 'Belépés szolgáltató nélkül', busy: busy == 'dev', onPressed: busy == null ? () => _run('dev', () => api.loginDev(_devName.text)) : null),
                  ]),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Social extends StatelessWidget {
  const _Social({required this.mark, required this.label, required this.onTap, required this.busy, required this.enabled});
  final String mark, label;
  final VoidCallback onTap;
  final bool busy, enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Material(
      color: c.paperRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TnRadius.sm), side: BorderSide(color: c.lineStrong)),
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: SizedBox(
          height: 52,
          child: Row(children: [
            const SizedBox(width: 12),
            // Élesben a szolgáltatók hivatalos gombjai kellenek; a 0.0.1 semleges betűjelet használ.
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.ink, shape: BoxShape.circle),
              child: Text(mark, style: TnText.bodyStrong(c.onInk).copyWith(fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(busy ? 'Belépés…' : label, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 16))),
            if (busy) Padding(padding: const EdgeInsets.only(right: 16), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: c.ink))),
          ]),
        ),
      ),
    );
  }
}
