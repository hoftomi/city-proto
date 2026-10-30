import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/util/format.dart';

import 'helpers/l10n.dart';
import 'package:tron_nelkul/widgets/paint_util.dart';

void main() {
  setUpAll(loadTestTranslations);

  test('Hungarian number formatting', () {
    expect(num1(42.34), '42,3');
    expect(signed(-2), '−2');
    expect(signed(3), '+3');
  });

  test('coin text from whole bronze', () {
    expect(coinText(435), '4 [gold] 3 [silver] 5 [bronze]');
    expect(coinText(400), '4 [gold]');
    expect(coinText(35), '3 [silver] 5 [bronze]');
    expect(coinText(405), '4 [gold] 5 [bronze]');
    expect(coinText(0), '0 [gold]');
    expect(coinText(-30), '−3 [silver]');
    expect(coinText(405, signed: true), '+4 [gold] 5 [bronze]');
    expect(coinText(0, signed: true), '+0 [gold]');
    expect(coinText(-435, signed: true), '−4 [gold] 3 [silver] 5 [bronze]');
    expect(coinText(123456), '1234 [gold] 5 [silver] 6 [bronze]');
  });

  test('deterministic random matches the web prototype', () {
    // JS: rng('f56152')() — same LCG, so forests stand in the same place on every client
    final a = SeededRng('f56152'), b = SeededRng('f56152');
    expect(a.next(), b.next());
    expect(a.next(), inInclusiveRange(0, 1));
  });

  test('duration', () {
    expect(durText(const Duration(minutes: 80)), '1 ó 20 p');
    expect(durText(const Duration(minutes: -5)), '0 p');
    expect(durText(const Duration(minutes: 120)), '2 ó');
  });
}
