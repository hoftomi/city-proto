import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { finalize } from 'rxjs';
import { AdminOverview, AdminService, DailyCount } from '../../api';
import { formatDay } from '../../core/format';
import { Notifier } from '../../core/notifier';
import { TPipe } from '../../core/t.pipe';
import { ChartPoint, DailyChart } from '../../shared/daily-chart';
import { StatCard } from '../../shared/stat-card';

const toPoints = (days: DailyCount[]): ChartPoint[] =>
  days.map((d) => ({ label: formatDay(d.date), value: d.count }));

@Component({
  selector: 'app-dashboard',
  imports: [MatButtonModule, MatCardModule, MatIconModule, MatProgressBarModule, TPipe, StatCard, DailyChart],
  template: `
    <div class="page-header">
      <h1>{{ 'dashboard.title' | t }}</h1>
      <button mat-stroked-button (click)="load()" [disabled]="loading()">
        <mat-icon>refresh</mat-icon>
        {{ 'common.refresh' | t }}
      </button>
    </div>
    @if (loading()) {
      <mat-progress-bar mode="indeterminate" />
    }
    @if (overview(); as o) {
      <div class="stat-grid">
        <app-stat-card icon="group" [value]="o.users" [label]="'dashboard.users' | t" />
        <app-stat-card icon="admin_panel_settings" [value]="o.admins" [label]="'dashboard.admins' | t" />
        <app-stat-card icon="person_add" [value]="o.newUsers7d" [label]="'dashboard.new_users_7d' | t" />
        <app-stat-card icon="campaign" [value]="o.announced" [label]="'status.announced' | t" [hint]="'dashboard.games' | t" />
        <app-stat-card icon="how_to_reg" [value]="o.open" [label]="'status.open' | t" [hint]="'dashboard.games' | t" />
        <app-stat-card icon="play_circle" [value]="o.running" [label]="'status.running' | t" [hint]="'dashboard.games' | t" />
        <app-stat-card icon="inventory_2" [value]="o.finished" [label]="'status.finished' | t" [hint]="'dashboard.games' | t" />
        <app-stat-card icon="person" [value]="o.humanHouses" [label]="'dashboard.human_houses' | t" [hint]="'dashboard.live_games' | t" />
        <app-stat-card icon="smart_toy" [value]="o.npcHouses" [label]="'dashboard.npc_houses' | t" [hint]="'dashboard.live_games' | t" />
        <app-stat-card icon="description" [value]="o.reports24h" [label]="'dashboard.reports_24h' | t" />
      </div>
      <div class="chart-grid">
        <mat-card appearance="outlined">
          <mat-card-header>
            <mat-card-title>{{ 'dashboard.registrations' | t }}</mat-card-title>
            <mat-card-subtitle>{{ 'dashboard.last_14_days' | t: { total: total(o.registrations) } }}</mat-card-subtitle>
          </mat-card-header>
          <mat-card-content>
            <app-daily-chart type="bar" [data]="registrations()" [ariaLabel]="'dashboard.registrations' | t" />
          </mat-card-content>
        </mat-card>
        <mat-card appearance="outlined">
          <mat-card-header>
            <mat-card-title>{{ 'dashboard.joins' | t }}</mat-card-title>
            <mat-card-subtitle>{{ 'dashboard.last_14_days' | t: { total: total(o.joins) } }}</mat-card-subtitle>
          </mat-card-header>
          <mat-card-content>
            <app-daily-chart type="line" [data]="joins()" [ariaLabel]="'dashboard.joins' | t" />
          </mat-card-content>
        </mat-card>
      </div>
    }
  `,
  styles: `
    .stat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px; }
    .chart-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(380px, 1fr)); gap: 16px; }
    mat-card-content { padding-top: 16px; }
  `,
})
export class Dashboard implements OnInit {
  private readonly adminApi = inject(AdminService);
  private readonly notifier = inject(Notifier);

  protected readonly loading = signal(false);
  protected readonly overview = signal<AdminOverview | null>(null);
  protected readonly registrations = computed(() => toPoints(this.overview()?.registrations ?? []));
  protected readonly joins = computed(() => toPoints(this.overview()?.joins ?? []));

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.adminApi
      .adminOverview()
      .pipe(finalize(() => this.loading.set(false)))
      .subscribe({ next: (o) => this.overview.set(o), error: (e) => this.notifier.error(e) });
  }

  protected total(days: DailyCount[]): number {
    return days.reduce((s, d) => s + d.count, 0);
  }
}
