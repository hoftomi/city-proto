import { Component, inject } from '@angular/core';
import { BreakpointObserver } from '@angular/cdk/layout';
import { toSignal } from '@angular/core/rxjs-interop';
import { Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { map } from 'rxjs';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatToolbarModule } from '@angular/material/toolbar';
import { Session } from '../../core/session';
import { TPipe } from '../../core/t.pipe';
import { key } from '../../core/translator';

const NAV = [
  { path: '/', icon: 'dashboard', label: key('nav.dashboard'), exact: true },
  { path: '/games', icon: 'sports_esports', label: key('nav.games'), exact: false },
  { path: '/users', icon: 'group', label: key('nav.users'), exact: false },
];

@Component({
  selector: 'app-shell',
  imports: [
    RouterOutlet, RouterLink, RouterLinkActive, MatButtonModule, MatIconModule, MatListModule,
    MatMenuModule, MatSidenavModule, MatToolbarModule, TPipe,
  ],
  template: `
    <mat-sidenav-container class="shell">
      <mat-sidenav #nav [mode]="handset() ? 'over' : 'side'" [opened]="!handset()" class="nav">
        <div class="brand">
          <mat-icon>castle</mat-icon>
          <span>{{ 'app.title' | t }}</span>
        </div>
        <mat-nav-list>
          @for (item of navItems; track item.path) {
            <a
              mat-list-item
              [routerLink]="item.path"
              routerLinkActive
              #rla="routerLinkActive"
              [activated]="rla.isActive"
              [routerLinkActiveOptions]="{ exact: item.exact }"
              (click)="handset() && nav.close()"
            >
              <mat-icon matListItemIcon>{{ item.icon }}</mat-icon>
              <span matListItemTitle>{{ item.label | t }}</span>
            </a>
          }
        </mat-nav-list>
      </mat-sidenav>
      <mat-sidenav-content>
        <mat-toolbar class="toolbar">
          @if (handset()) {
            <button mat-icon-button (click)="nav.toggle()" [attr.aria-label]="'nav.menu' | t">
              <mat-icon>menu</mat-icon>
            </button>
          }
          <span>{{ 'app.admin' | t }}</span>
          <span class="spacer"></span>
          <button mat-button [matMenuTriggerFor]="userMenu">
            <mat-icon>account_circle</mat-icon>
            {{ session.me()?.name }}
          </button>
          <mat-menu #userMenu="matMenu">
            <div class="menu-email">{{ session.user()?.email }}</div>
            <button mat-menu-item (click)="signOut()">
              <mat-icon>logout</mat-icon>
              <span>{{ 'nav.sign_out' | t }}</span>
            </button>
          </mat-menu>
        </mat-toolbar>
        <main class="content">
          <router-outlet />
        </main>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `,
  styles: `
    .shell { height: 100vh; }
    .nav { width: 232px; }
    .brand { display: flex; align-items: center; gap: 12px; padding: 20px 16px; font: var(--mat-sys-title-medium); color: var(--mat-sys-primary); }
    .toolbar { position: sticky; top: 0; z-index: 2; background: var(--mat-sys-surface-container); }
    .spacer { flex: 1; }
    .content { padding: 24px; max-width: 1400px; margin: 0 auto; }
    .menu-email { padding: 8px 16px; font: var(--mat-sys-body-small); color: var(--mat-sys-on-surface-variant); }
  `,
})
export class Shell {
  protected readonly session = inject(Session);
  private readonly router = inject(Router);
  protected readonly navItems = NAV;
  protected readonly handset = toSignal(
    inject(BreakpointObserver).observe('(max-width: 900px)').pipe(map((s) => s.matches)),
    { initialValue: false },
  );

  async signOut(): Promise<void> {
    await this.session.signOut();
    await this.router.navigateByUrl('/login');
  }
}
