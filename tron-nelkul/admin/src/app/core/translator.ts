import { Injectable, inject, signal } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { I18nService } from '../api';

/** Namespace of the admin texts (backend: resources/i18n/hu/admin.json). */
export const NAMESPACE = 'admin';

export type TParams = Record<string, string | number | null | undefined>;

/** Marks a string literal as a translation key (lets tools/check-i18n.mjs find keys outside t() calls). */
export function key<K extends string>(k: K): K {
  return k;
}

/** Replaces {name} placeholders. */
export function interpolate(text: string, params?: TParams): string {
  if (!params) return text;
  return text.replace(/\{(\w+)\}/g, (m, name: string) => {
    const v = params[name];
    return v === null || v === undefined ? m : String(v);
  });
}

/** Admin UI texts, loaded once at startup from GET /api/i18n/{lang}. Missing keys render as the key itself. */
@Injectable({ providedIn: 'root' })
export class Translator {
  private readonly i18nApi = inject(I18nService);
  private readonly texts = signal<Record<string, unknown>>({});

  /** Never rejects: without the backend the UI shows the keys. */
  async load(lang = 'hu'): Promise<void> {
    try {
      const all = await firstValueFrom(this.i18nApi.getTranslations(lang));
      this.set((all as Record<string, unknown>)[NAMESPACE]);
    } catch (e) {
      console.error('Cannot load translations', e);
    }
  }

  set(texts: unknown): void {
    this.texts.set(texts && typeof texts === 'object' ? (texts as Record<string, unknown>) : {});
  }

  /** Key relative to the admin namespace, e.g. t('nav.games'). */
  t(k: string, params?: TParams): string {
    let node: unknown = this.texts();
    for (const part of k.split('.')) {
      node = node && typeof node === 'object' ? (node as Record<string, unknown>)[part] : undefined;
    }
    return typeof node === 'string' ? interpolate(node, params) : k;
  }
}
