import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/widgets/game_icon.dart';

void main() {
  test('minden játékikonhoz van SVG', () {
    for (final n in kGameIcons) {
      expect(File('assets/k4/icons/$n.svg').existsSync(), isTrue, reason: n);
    }
  });

  test('az akciók ága és az API ágnevei', () {
    expect(kActionBranch['hireSpy'], 'alvilag');
    expect(branchKey('keresk'), 'vasarter');
    expect(branchKey('polit'), 'varoshaza');
    expect(branchKey('kem'), 'alvilag');
    expect(branchKey(null), 'kozos');
    expect(gameArtFor('varos'), 'navVaros');
    expect(gameArtFor('kereskedok'), isNull);
  });
}
