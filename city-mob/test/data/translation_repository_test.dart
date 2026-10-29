import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/data/datasource/local/translation_local_datasource.dart';
import 'package:tron_nelkul/data/datasource/remote/translation_remote_datasource.dart';
import 'package:tron_nelkul/data/repository/translation_repository.dart';

class _Remote extends Mock implements TranslationRemoteDataSource {}

class _Local extends Mock implements TranslationLocalDataSource {}

void main() {
  late _Remote remote;
  late _Local local;
  late TranslationRepository repo;
  const hu = Locale('hu');

  setUp(() {
    remote = _Remote();
    local = _Local();
    repo = TranslationRepository(remote, local);
    when(() => local.bundled('assets/translations', 'hu')).thenAnswer((_) async => {
          'common': {'retry': 'Újra (tartalék)', 'back': 'Vissza'},
        });
    when(() => local.store(any(), any())).thenAnswer((_) async {});
  });

  test('server label wins, missing key comes from the fallback, and it is stored', () async {
    when(() => remote.translations('hu')).thenAnswer((_) async => {'common': {'retry': 'Újra'}, 'lobby': {'title': 'Játékok'}});
    final t = await repo.load('assets/translations', hu);
    expect(t, {'common': {'retry': 'Újra', 'back': 'Vissza'}, 'lobby': {'title': 'Játékok'}});
    verify(() => local.store('hu', any())).called(1);
  });

  test('without server: the last stored labels', () async {
    when(() => remote.translations('hu')).thenThrow(Exception('offline'));
    when(() => local.cached('hu')).thenAnswer((_) async => {'common': {'retry': 'Újra (mentett)'}});
    final t = await repo.load('assets/translations', hu);
    expect((t!['common'] as Map)['retry'], 'Újra (mentett)');
  });

  test('first launch without network: the app fallback', () async {
    when(() => remote.translations('hu')).thenThrow(Exception('offline'));
    when(() => local.cached('hu')).thenAnswer((_) async => null);
    final t = await repo.load('assets/translations', hu);
    expect((t!['common'] as Map)['retry'], 'Újra (tartalék)');
  });
}
