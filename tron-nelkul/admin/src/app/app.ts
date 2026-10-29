import { Component, effect, inject } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { RouterOutlet } from '@angular/router';
import { Translator } from './core/translator';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  template: '<router-outlet />',
})
export class App {
  constructor() {
    const translator = inject(Translator);
    const title = inject(Title);
    effect(() => title.setTitle(translator.t('app.title')));
  }
}
