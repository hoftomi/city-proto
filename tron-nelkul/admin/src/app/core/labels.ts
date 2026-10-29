import { key } from './translator';

/** AdminGame.status values. */
export const GAME_STATUSES = ['announced', 'open', 'running', 'finished'] as const;
export type GameStatus = (typeof GAME_STATUSES)[number];

export const STATUS_KEYS: Record<string, string> = {
  announced: key('status.announced'),
  open: key('status.open'),
  running: key('status.running'),
  finished: key('status.finished'),
};

/** AdminReport.kind values (unknown kinds show as is). */
export const REPORT_KIND_KEYS: Record<string, string> = {
  spy: key('reportKind.spy'),
  military: key('reportKind.military'),
  faction: key('reportKind.faction'),
  diplomacy: key('reportKind.diplomacy'),
  event: key('reportKind.event'),
};

export const CONFIDENCE_KEYS: Record<string, string> = {
  weak: key('confidence.weak'),
  medium: key('confidence.medium'),
  strong: key('confidence.strong'),
};

export const ROLE_KEYS: Record<string, string> = {
  PLAYER: key('role.PLAYER'),
  ADMIN: key('role.ADMIN'),
};

export const isLive = (status: string) => status !== 'finished';
export const canStart = (status: string) => status === 'announced' || status === 'open';
export const isRunning = (status: string) => status === 'running';

/** House tinctures (Backgrounds.TINCTURES) → swatch colour and label key. */
export const TINCTURES: Record<string, { color: string; label: string }> = {
  red: { color: '#c62828', label: key('tincture.red') },
  blue: { color: '#1565c0', label: key('tincture.blue') },
  green: { color: '#2e7d32', label: key('tincture.green') },
  gold: { color: '#f9a825', label: key('tincture.gold') },
  purple: { color: '#6a1b9a', label: key('tincture.purple') },
  black: { color: '#212121', label: key('tincture.black') },
  orange: { color: '#ef6c00', label: key('tincture.orange') },
  mulberry: { color: '#880e4f', label: key('tincture.mulberry') },
};
