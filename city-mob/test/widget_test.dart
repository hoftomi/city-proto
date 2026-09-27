import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/util/format.dart';

import 'helpers/l10n.dart';

// A régi, alapértelmezett widget-teszt helyett egy egyszerű ellenőrzés.
void main() {
  setUpAll(loadTestTranslations);

  test('ágnevek', () {
    expect(branchName('keresk'), 'Vásártér');
    expect(branchName('polit'), 'Városháza');
    expect(branchName('kem'), 'Alvilág');
  });
}
