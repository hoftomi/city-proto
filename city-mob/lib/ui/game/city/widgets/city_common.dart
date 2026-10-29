import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tron_api/tron_api.dart';

import '../../../../theme/tokens.dart';
import '../../../../util/format.dart';
import '../../../../widgets/game_widgets.dart';

/// Shared, purely presentational pieces of the city view.

Widget gap([double h = 12]) => SizedBox(height: h);

Widget hint(BuildContext context, String t) => Text(t, style: TnText.caption(context.tn.inkMuted));

/// Time as "hh:mm", in local time.
String at(DateTime t) => hhmm(t);

Widget cardTitle(BuildContext context, String title, [String? aside, String? art]) {
  final c = context.tn;
  return Row(
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: ArtTitle(title, art: art),
        ),
      ),
      if (aside != null) Text(aside, style: TnText.data(c.ink)),
    ],
  );
}

/// A row with a bottom line: body and an optional button on the right.
class CityLine extends StatelessWidget {
  const CityLine({super.key, required this.body, this.action});
  final Widget body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.tn.lineStrong.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            Expanded(child: body),
            if (action != null) ...[const SizedBox(width: 8), action!],
          ],
        ),
      );
}

/// A spreading news item: text, author, time, and verify status.
class NewsRow extends StatelessWidget {
  const NewsRow({super.key, required this.n, this.action});
  final NewsView n;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final meta = [
      (n.mine ? 'city.news.by_me' : 'city.news.by').tr(namedArgs: {'name': n.author.name}),
      shortDateTime(n.createdAt),
      if (n.debunked) 'city.news.debunked'.tr(),
      if (n.verified == true) 'city.news.verified_true'.tr(),
      if (n.verified == false) 'city.news.verified_false'.tr(),
    ].join(' · ');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.lineStrong.withValues(alpha: 0.5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.text, style: TnText.chronicle(n.debunked ? c.inkMuted : c.ink).copyWith(decoration: n.debunked ? TextDecoration.lineThrough : null)),
                Text(meta, style: TnText.caption(n.debunked || n.verified == false ? c.danger : c.inkMuted)),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}
