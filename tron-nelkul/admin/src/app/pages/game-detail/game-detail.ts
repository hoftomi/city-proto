import { Component, computed, effect, inject, input, signal, untracked } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatChipsModule } from '@angular/material/chips';
import { MatDialog } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSelectModule } from '@angular/material/select';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { Observable, filter, finalize } from 'rxjs';
import { AdminGame, AdminGameDetail, AdminHouse, AdminReport, AdminService } from '../../api';
import { DurationPipe, HDatePipe, HNumberPipe } from '../../core/format';
import { CONFIDENCE_KEYS, REPORT_KIND_KEYS, canStart, isRunning } from '../../core/labels';
import { Notifier } from '../../core/notifier';
import { TPipe } from '../../core/t.pipe';
import { UnitsPipe } from '../../core/units.pipe';
import { CoinsPipe } from '../../core/coins.pipe';
import { key } from '../../core/translator';
import { StatusChip } from '../../shared/status-chip';
import { GameActions } from '../games/game-actions';
import { AdvanceDialog } from './advance-dialog';

export const REPORT_LIMITS = [50, 100, 200, 500];
const ALL_KINDS = '';

/** Quick advance steps in minutes. */
const ADVANCE_STEPS = [
  { minutes: 30, label: key('advance.min30') },
  { minutes: 120, label: key('advance.h2') },
  { minutes: 1440, label: key('advance.d1') },
] as const;

@Component({
  selector: 'app-game-detail',
  imports: [
    RouterLink, MatButtonModule, MatCardModule, MatChipsModule, MatDividerModule, MatFormFieldModule,
    MatIconModule, MatMenuModule, MatProgressBarModule, MatSelectModule, MatTableModule, MatTooltipModule,
    TPipe, UnitsPipe, CoinsPipe, HDatePipe, HNumberPipe, DurationPipe, StatusChip,
  ],
  template: `
    <a mat-button routerLink="/games" class="back">
      <mat-icon>arrow_back</mat-icon>
      {{ 'detail.back' | t }}
    </a>
    @if (loading()) {
      <mat-progress-bar mode="indeterminate" />
    }
    @if (detail(); as d) {
      <div class="page-header">
        <div>
          <h1>
            {{ d.game.name }}
            <app-status-chip [status]="d.game.status" />
          </h1>
          <div class="muted">{{ d.game.id }} · {{ d.game.mapName }} · {{ d.game.mode }}</div>
        </div>
        <div class="actions">
          <button mat-stroked-button (click)="load()" [disabled]="loading()">
            <mat-icon>refresh</mat-icon>
            {{ 'common.refresh' | t }}
          </button>
          @if (canStart(d.game.status)) {
            <button mat-flat-button (click)="act(actions.start(d.game))">
              <mat-icon>play_arrow</mat-icon>
              {{ 'actions.start' | t }}
            </button>
          }
          @if (isRunning(d.game.status)) {
            <button mat-stroked-button (click)="act(actions.settle(d.game))">
              <mat-icon>gavel</mat-icon>
              {{ 'actions.settle' | t }}
            </button>
            <button mat-stroked-button [matMenuTriggerFor]="advanceMenu">
              <mat-icon>fast_forward</mat-icon>
              {{ 'advance.title' | t }}
            </button>
            <mat-menu #advanceMenu="matMenu">
              @for (s of advanceSteps; track s.minutes) {
                <button mat-menu-item (click)="advance(d.game, s.minutes)">{{ s.label | t }}</button>
              }
              <button mat-menu-item (click)="advanceCustom(d.game)">{{ 'advance.custom' | t }}</button>
              <mat-divider />
              <button mat-menu-item (click)="advance(d.game, null)">
                <mat-icon>skip_next</mat-icon>
                <span>{{ 'advance.next_event' | t }}</span>
              </button>
            </mat-menu>
            <button mat-stroked-button (click)="act(actions.finish(d.game))">
              <mat-icon>emoji_events</mat-icon>
              {{ 'actions.finish' | t }}
            </button>
          }
          <button mat-stroked-button class="danger-outline" (click)="remove(d.game)">
            <mat-icon>delete</mat-icon>
            {{ 'actions.delete' | t }}
          </button>
        </div>
      </div>

      <mat-card appearance="outlined" class="facts">
        <dl>
          <div><dt>{{ 'detail.players' | t }}</dt><dd>{{ d.game.humans }} / {{ d.game.maxPlayers }} · {{ 'games.npc_count' | t: { n: d.game.npcCount } }}</dd></div>
          <div><dt>{{ 'detail.settlements' | t }}</dt><dd>{{ d.game.settlements ?? '–' }} / {{ d.game.maxSettlements }}</dd></div>
          <div><dt>{{ 'detail.opens_at' | t }}</dt><dd>{{ d.game.opensAt | hdate }}</dd></div>
          <div><dt>{{ 'detail.closes_at' | t }}</dt><dd>{{ d.game.closesAt | hdate }}</dd></div>
          <div><dt>{{ 'detail.clock' | t }}</dt><dd>{{ d.game.clock | hdate }}</dd></div>
          <div><dt>{{ 'detail.offset' | t }}</dt><dd>{{ d.game.timeOffsetMinutes | duration }}</dd></div>
          <div><dt>{{ 'detail.next_settlement' | t }}</dt><dd>{{ d.nextSettlementAt | hdate }}</dd></div>
          <div><dt>{{ 'detail.maturing_sheets' | t }}</dt><dd>{{ d.maturingSheets }}</dd></div>
          <div><dt>{{ 'detail.winner' | t }}</dt><dd>{{ d.game.winner ?? '–' }}</dd></div>
          <div><dt>{{ 'detail.created_at' | t }}</dt><dd>{{ d.game.createdAt | hdate }}</dd></div>
          @if (d.game.tags.length) {
            <div><dt>{{ 'detail.tags' | t }}</dt><dd>{{ d.game.tags.join(', ') }}</dd></div>
          }
        </dl>
      </mat-card>

      <h2>{{ 'detail.houses' | t: { n: d.houses.length } }}</h2>
      <mat-card appearance="outlined" class="table-card">
        <div class="table-scroll">
          <table mat-table [dataSource]="d.houses">
            <ng-container matColumnDef="rank">
              <th mat-header-cell *matHeaderCellDef>#</th>
              <td mat-cell *matCellDef="let h; let i = index">{{ i + 1 }}</td>
            </ng-container>
            <ng-container matColumnDef="house">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.house' | t }}</th>
              <td mat-cell *matCellDef="let h">
                <span class="strong">{{ h.houseName }}</span>
              </td>
            </ng-container>
            <ng-container matColumnDef="user">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.user' | t }}</th>
              <td mat-cell *matCellDef="let h">
                @if (h.npc) {
                  <span class="chip chip-npc">{{ 'detail.npc' | t }}</span>
                  <span class="muted">{{ h.persona ?? '' }}</span>
                } @else {
                  {{ h.userName ?? '–' }}
                }
              </td>
            </ng-container>
            <ng-container matColumnDef="background">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.background' | t }}</th>
              <td mat-cell *matCellDef="let h">{{ h.background ?? '–' }}</td>
            </ng-container>
            <ng-container matColumnDef="legit">
              <th mat-header-cell *matHeaderCellDef class="num">{{ 'detail.col.legit' | t }}</th>
              <td mat-cell *matCellDef="let h" class="num">{{ h.legit | hnum }}</td>
            </ng-container>
            <ng-container matColumnDef="gold">
              <th mat-header-cell *matHeaderCellDef class="num">{{ 'detail.col.gold' | t }}</th>
              <td mat-cell *matCellDef="let h" class="num">{{ h.gold | coins }}</td>
            </ng-container>
            <ng-container matColumnDef="pp">
              <th mat-header-cell *matHeaderCellDef class="num">{{ 'detail.col.pp' | t }}</th>
              <td mat-cell *matCellDef="let h" class="num">{{ h.pp | hnum }}</td>
            </ng-container>
            <ng-container matColumnDef="place">
              <th mat-header-cell *matHeaderCellDef class="num">{{ 'detail.col.place' | t }}</th>
              <td mat-cell *matCellDef="let h" class="num">{{ h.place ?? '–' }}</td>
            </ng-container>
            <ng-container matColumnDef="joinedAt">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.joined_at' | t }}</th>
              <td mat-cell *matCellDef="let h">{{ h.joinedAt | hdate }}</td>
            </ng-container>
            <ng-container matColumnDef="actions">
              <th mat-header-cell *matHeaderCellDef></th>
              <td mat-cell *matCellDef="let h" class="row-actions">
                @if (canStart(d.game.status)) {
                  <button mat-icon-button (click)="removeHouse(d.game, h)" [matTooltip]="'actions.remove_house' | t">
                    <mat-icon>person_remove</mat-icon>
                  </button>
                }
              </td>
            </ng-container>
            <tr mat-header-row *matHeaderRowDef="houseColumns"></tr>
            <tr mat-row *matRowDef="let row; columns: houseColumns"></tr>
            <tr class="mat-row" *matNoDataRow>
              <td class="mat-cell empty" [attr.colspan]="houseColumns.length">{{ 'detail.no_houses' | t }}</td>
            </tr>
          </table>
        </div>
      </mat-card>

      <div class="reports-header">
        <h2>{{ 'detail.reports' | t }}</h2>
        <div class="actions">
          <mat-form-field class="compact">
            <mat-label>{{ 'detail.kind' | t }}</mat-label>
            <mat-select [value]="kind()" (selectionChange)="kind.set($event.value)">
              <mat-option [value]="allKinds">{{ 'detail.all_kinds' | t }}</mat-option>
              @for (k of kinds(); track k) {
                <mat-option [value]="k">{{ kindLabel(k) | t }}</mat-option>
              }
            </mat-select>
          </mat-form-field>
          <mat-form-field class="compact">
            <mat-label>{{ 'detail.limit' | t }}</mat-label>
            <mat-select [value]="limit()" (selectionChange)="setLimit($event.value)">
              @for (l of limits; track l) {
                <mat-option [value]="l">{{ l }}</mat-option>
              }
            </mat-select>
          </mat-form-field>
        </div>
      </div>
      <mat-chip-set class="kind-counts" [attr.aria-label]="'detail.report_counts' | t">
        @for (c of d.reportCounts; track c.kind) {
          <mat-chip (click)="kind.set(c.kind)" [highlighted]="kind() === c.kind">
            {{ kindLabel(c.kind) | t }}: {{ c.count | hnum }}
          </mat-chip>
        } @empty {
          <span class="muted">{{ 'detail.no_reports' | t }}</span>
        }
      </mat-chip-set>
      <mat-card appearance="outlined" class="table-card">
        @if (reportsLoading()) {
          <mat-progress-bar mode="indeterminate" />
        }
        <div class="table-scroll">
          <table mat-table [dataSource]="filteredReports()">
            <ng-container matColumnDef="createdAt">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.created_at' | t }}</th>
              <td mat-cell *matCellDef="let r" class="nowrap">
                {{ r.createdAt | hdate }}
                <div class="muted">{{ 'detail.settlement_no' | t: { n: r.settlement } }}</div>
              </td>
            </ng-container>
            <ng-container matColumnDef="house">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.house' | t }}</th>
              <td mat-cell *matCellDef="let r">{{ r.houseName }}</td>
            </ng-container>
            <ng-container matColumnDef="kind">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.kind' | t }}</th>
              <td mat-cell *matCellDef="let r">
                {{ kindLabel(r.kind) | t }}
                @if (r.confidence) {
                  <div class="muted">{{ confidenceLabel(r.confidence) | t }}</div>
                }
                @if (r.isPublic) {
                  <div class="muted">{{ 'detail.public' | t }}</div>
                }
              </td>
            </ng-container>
            <ng-container matColumnDef="text">
              <th mat-header-cell *matHeaderCellDef>{{ 'detail.col.text' | t }}</th>
              <td mat-cell *matCellDef="let r" [class]="'tone-' + r.tone">
                <div class="strong">{{ r.title | units }}</div>
                <div class="report-body">{{ r.body | units }}</div>
              </td>
            </ng-container>
            <tr mat-header-row *matHeaderRowDef="reportColumns"></tr>
            <tr mat-row *matRowDef="let row; columns: reportColumns"></tr>
            <tr class="mat-row" *matNoDataRow>
              <td class="mat-cell empty" [attr.colspan]="reportColumns.length">{{ 'detail.no_reports' | t }}</td>
            </tr>
          </table>
        </div>
      </mat-card>
    }
  `,
  styles: `
    .back { margin-bottom: 8px; }
    h1 { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
    .facts { padding: 16px; margin-bottom: 24px; }
    dl { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px 24px; margin: 0; }
    dt { font: var(--mat-sys-label-medium); color: var(--mat-sys-on-surface-variant); }
    dd { margin: 2px 0 0; font: var(--mat-sys-body-large); }
    .reports-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; margin-top: 24px; }
    .compact { width: 160px; }
    .kind-counts { display: block; margin: 8px 0 16px; }
    .report-body { white-space: pre-line; color: var(--mat-sys-on-surface-variant); max-width: 760px; }
    .nowrap { white-space: nowrap; }
  `,
})
export class GameDetailPage {
  private readonly adminApi = inject(AdminService);
  private readonly notifier = inject(Notifier);
  private readonly dialog = inject(MatDialog);
  private readonly router = inject(Router);
  protected readonly actions = inject(GameActions);

  /** Route parameter (withComponentInputBinding). */
  readonly id = input.required<string>();

  protected readonly canStart = canStart;
  protected readonly isRunning = isRunning;
  protected readonly advanceSteps = ADVANCE_STEPS;
  protected readonly limits = REPORT_LIMITS;
  protected readonly allKinds = ALL_KINDS;
  protected readonly houseColumns = ['rank', 'house', 'user', 'background', 'legit', 'gold', 'pp', 'place', 'joinedAt', 'actions'];
  protected readonly reportColumns = ['createdAt', 'house', 'kind', 'text'];

  protected readonly loading = signal(false);
  protected readonly reportsLoading = signal(false);
  protected readonly detail = signal<AdminGameDetail | null>(null);
  protected readonly reports = signal<AdminReport[]>([]);
  protected readonly kind = signal(ALL_KINDS);
  protected readonly limit = signal(100);

  protected readonly kinds = computed(() => {
    const fromCounts = this.detail()?.reportCounts.map((c) => c.kind) ?? [];
    return [...new Set([...fromCounts, ...this.reports().map((r) => r.kind)])];
  });
  protected readonly filteredReports = computed(() => {
    const k = this.kind();
    return k === ALL_KINDS ? this.reports() : this.reports().filter((r) => r.kind === k);
  });

  constructor() {
    effect(() => {
      this.id();
      untracked(() => this.load());
    });
  }

  load(): void {
    const id = this.id();
    this.loading.set(true);
    this.adminApi
      .adminGame(id)
      .pipe(finalize(() => this.loading.set(false)))
      .subscribe({ next: (d) => this.detail.set(d), error: (e) => this.notifier.error(e) });
    this.loadReports();
  }

  protected setLimit(limit: number): void {
    this.limit.set(limit);
    this.loadReports();
  }

  private loadReports(): void {
    this.reportsLoading.set(true);
    this.adminApi
      .adminGameReports(this.id(), this.limit())
      .pipe(finalize(() => this.reportsLoading.set(false)))
      .subscribe({ next: (r) => this.reports.set(r), error: (e) => this.notifier.error(e) });
  }

  protected act(op: Observable<unknown>): void {
    op.subscribe(() => this.load());
  }

  protected advance(game: AdminGame, minutes: number | null): void {
    this.act(this.actions.advance(game, minutes));
  }

  protected advanceCustom(game: AdminGame): void {
    this.dialog
      .open<AdvanceDialog, unknown, number>(AdvanceDialog, { width: '360px' })
      .afterClosed()
      .pipe(filter((m): m is number => typeof m === 'number'))
      .subscribe((m) => this.advance(game, m));
  }

  protected remove(game: AdminGame): void {
    this.actions.delete(game).subscribe(() => void this.router.navigateByUrl('/games'));
  }

  protected removeHouse(game: AdminGame, h: AdminHouse): void {
    this.act(this.actions.removeHouse(game, h.playerId, h.houseName));
  }

  protected kindLabel(k: string): string {
    return REPORT_KIND_KEYS[k] ?? k;
  }

  protected confidenceLabel(c: string): string {
    return CONFIDENCE_KEYS[c] ?? c;
  }
}
