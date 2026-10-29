import { Component, computed, input, signal } from '@angular/core';

export interface ChartPoint {
  /** Axis / tooltip label, already formatted. */
  label: string;
  value: number;
}

export type ChartType = 'bar' | 'line';

const W = 640;
const H = 220;
const PAD = { top: 12, right: 12, bottom: 28, left: 36 };

/** Rounds the axis maximum up to 1/2/5 × 10^n. */
export function niceMax(max: number): number {
  if (max <= 0) return 1;
  const pow = Math.pow(10, Math.floor(Math.log10(max)));
  const step = [1, 2, 5, 10].find((s) => s * pow >= max) ?? 10;
  return step * pow;
}

/** Small single-series SVG chart (daily counts): bar or line, hover tooltip, recessive grid. */
@Component({
  selector: 'app-daily-chart',
  template: `
    <div class="chart" (mouseleave)="hover.set(null)">
      <svg [attr.viewBox]="'0 0 ' + W + ' ' + H" role="img" [attr.aria-label]="ariaLabel()">
        @for (tick of ticks(); track tick.value) {
          <line class="grid" [attr.x1]="PAD.left" [attr.x2]="W - PAD.right" [attr.y1]="tick.y" [attr.y2]="tick.y" />
          <text class="axis" [attr.x]="PAD.left - 6" [attr.y]="tick.y + 4" text-anchor="end">{{ tick.value }}</text>
        }
        @for (p of points(); track $index) {
          @if (p.showLabel) {
            <text class="axis" [attr.x]="p.x" [attr.y]="H - 8" text-anchor="middle">{{ p.label }}</text>
          }
        }
        @if (type() === 'bar') {
          @for (p of points(); track $index) {
            <path class="bar" [class.dim]="hover() !== null && hover() !== $index" [attr.d]="p.bar" />
          }
        } @else {
          <path class="line" [attr.d]="linePath()" />
          @if (hover() !== null) {
            <line class="cross" [attr.x1]="points()[hover()!].x" [attr.x2]="points()[hover()!].x" [attr.y1]="PAD.top" [attr.y2]="H - PAD.bottom" />
            <circle class="dot" [attr.cx]="points()[hover()!].x" [attr.cy]="points()[hover()!].y" r="5" />
          }
        }
        @for (p of points(); track $index) {
          <rect class="hit" [attr.x]="p.x - slot() / 2" [attr.y]="PAD.top" [attr.width]="slot()" [attr.height]="H - PAD.top - PAD.bottom" (mouseenter)="hover.set($index)">
            <title>{{ p.label }}: {{ p.value }}</title>
          </rect>
        }
      </svg>
      @if (hover() !== null) {
        <div class="tip" [style.left.%]="(points()[hover()!].x / W) * 100">
          <span class="tip-label">{{ points()[hover()!].label }}</span>
          <strong>{{ points()[hover()!].value }}</strong>
        </div>
      }
    </div>
  `,
  styles: `
    :host { display: block; }
    .chart { position: relative; }
    svg { width: 100%; height: auto; display: block; overflow: visible; }
    .grid { stroke: var(--mat-sys-outline-variant); stroke-width: 1; }
    .axis { fill: var(--mat-sys-on-surface-variant); font: 11px var(--mat-sys-body-small-font, sans-serif); }
    .bar { fill: var(--mat-sys-primary); transition: opacity 120ms; }
    .bar.dim { opacity: 0.45; }
    .line { fill: none; stroke: var(--mat-sys-primary); stroke-width: 2; stroke-linejoin: round; stroke-linecap: round; }
    .cross { stroke: var(--mat-sys-outline); stroke-width: 1; stroke-dasharray: 3 3; }
    .dot { fill: var(--mat-sys-primary); stroke: var(--mat-sys-surface); stroke-width: 2; }
    .hit { fill: transparent; }
    .tip {
      position: absolute; top: 0; transform: translateX(-50%); pointer-events: none; white-space: nowrap;
      background: var(--mat-sys-inverse-surface); color: var(--mat-sys-inverse-on-surface);
      border-radius: 6px; padding: 4px 8px; font: var(--mat-sys-body-small); display: flex; gap: 8px;
    }
  `,
})
export class DailyChart {
  readonly data = input.required<ChartPoint[]>();
  readonly type = input<ChartType>('bar');
  readonly ariaLabel = input('');

  protected readonly W = W;
  protected readonly H = H;
  protected readonly PAD = PAD;
  protected readonly hover = signal<number | null>(null);

  protected readonly max = computed(() => niceMax(Math.max(0, ...this.data().map((d) => d.value))));
  protected readonly slot = computed(() => (W - PAD.left - PAD.right) / Math.max(1, this.data().length));

  protected readonly ticks = computed(() => {
    const max = this.max();
    const steps = max < 4 ? max : 4;
    return Array.from({ length: steps + 1 }, (_, i) => {
      const value = Math.round((max / steps) * i * 100) / 100;
      return { value, y: this.y(value) };
    });
  });

  protected readonly points = computed(() => {
    const data = this.data();
    const slot = this.slot();
    const every = Math.ceil(data.length / 8);
    const barW = Math.max(2, Math.min(28, slot * 0.6));
    const base = H - PAD.bottom;
    return data.map((d, i) => {
      const x = PAD.left + slot * (i + 0.5);
      const y = this.y(d.value);
      const r = Math.min(4, barW / 2, base - y);
      const left = x - barW / 2;
      // Rounded data end, square at the baseline.
      const bar =
        d.value > 0
          ? `M${left},${base} V${y + r} Q${left},${y} ${left + r},${y} H${left + barW - r} Q${left + barW},${y} ${left + barW},${y + r} V${base} Z`
          : '';
      return { ...d, x, y, bar, showLabel: (data.length - 1 - i) % every === 0 };
    });
  });

  protected readonly linePath = computed(() =>
    this.points()
      .map((p, i) => `${i ? 'L' : 'M'}${p.x},${p.y}`)
      .join(' '),
  );

  private y(value: number): number {
    return PAD.top + (H - PAD.top - PAD.bottom) * (1 - value / this.max());
  }
}
