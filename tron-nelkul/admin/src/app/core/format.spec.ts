import { formatDate, formatDay, formatDuration, splitMinutes } from './format';
import { Translator } from './translator';

describe('format', () => {
  it('formats instants in Europe/Budapest', () => {
    // 22:30 UTC in summer = 00:30 next day in Budapest (UTC+2).
    expect(formatDate('2026-07-01T22:30:00Z')).toContain('07. 02.');
    expect(formatDate('2026-07-01T22:30:00Z')).toContain('00:30');
    expect(formatDate(null)).toBe('–');
  });

  it('formats calendar days without a time zone shift', () => {
    expect(formatDay('2026-10-29')).toBe('10. 29.');
  });

  it('splits minutes', () => {
    expect(splitMinutes(1590)).toEqual({ days: 1, hours: 2, minutes: 30 });
  });

  it('formats durations with translated units', () => {
    const t = { t: (k: string, p?: Record<string, unknown>) => `${p?.['n'] ?? ''}${k.split('.')[1][0]}` };
    expect(formatDuration(t as unknown as Translator, 1590)).toBe('+1d 2h 30m');
    expect(formatDuration(t as unknown as Translator, 0)).toBe('n');
  });
});
