import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tron_api/tron_api.dart';

import '../../../domain/model/lobby_extensions.dart';
import '../../../theme/tokens.dart';
import '../../../widgets/game_widgets.dart';

/// A játék állapotcímkéje (a GameSummaryLobbyX.badge alapján).
class StatusChip extends StatelessWidget {
  const StatusChip(this.g, {super.key});
  final GameSummary g;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return switch (g.badge) {
      GameBadge.joined => TnChip(label: 'lobby.badge.joined'.tr(), icon: 'check', fg: c.onBtn, bg: c.btnGreen, border: c.outline),
      GameBadge.almostFull => TnChip(label: 'lobby.badge.almost_full'.tr(), fg: c.ink, bg: c.btnGold),
      GameBadge.runningJoinable => TnChip(label: 'lobby.badge.running_joinable'.tr(), fg: c.onBtn, bg: c.btnGreen, border: c.outline),
      GameBadge.running => TnChip(label: 'lobby.badge.running'.tr(), fg: c.onBtn, bg: c.btnGreen, border: c.outline),
      GameBadge.open => TnChip(label: 'lobby.badge.open'.tr(), fg: c.onBtn, bg: c.btnBlue, border: c.outline),
      GameBadge.soon => TnChip(label: 'lobby.badge.soon'.tr(), fg: c.inkMuted),
      GameBadge.finished => TnChip(label: 'lobby.badge.finished'.tr(), fg: c.inkMuted, bg: c.hollow),
    };
  }
}

/// Címke a játék jellemzőihez.
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(color: c.field, borderRadius: BorderRadius.circular(TnRadius.xs), border: Border.all(color: c.lineStrong)),
      child: Text(text, style: TnText.data(c.inkMuted, size: 12).copyWith(height: 18 / 12)),
    );
  }
}
