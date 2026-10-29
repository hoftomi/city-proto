import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { Session } from '../../core/session';
import { TPipe } from '../../core/t.pipe';

/** Signed in, but not an ADMIN (or /api/me failed). */
@Component({
  selector: 'app-no-access',
  imports: [MatButtonModule, MatCardModule, MatIconModule, TPipe],
  template: `
    <div class="center-page">
      <mat-card appearance="outlined" class="center-card">
        <mat-card-header>
          <mat-icon mat-card-avatar class="logo">block</mat-icon>
          <mat-card-title>{{ 'noAccess.title' | t }}</mat-card-title>
          @if (session.user(); as user) {
            <mat-card-subtitle>{{ user.email ?? user.displayName }}</mat-card-subtitle>
          }
        </mat-card-header>
        <mat-card-content>
          <p>{{ (session.me() ? 'noAccess.not_admin' : 'noAccess.unknown') | t: { name: session.me()?.name } }}</p>
        </mat-card-content>
        <mat-card-actions align="end">
          @if (session.user()) {
            <button mat-button (click)="retry()">
              <mat-icon>refresh</mat-icon>
              {{ 'noAccess.retry' | t }}
            </button>
          }
          <button mat-flat-button (click)="signOut()">
            <mat-icon>logout</mat-icon>
            {{ 'nav.sign_out' | t }}
          </button>
        </mat-card-actions>
      </mat-card>
    </div>
  `,
})
export class NoAccess {
  protected readonly session = inject(Session);
  private readonly router = inject(Router);

  retry(): void {
    this.session.me.set(null);
    void this.router.navigateByUrl('/');
  }

  async signOut(): Promise<void> {
    await this.session.signOut();
    await this.router.navigateByUrl('/login');
  }
}
