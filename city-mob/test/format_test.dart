import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/util/format.dart';
import 'package:tron_nelkul/widgets/paint_util.dart';

void main() {
  test('magyar számformázás', () {
    expect(num1(42.34), '42,3');
    expect(signed(-2), '−2');
    expect(signed(3), '+3');
  });

  test('a determinisztikus véletlen megegyezik a web prototípussal', () {
    // JS: rng('f56152')() — ugyanaz az LCG, ezért az erdők ugyanott állnak minden kliensen
    final a = SeededRng('f56152'), b = SeededRng('f56152');
    expect(a.next(), b.next());
    expect(a.next(), inInclusiveRange(0, 1));
  });

  test('időtartam', () {
    expect(durText(const Duration(minutes: 80)), '1 ó 20 p');
    expect(durText(const Duration(minutes: -5)), '0 p');
    expect(durText(const Duration(minutes: 120)), '2 ó');
  });
}
