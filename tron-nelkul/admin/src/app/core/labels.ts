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
