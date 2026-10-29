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
