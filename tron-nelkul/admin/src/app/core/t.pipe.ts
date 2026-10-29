import { Pipe, PipeTransform, inject } from '@angular/core';
import { TParams, Translator } from './translator';

/** {{ 'nav.games' | t }} or {{ 'games.npc_count' | t: { n: 3 } }} */
@Pipe({ name: 't' })
export class TPipe implements PipeTransform {
  private readonly translator = inject(Translator);

  transform(k: string, params?: TParams): string {
    return this.translator.t(k, params);
  }
}
