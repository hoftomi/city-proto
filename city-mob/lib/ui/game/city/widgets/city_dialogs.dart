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
  return showDialog<void>(context: context, builder: (_) => BlocProvider.value(value: bloc, child: dialog))
      .then((_) => bloc.isClosed ? null : bloc.add(const CityDialogClosed()));
}

/// Kém áthelyezése (7.1): egy szabad kém a hálózatod egy másik városába költözik, érlelés után.
class MoveSpyDialog extends StatelessWidget {
  const MoveSpyDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<CityBloc, CityState>(builder: (context, s) {
        final c = context.tn, max = s.rules.spiesPerCity;
        return SimpleDialog(
          title: Text('Hová költözzön a kém?', style: TnText.title(c.ink)),
          children: [
            if (s.spyDestinations.isEmpty)
              Padding(padding: const EdgeInsets.all(16), child: Text('Nincs más város a hálózatodban.', style: TnText.body(c.inkMuted))),
            for (final (t, full) in s.spyDestinations)
              SimpleDialogOption(
                onPressed: full
                    ? null
                    : () {
                        context.read<CityBloc>().add(CityMoveSpyPicked(t.id));
                        Navigator.pop(context);
                      },
                child: Text('${t.name} · kémeid ott: ${t.mySpies} / $max', style: TnText.body(full ? c.inkMuted : c.ink)),
              ),
          ],
        );
      });
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
  Widget build(BuildContext context) => BlocBuilder<CityBloc, CityState>(builder: (context, s) {
        final c = context.tn, bloc = context.read<CityBloc>(), sale = s.sale;
        return AlertDialog(
          title: Text('${s.saleIntel?.of_.name ?? ''} tervei', style: TnText.sheetTitle(c.ink)),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TnSelect<String>(
              label: 'Vevő',
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
              decoration: const InputDecoration(labelText: 'Ár (arany)', suffixText: 'A'),
            ),
            const SizedBox(height: 8),
            Text('A vevő elfogadáskor fizet, és azonnal megkapja a jelentést. 0 PP.', style: TnText.caption(c.inkMuted)),
          ]),
          actions: [
            TnButton(label: 'Mégse', kind: TnButtonKind.quiet, small: true, onPressed: () => Navigator.of(context).pop()),
            TnButton(
              label: 'Felkínálás',
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
      });
}
