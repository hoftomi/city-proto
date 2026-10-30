import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/widgets/buttons.dart';
import 'package:tron_nelkul/widgets/game_widgets.dart';

import 'helpers/l10n.dart';

void main() {
  setUpAll(loadTestTranslations);

  List<Object> parts(String text) => [
        for (final s in unitSpans(text, const TextStyle(fontSize: 15)))
          if (s is TextSpan) s.text! else ((s as WidgetSpan).child as dynamic).name as Object,
      ];

  group('unitSpans', () {
    test('splits text runs and unit markers', () {
      expect(parts('Vétel · 1 [pp] · 15 [gold]'), ['Vétel · 1 ', 'pp', ' · 15 ', 'gold']);
      expect(parts('4 [gold] 3 [silver] 5 [bronze]'), ['4 ', 'gold', ' 3 ', 'silver', ' 5 ', 'bronze']);
      expect(parts('[legit]'), ['legit']);
      expect(parts('+2 [pop]'), ['+2 ', 'popularity']);
      expect(parts('nincs egység'), ['nincs egység']);
      expect(parts('[foo] marad'), ['[foo] marad']);
    });

    test('icons are baseline-aligned widget spans sized to the font', () {
      final spans = unitSpans('+3 [pop]', const TextStyle(fontSize: 15));
      final icon = spans.last as WidgetSpan;
      expect(icon.alignment, PlaceholderAlignment.baseline);
      expect(icon.baseline, TextBaseline.alphabetic);
    });

    test('upper-cases text runs only', () {
      final spans = unitSpans('Haszonkulcsod · 1 [pp]', null, upper: true);
      expect((spans.first as TextSpan).text, 'HASZONKULCSOD · 1 ');
      expect(spans.last, isA<WidgetSpan>());
    });
  });

  test('plain-text form uses the unit words', () {
    expect(hasUnits('10 [pp]'), isTrue);
    expect(hasUnits('10 PP'), isFalse);
    expect(unitPlain('10 [pp] · 30 [gold] · +2 [pop] · +1 [legit]'), '10 parancspont · 30 arany · +2 népszerűség · +1 legitimitás');
    expect(hasUnits('3 [silver]'), isTrue);
    expect(unitPlain('4 [gold] 3 [silver] 5 [bronze]'), '4 arany 3 ezüst 5 bronz');
  });

  testWidgets('UnitText shows icons and reads the words to screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UnitText('Vétel · 1 [pp] · 15 [gold]'))));
    expect(find.byType(GameIcon), findsNWidgets(2));
    expect(find.bySemanticsLabel('Vétel · 1 parancspont · 15 arany'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'\[')), findsNothing);
    handle.dispose();
  });

  testWidgets('TnButton label: icons inside, words in semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: TnButton(label: 'Program · 1 [pp]', onPressed: () {})))));
    expect(find.byType(GameIcon), findsOneWidget);
    expect(find.bySemanticsLabel('Program · 1 parancspont'), findsOneWidget);
    handle.dispose();
  });
}
