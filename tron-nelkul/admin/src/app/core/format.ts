import { Pipe, PipeTransform, inject } from '@angular/core';
import { Translator } from './translator';

const TIME_ZONE = 'Europe/Budapest';
const LOCALE = 'hu-HU';

const dateTime = new Intl.DateTimeFormat(LOCALE, {
  timeZone: TIME_ZONE,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
});
const dateOnly = new Intl.DateTimeFormat(LOCALE, {
  timeZone: TIME_ZONE,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
});
const dayMonth = new Intl.DateTimeFormat(LOCALE, { timeZone: 'UTC', month: '2-digit', day: '2-digit' });
const number = new Intl.NumberFormat(LOCALE, { maximumFractionDigits: 1 });

export type DateStyle = 'datetime' | 'date';

/** ISO timestamp → Hungarian date (Europe/Budapest); '–' for null. */
export function formatDate(iso: string | null | undefined, style: DateStyle = 'datetime'): string {
  if (!iso) return '–';
  const d = new Date(iso);
  if (isNaN(d.getTime())) return iso;
  return (style === 'date' ? dateOnly : dateTime).format(d);
}

/** Calendar date 'YYYY-MM-DD' → 'MM. DD.' (no time zone shift). */
export function formatDay(day: string): string {
  const d = new Date(day + 'T00:00:00Z');
  return isNaN(d.getTime()) ? day : dayMonth.format(d);
}

export function formatNumber(n: number | null | undefined): string {
  return n === null || n === undefined ? '–' : number.format(n);
}

/** Minutes split into days / hours / minutes. */
export function splitMinutes(total: number): { days: number; hours: number; minutes: number } {
  const abs = Math.abs(total);
  return { days: Math.floor(abs / 1440), hours: Math.floor((abs % 1440) / 60), minutes: abs % 60 };
}

@Pipe({ name: 'hdate' })
export class HDatePipe implements PipeTransform {
  transform(iso: string | null | undefined, style: DateStyle = 'datetime'): string {
    return formatDate(iso, style);
  }
}

@Pipe({ name: 'hnum' })
export class HNumberPipe implements PipeTransform {
  transform(n: number | null | undefined): string {
    return formatNumber(n);
  }
}

/** Minutes → '+1 day 2 h 30 min' style text (unit texts from admin.json). */
export function formatDuration(translator: Translator, total: number | null | undefined): string {
  if (!total) return translator.t('duration.none');
  const { days, hours, minutes } = splitMinutes(total);
  const parts: string[] = [];
  if (days) parts.push(translator.t('duration.days', { n: days }));
  if (hours) parts.push(translator.t('duration.hours', { n: hours }));
  if (minutes) parts.push(translator.t('duration.minutes', { n: minutes }));
  return (total < 0 ? '−' : '+') + parts.join(' ');
}

@Pipe({ name: 'duration' })
export class DurationPipe implements PipeTransform {
  private readonly translator = inject(Translator);

  transform(total: number | null | undefined): string {
    return formatDuration(this.translator, total);
  }
}
