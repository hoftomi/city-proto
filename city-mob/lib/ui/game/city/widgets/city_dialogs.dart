import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/tokens.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/game_widgets.dart';
import '../bloc/city_bloc.dart';

/// Megnyitja a CityBloc állapota szerinti párbeszédet; bezáráskor jelez a blocnak.
Future<void> showCityDialog(BuildContext context, Widget dialog) {
  final bloc = context.read<CityBloc>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(value: bloc, child: dialog),
  ).then((_) => bloc.isClosed ? null : bloc.add(const CityDialogClosed()));
}

/// Kém áthelyezése (7.1): egy szabad kém a hálózatod egy másik városába költözik, érlelés után.
class MoveSpyDialog extends StatelessWidget {
  const MoveSpyDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<CityBloc, CityState>(
        builder: (context, s) {
          final c = context.tn, max = s.rules.spiesPerCity;
          return SimpleDialog(
            title: Text('city.dialog.move_spy_title'.tr(), style: TnText.title(c.ink)),
            children: [
              if (s.spyDestinations.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('city.dialog.move_spy_none'.tr(), style: TnText.body(c.inkMuted)),
                ),
              for (final (t, full) in s.spyDestinations)
                SimpleDialogOption(
                  onPressed: full
                      ? null
                      : () {
                          context.read<CityBloc>().add(CityMoveSpyPicked(t.id));
                          Navigator.pop(context);
                        },
                  child: Text(
                    'city.dialog.move_spy_option'.tr(namedArgs: {'city': t.name, 'n': '${t.mySpies}', 'max': '$max'}),
                    style: TnText.body(full ? c.inkMuted : c.ink),
                  ),
                ),
            ],
          );
        },
      );
}

/// Információ eladása egy megnevezett háznak (0 PP, letéttel).
class IntelSaleDialog extends StatefulWidget {
  const IntelSaleDialog({super.key});

  @override
  State<IntelSaleDialog> createState() => _IntelSaleDialogState();
}

class _IntelSaleDialogState extends State<IntelSaleDialog> {
  late final TextEditingController _price = TextEditingController(text: context.read<CityBloc>().state.sale?.price ?? '');

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CityBloc, CityState>(
        builder: (context, s) {
          final c = context.tn, bloc = context.read<CityBloc>(), sale = s.sale;
          return AlertDialog(
            title: Text('city.dialog.sale_title'.tr(namedArgs: {'house': s.saleIntel?.of_.name ?? ''}), style: TnText.sheetTitle(c.ink)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TnSelect<String>(
                  label: 'city.dialog.buyer'.tr(),
                  value: sale?.buyer,
                  items: [for (final h in s.saleBuyers) (h.playerId, h.name)],
                  onChanged: (v) => bloc.add(CityIntelBuyerChanged(v)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => bloc.add(CityIntelPriceChanged(v)),
                  style: TnText.bodyStrong(c.ink).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(labelText: 'city.dialog.price'.tr(), suffixText: 'city.dialog.gold_suffix'.tr()),
                ),
                const SizedBox(height: 8),
                Text('city.dialog.sale_hint'.tr(), style: TnText.caption(c.inkMuted)),
              ],
            ),
            actions: [
              TnButton(label: 'common.cancel'.tr(), kind: TnButtonKind.quiet, small: true, onPressed: () => Navigator.of(context).pop()),
              TnButton(
                label: 'city.dialog.offer'.tr(),
                art: 'arany',
                kind: TnButtonKind.primary,
                small: true,
                onPressed: () {
                  bloc.add(const CityIntelSaleSubmitted());
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
