import { Component, input } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { HNumberPipe } from '../core/format';

@Component({
  selector: 'app-stat-card',
  imports: [MatCardModule, MatIconModule, HNumberPipe],
  template: `
    <mat-card appearance="outlined" class="stat">
      <mat-icon class="stat-icon">{{ icon() }}</mat-icon>
      <div>
        <div class="stat-value">{{ value() | hnum }}</div>
        <div class="stat-label">{{ label() }}</div>
        @if (hint()) {
          <div class="stat-hint">{{ hint() }}</div>
        }
      </div>
    </mat-card>
  `,
  styles: `
    .stat { display: flex; flex-direction: row; align-items: center; gap: 16px; padding: 16px; height: 100%; box-sizing: border-box; }
    .stat-icon { color: var(--mat-sys-primary); transform: scale(1.5); margin: 0 8px; }
    .stat-value { font: var(--mat-sys-headline-medium); }
    .stat-label { font: var(--mat-sys-body-medium); color: var(--mat-sys-on-surface-variant); }
    .stat-hint { font: var(--mat-sys-body-small); color: var(--mat-sys-on-surface-variant); }
  `,
})
export class StatCard {
  readonly icon = input('insights');
  readonly value = input.required<number | null>();
  /** Already translated. */
  readonly label = input.required<string>();
  readonly hint = input<string | null>(null);
}
