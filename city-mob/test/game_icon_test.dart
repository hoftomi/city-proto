import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/widgets/game_icon.dart';

void main() {
  test('every game icon has an SVG', () {
    for (final n in kGameIcons) {
      expect(File('assets/k4/icons/$n.svg').existsSync(), isTrue, reason: n);
    }
  });

  test('action branches and API branch names', () {
    expect(kActionBranch['hireSpy'], 'espionage');
    expect(branchKey('trade'), 'trade');
    expect(branchKey('townHall'), 'politics');
    expect(branchKey('espionage'), 'espionage');
    expect(branchKey(null), 'common');
    expect(gameArtFor('city'), 'navCity');
    expect(gameArtFor('merchants'), isNull);
  });
}
