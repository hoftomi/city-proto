import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import '../auth/bloc/auth_bloc.dart';

/// Csak közösségi belépés: Google, Apple (iOS), Discord. A belépést az AuthBloc végzi; siker után a router
/// a játékválasztóra visz. A widget csak megjelenít és eseményt küld.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, s) => showToast(context, s.error!.text, tone: 'danger'),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, s) {
        void signIn(String p) => context.read<AuthBloc>().add(AuthSignInRequested(p));
        Widget social(String id, String mark, String label) =>
            _Social(mark: mark, label: label, busy: s.busyProvider == id, enabled: !s.busy, onTap: () => signIn(id));
        return Scaffold(
          body: TnScreen(
            child: SafeArea(
              top: false,
              child: ListView(padding: EdgeInsets.zero, children: [
                Container(
                  height: 340,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.frame, width: 3)),
                    boxShadow: [BoxShadow(color: c.outline, offset: const Offset(0, 1.5)), const BoxShadow(color: Color(0x80000000), offset: Offset(0, 6), blurRadius: 10, spreadRadius: -4)],
                  ),
                  child: ExcludeSemantics(child: SvgPicture.asset('assets/k4/login.svg', fit: BoxFit.cover, width: double.infinity, height: 340)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text('app.title'.tr(), textAlign: TextAlign.center, style: TnText.hero(c.ink)),
                    const SizedBox(height: 4),
                    Text('app.tagline'.tr(),
                        textAlign: TextAlign.center, style: TnText.bodyStrong(c.inkMuted).copyWith(fontSize: 16, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 24),
                    social('google', 'G', 'login.google'.tr()),
                    if (Config.appleAvailable) ...[const SizedBox(height: 12), social('apple', 'A', 'login.apple'.tr())],
                    const SizedBox(height: 12),
                    social('discord', 'D', 'login.discord'.tr()),
                    const SizedBox(height: 24),
                    Text('login.terms'.tr(), style: TnText.caption(c.inkMuted)),
                  ]),
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }
}

/// Közösségi belépés gombja: pergamen (quiet) gomb, balra igazított felirattal és viaszpecsét betűjellel.
class _Social extends StatelessWidget {
  const _Social({required this.mark, required this.label, required this.onTap, required this.busy, required this.enabled});
  final String mark, label;
  final VoidCallback onTap;
  final bool busy, enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    // Élesben a szolgáltatók hivatalos gombjai kellenek; a 0.0.1 semleges betűjelet használ.
    final seal = Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.outline),
        gradient: const RadialGradient(center: Alignment(-0.3, -0.4), colors: [Color(0xFFD06A57), Color(0xFF7D2518)]),
      ),
      child: Text(mark, style: TnText.title(const Color(0xFFFFF5DC)).copyWith(fontSize: 14, height: 1, fontWeight: FontWeight.w800)),
    );
    return TnButton(
      label: busy ? 'login.signing_in'.tr() : label,
      kind: TnButtonKind.quiet,
      alignStart: true,
      minHeight: 52,
      fontSize: 16,
      leading: seal,
      busy: busy,
      onPressed: enabled ? onTap : null,
    );
  }
}
