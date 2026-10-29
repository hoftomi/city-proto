import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatTableModule } from '@angular/material/table';
import { filter, finalize, switchMap } from 'rxjs';
import { AdminService, AdminUser } from '../../api';
import { HDatePipe } from '../../core/format';
import { ROLE_KEYS } from '../../core/labels';
import { Notifier } from '../../core/notifier';
import { ROLE_ADMIN, Session } from '../../core/session';
import { TPipe } from '../../core/t.pipe';
import { key } from '../../core/translator';
import { confirm } from '../../shared/confirm-dialog';

const ROLE_PLAYER = 'PLAYER';

@Component({
  selector: 'app-users',
  imports: [
    MatButtonModule, MatCardModule, MatFormFieldModule, MatIconModule, MatInputModule, MatProgressBarModule,
    MatSlideToggleModule, MatTableModule, TPipe, HDatePipe,
  ],
  template: `
    <div class="page-header">
      <h1>{{ 'users.title' | t }}</h1>
      <div class="actions">
        <mat-form-field class="search">
          <mat-icon matPrefix>search</mat-icon>
          <mat-label>{{ 'users.search' | t }}</mat-label>
          <input matInput [value]="query()" (input)="query.set($any($event.target).value)" />
        </mat-form-field>
        <button mat-stroked-button (click)="load()" [disabled]="loading()">
          <mat-icon>refresh</mat-icon>
          {{ 'common.refresh' | t }}
        </button>
      </div>
    </div>
    <mat-card appearance="outlined" class="table-card">
      @if (loading()) {
        <mat-progress-bar mode="indeterminate" />
      }
      <div class="table-scroll">
        <table mat-table [dataSource]="filtered()">
          <ng-container matColumnDef="name">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.name' | t }}</th>
            <td mat-cell *matCellDef="let u">
              <span class="strong">{{ u.name }}</span>
              @if (u.id === session.me()?.id) {
                <span class="muted"> {{ 'users.you' | t }}</span>
              }
            </td>
          </ng-container>
          <ng-container matColumnDef="email">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.email' | t }}</th>
            <td mat-cell *matCellDef="let u">{{ u.email ?? '–' }}</td>
          </ng-container>
          <ng-container matColumnDef="providers">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.providers' | t }}</th>
            <td mat-cell *matCellDef="let u">
              @for (p of u.providers; track p) {
                <span class="chip">{{ p }}</span>
              }
            </td>
          </ng-container>
          <ng-container matColumnDef="role">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.role' | t }}</th>
            <td mat-cell *matCellDef="let u">
              <span class="chip" [class.chip-admin]="u.role === admin">{{ roleLabel(u.role) | t }}</span>
            </td>
          </ng-container>
          <ng-container matColumnDef="createdAt">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.created_at' | t }}</th>
            <td mat-cell *matCellDef="let u">{{ u.createdAt | hdate }}</td>
          </ng-container>
          <ng-container matColumnDef="games">
            <th mat-header-cell *matHeaderCellDef class="num">{{ 'users.col.games' | t }}</th>
            <td mat-cell *matCellDef="let u" class="num">{{ u.games }}</td>
          </ng-container>
          <ng-container matColumnDef="admin">
            <th mat-header-cell *matHeaderCellDef>{{ 'users.col.admin' | t }}</th>
            <td mat-cell *matCellDef="let u">
              <mat-slide-toggle
                [checked]="u.role === admin"
                [disabled]="busy() === u.id"
                (change)="toggleAdmin(u, toggle)"
                #toggle
                [attr.aria-label]="'users.col.admin' | t"
              />
            </td>
          </ng-container>
          <tr mat-header-row *matHeaderRowDef="columns; sticky: true"></tr>
          <tr mat-row *matRowDef="let row; columns: columns"></tr>
          <tr class="mat-row" *matNoDataRow>
            <td class="mat-cell empty" [attr.colspan]="columns.length">{{ (loading() ? 'common.loading' : 'users.empty') | t }}</td>
          </tr>
        </table>
      </div>
    </mat-card>
  `,
  styles: `.search { width: 260px; }`,
})
export class Users implements OnInit {
  private readonly adminApi = inject(AdminService);
  private readonly notifier = inject(Notifier);
  private readonly dialog = inject(MatDialog);
  protected readonly session = inject(Session);

  protected readonly admin = ROLE_ADMIN;
  protected readonly columns = ['name', 'email', 'providers', 'role', 'createdAt', 'games', 'admin'];
  protected readonly loading = signal(false);
  protected readonly busy = signal<string | null>(null);
  protected readonly users = signal<AdminUser[]>([]);
  protected readonly query = signal('');
  protected readonly filtered = computed(() => {
    const q = this.query().trim().toLowerCase();
    if (!q) return this.users();
    return this.users().filter((u) => u.name.toLowerCase().includes(q) || (u.email ?? '').toLowerCase().includes(q));
  });

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.adminApi
      .adminUsers()
      .pipe(finalize(() => this.loading.set(false)))
      .subscribe({ next: (u) => this.users.set(u), error: (e) => this.notifier.error(e) });
  }

  protected roleLabel(role: string): string {
    return ROLE_KEYS[role] ?? role;
  }

  /** Confirm → PUT role; the toggle snaps back to the stored role unless the server accepted the change. */
  protected toggleAdmin(user: AdminUser, toggle: { checked: boolean }): void {
    const grant = user.role !== ROLE_ADMIN;
    toggle.checked = !grant;
    confirm(this.dialog, {
      title: grant ? key('users.grant_title') : key('users.revoke_title'),
      message: grant ? key('users.grant_confirm') : key('users.revoke_confirm'),
      params: { name: user.name },
      danger: !grant,
    })
      .pipe(
        filter(Boolean),
        switchMap(() => {
          this.busy.set(user.id);
          return this.adminApi
            .adminSetRole(user.id, { role: grant ? ROLE_ADMIN : ROLE_PLAYER })
            .pipe(finalize(() => this.busy.set(null)));
        }),
      )
      .subscribe({
        next: (updated) => {
          this.users.update((list) => list.map((u) => (u.id === updated.id ? updated : u)));
          this.notifier.info(updated.role === ROLE_ADMIN ? key('users.granted') : key('users.revoked'), { name: updated.name });
        },
        error: (e) => this.notifier.error(e),
      });
  }
}
