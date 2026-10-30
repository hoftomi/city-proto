import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideApi } from '../api';
import { Translator, interpolate } from './translator';

describe('interpolate', () => {
  it('replaces known placeholders and keeps unknown ones', () => {
    expect(interpolate('{a} and {b}', { a: 1 })).toBe('1 and {b}');
    expect(interpolate('plain')).toBe('plain');
  });
});

describe('Translator', () => {
  let translator: Translator;
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting(), provideApi('')],
    });
    translator = TestBed.inject(Translator);
    http = TestBed.inject(HttpTestingController);
  });

  it('loads the admin namespace and resolves nested keys', async () => {
    const done = translator.load('hu');
    http.expectOne('/api/i18n/hu').flush({ admin: { games: { npc_count: '+ {n} NPC' } }, lobby: { x: 'y' } });
    await done;
    expect(translator.t('games.npc_count', { n: 3 })).toBe('+ 3 NPC');
  });

  it('falls back to the key when missing or when loading fails', async () => {
    const done = translator.load('hu');
    http.expectOne('/api/i18n/hu').flush('down', { status: 502, statusText: 'Bad Gateway' });
    await done;
    expect(translator.t('nav.games')).toBe('nav.games');
  });

  it('spells out the unit markers of server texts', () => {
    translator.set({ unit: { pp: 'PP', gold: 'arany', pop: 'népszerűség', legit: 'Legitimitás' } });
    expect(translator.units('+3 [pp], 12 [gold], -2 [pop], +1 [legit]')).toBe('+3 PP, 12 arany, -2 népszerűség, +1 Legitimitás');
    expect(translator.units('no markers [x]')).toBe('no markers [x]');
    expect(translator.units(null)).toBe('');
  });

  it('spells out money in whole bronze as coins', () => {
    translator.set({ unit: { gold: 'arany', silver: 'ezüst', bronze: 'bronz' } });
    expect(translator.coins(435)).toBe('4 arany 3 ezüst 5 bronz');
    expect(translator.coins(400)).toBe('4 arany');
    expect(translator.coins(35)).toBe('3 ezüst 5 bronz');
    expect(translator.coins(405)).toBe('4 arany 5 bronz');
    expect(translator.coins(0)).toBe('0 arany');
    expect(translator.coins(-30)).toBe('\u22123 ezüst');
    expect(translator.coins(null)).toBe('–');
  });
});
