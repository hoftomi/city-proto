import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { Title } from '@angular/platform-browser';
import { App } from './app';
import { Translator } from './core/translator';

describe('App', () => {
  it('sets the document title from the translations', async () => {
    TestBed.configureTestingModule({ imports: [App], providers: [provideRouter([]), provideHttpClient()] });
    TestBed.inject(Translator).set({ app: { title: 'Admin title' } });
    const fixture = TestBed.createComponent(App);
    await fixture.whenStable();
    expect(TestBed.inject(Title).getTitle()).toBe('Admin title');
  });
});
