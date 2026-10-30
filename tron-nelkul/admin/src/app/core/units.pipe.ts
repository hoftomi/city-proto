import { Pipe, PipeTransform, inject } from '@angular/core';
import { Translator } from './translator';

/** {{ report.body | units }}: spells out the unit markers of a server text. */
@Pipe({ name: 'units' })
export class UnitsPipe implements PipeTransform {
  private readonly translator = inject(Translator);

  transform(text: string | null | undefined): string {
    return this.translator.units(text);
  }
}
