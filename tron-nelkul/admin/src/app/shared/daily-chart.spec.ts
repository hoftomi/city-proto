import { TestBed } from '@angular/core/testing';
import { DailyChart, niceMax } from './daily-chart';

describe('niceMax', () => {
  it('rounds up to 1/2/5 steps', () => {
    expect(niceMax(0)).toBe(1);
    expect(niceMax(3)).toBe(5);
    expect(niceMax(7)).toBe(10);
    expect(niceMax(120)).toBe(200);
  });
});

describe('DailyChart', () => {
  it('renders one bar per non-zero day and a line path in line mode', async () => {
    const fixture = TestBed.createComponent(DailyChart);
    fixture.componentRef.setInput('data', [
      { label: 'a', value: 1 },
      { label: 'b', value: 0 },
      { label: 'c', value: 4 },
    ]);
    await fixture.whenStable();
    const el = fixture.nativeElement as HTMLElement;
    expect([...el.querySelectorAll('path.bar')].filter((p) => p.getAttribute('d')).length).toBe(2);

    fixture.componentRef.setInput('type', 'line');
    await fixture.whenStable();
    expect(el.querySelector('path.line')?.getAttribute('d')).toMatch(/^M[\d.]+,[\d.]+ L/);
  });
});
