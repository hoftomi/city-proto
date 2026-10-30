import { Pipe, PipeTransform, inject } from '@angular/core';
import { Translator } from './translator';

/** {{ house.gold | coins }}: money in whole bronze as spelled-out coins. */
@Pipe({ name: 'coins' })
export class CoinsPipe implements PipeTransform {
  private readonly translator = inject(Translator);

  transform(bronze: number | null | undefined): string {
    return this.translator.coins(bronze);
  }
}
