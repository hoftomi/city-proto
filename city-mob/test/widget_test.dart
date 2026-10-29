import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/util/format.dart';

import 'helpers/l10n.dart';

// A simple check instead of the old default widget test.
void main() {
  setUpAll(loadTestTranslations);

  test('branch names', () {
    expect(branchName('trade'), 'Vásártér');
    expect(branchName('politics'), 'Városháza');
    expect(branchName('espionage'), 'Alvilág');
  });
}
