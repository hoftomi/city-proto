import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatCardModule } from '@angular/material/card';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { Observable, finalize } from 'rxjs';
import { AdminGame, AdminService } from '../../api';
import { DurationPipe, HDatePipe } from '../../core/format';
import { GAME_STATUSES, STATUS_KEYS, canStart, isRunning } from '../../core/labels';
import { Notifier } from '../../core/notifier';
import { TPipe } from '../../core/t.pipe';
import { StatusChip } from '../../shared/status-chip';
import { CreateGameDialog } from './create-game-dialog';
import { GameActions } from './game-actions';

type StatusFilter = 'all' | (typeof GAME_STATUSES)[number];

@Component({
  selector: 'app-games',
  imports: [
    RouterLink, MatButtonModule, MatButtonToggleModule, MatCardModule, MatIconModule, MatMenuModule,
    MatProgressBarModule, MatTableModule, MatTooltipModule, TPipe, HDatePipe, DurationPipe, StatusChip,
  ],
  template: `
    <div class="page-header">
      <h1>{{ 'games.title' | t }}</h1>
      <div class="actions">
        <button mat-stroked-button (click)="load()" [disabled]="loading()">
          <mat-icon>refresh</mat-icon>
          {{ 'common.refresh' | t }}
        </button>
        <button mat-stroked-button (click)="seed()">
          <mat-icon>auto_awesome</mat-icon>
          {{ 'actions.seed' | t }}
        </button>
        <button mat-flat-button (click)="create()">
          <mat-icon>add</mat-icon>
          {{ 'games.new' | t }}
        </button>
      </div>
    </div>

    <mat-button-toggle-group [value]="filter()" (change)="filter.set($event.value)" class="filter" [attr.aria-label]="'games.filter' | t">
      <mat-button-toggle value="all">{{ 'games.all' | t }} ({{ games().length }})</mat-button-toggle>
      @for (s of statuses; track s) {
        <mat-button-toggle [value]="s">{{ statusKeys[s] | t }} ({{ counts()[s] ?? 0 }})</mat-button-toggle>
      }
    </mat-button-toggle-group>

    <mat-card appearance="outlined" class="table-card">
      @if (loading()) {
        <mat-progress-bar mode="indeterminate" />
      }
      <div class="table-scroll">
        <table mat-table [dataSource]="filtered()">
          <ng-container matColumnDef="name">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.name' | t }}</th>
            <td mat-cell *matCellDef="let g">
              <a [routerLink]="['/games', g.id]" class="strong">{{ g.name }}</a>
              <div class="muted">{{ g.tags.length ? g.id + ' · ' + g.tags.join(', ') : g.id }}</div>
            </td>
          </ng-container>
          <ng-container matColumnDef="status">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.status' | t }}</th>
            <td mat-cell *matCellDef="let g"><app-status-chip [status]="g.status" /></td>
          </ng-container>
          <ng-container matColumnDef="map">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.map' | t }}</th>
            <td mat-cell *matCellDef="let g">{{ g.mapName }}</td>
          </ng-container>
          <ng-container matColumnDef="players">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.players' | t }}</th>
            <td mat-cell *matCellDef="let g">
              {{ g.humans }} / {{ g.maxPlayers }}
              @if (g.npcCount) {
                <div class="muted">{{ 'games.npc_count' | t: { n: g.npcCount } }}</div>
              }
            </td>
          </ng-container>
          <ng-container matColumnDef="settlements">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.settlements' | t }}</th>
            <td mat-cell *matCellDef="let g">{{ g.settlements ?? '–' }} / {{ g.maxSettlements }}</td>
          </ng-container>
          <ng-container matColumnDef="closesAt">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.closes_at' | t }}</th>
            <td mat-cell *matCellDef="let g">{{ g.closesAt | hdate }}</td>
          </ng-container>
          <ng-container matColumnDef="clock">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.clock' | t }}</th>
            <td mat-cell *matCellDef="let g">
              {{ g.clock | hdate }}
              @if (g.timeOffsetMinutes) {
                <div class="muted">{{ g.timeOffsetMinutes | duration }}</div>
              }
            </td>
          </ng-container>
          <ng-container matColumnDef="winner">
            <th mat-header-cell *matHeaderCellDef>{{ 'games.col.winner' | t }}</th>
            <td mat-cell *matCellDef="let g">{{ g.winner ?? '–' }}</td>
          </ng-container>
          <ng-container matColumnDef="actions">
            <th mat-header-cell *matHeaderCellDef></th>
            <td mat-cell *matCellDef="let g" class="row-actions">
              <button mat-icon-button [matMenuTriggerFor]="menu" [matMenuTriggerData]="{ g: g }" [attr.aria-label]="'common.actions' | t">
                <mat-icon>more_vert</mat-icon>
              </button>
            </td>
          </ng-container>
          <tr mat-header-row *matHeaderRowDef="columns; sticky: true"></tr>
          <tr mat-row *matRowDef="let row; columns: columns"></tr>
          <tr class="mat-row" *matNoDataRow>
            <td class="mat-cell empty" [attr.colspan]="columns.length">{{ (loading() ? 'common.loading' : 'games.empty') | t }}</td>
          </tr>
        </table>
      </div>
    </mat-card>

    <mat-menu #menu="matMenu">
      <ng-template matMenuContent let-g="g">
        <button mat-menu-item (click)="open(g)">
          <mat-icon>open_in_new</mat-icon>
          <span>{{ 'games.open' | t }}</span>
        </button>
        @if (canStart(g.status)) {
          <button mat-menu-item (click)="act(actions.start(g))">
            <mat-icon>play_arrow</mat-icon>
            <span>{{ 'actions.start' | t }}</span>
          </button>
        }
        @if (isRunning(g.status)) {
          <button mat-menu-item (click)="act(actions.settle(g))">
            <mat-icon>gavel</mat-icon>
            <span>{{ 'actions.settle' | t }}</span>
          </button>
          <button mat-menu-item (click)="act(actions.advance(g, null))">
            <mat-icon>skip_next</mat-icon>
            <span>{{ 'advance.next_event' | t }}</span>
          </button>
        }
        <button mat-menu-item (click)="act(actions.delete(g))">
          <mat-icon class="danger-icon">delete</mat-icon>
          <span>{{ 'actions.delete' | t }}</span>
        </button>
      </ng-template>
    </mat-menu>
  `,
  styles: `
    .filter { margin-bottom: 16px; flex-wrap: wrap; }
  `,
})
export class Games implements OnInit {
  private readonly adminApi = inject(AdminService);
  private readonly notifier = inject(Notifier);
  private readonly dialog = inject(MatDialog);
  private readonly router = inject(Router);
  protected readonly actions = inject(GameActions);

  protected readonly statuses = GAME_STATUSES;
  protected readonly statusKeys = STATUS_KEYS;
  protected readonly canStart = canStart;
  protected readonly isRunning = isRunning;
  protected readonly columns = ['name', 'status', 'map', 'players', 'settlements', 'closesAt', 'clock', 'winner', 'actions'];

  protected readonly loading = signal(false);
  protected readonly games = signal<AdminGame[]>([]);
  protected readonly filter = signal<StatusFilter>('all');
  protected readonly filtered = computed(() => {
    const f = this.filter();
    return f === 'all' ? this.games() : this.games().filter((g) => g.status === f);
  });
  protected readonly counts = computed(() =>
    this.games().reduce<Record<string, number>>((acc, g) => ({ ...acc, [g.status]: (acc[g.status] ?? 0) + 1 }), {}),
  );

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.adminApi
      .adminGames()
      .pipe(finalize(() => this.loading.set(false)))
      .subscribe({ next: (games) => this.games.set(games), error: (e) => this.notifier.error(e) });
  }

  protected create(): void {
    this.dialog
      .open(CreateGameDialog, { width: '640px' })
      .afterClosed()
      .subscribe((game?: AdminGame) => {
        if (game) this.load();
      });
  }

  protected seed(): void {
    this.act(this.actions.seed());
  }

  protected open(g: AdminGame): void {
    void this.router.navigate(['/games', g.id]);
  }

  /** Runs a game action, then reloads the list. */
  protected act(op: Observable<unknown>): void {
    op.subscribe(() => this.load());
  }
}
