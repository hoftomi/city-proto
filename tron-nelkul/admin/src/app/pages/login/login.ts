import { Component, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { Notifier } from '../../core/notifier';
import { Session, firebaseConfigured } from '../../core/session';
import { TPipe } from '../../core/t.pipe';

const IGNORED_AUTH_ERRORS = ['auth/popup-closed-by-user', 'auth/cancelled-popup-request'];

@Component({
  selector: 'app-login',
  imports: [MatButtonModule, MatCardModule, MatIconModule, MatProgressBarModule, TPipe],
  template: `
    <div class="center-page">
      <mat-card appearance="outlined" class="center-card">
        @if (busy()) {
          <mat-progress-bar mode="indeterminate" />
        }
        <mat-card-header>
          <mat-icon mat-card-avatar class="logo">castle</mat-icon>
          <mat-card-title>{{ 'app.title' | t }}</mat-card-title>
          <mat-card-subtitle>{{ 'login.subtitle' | t }}</mat-card-subtitle>
        </mat-card-header>
        <mat-card-content>
          <p>{{ 'login.intro' | t }}</p>
          @if (!configured) {
            <p class="warn">{{ 'login.not_configured' | t }}</p>
          }
        </mat-card-content>
        <mat-card-actions align="end">
          <button mat-flat-button (click)="signIn()" [disabled]="busy()">
            <mat-icon>login</mat-icon>
            {{ 'login.google' | t }}
          </button>
        </mat-card-actions>
      </mat-card>
    </div>
  `,
})
export class Login {
  private readonly session = inject(Session);
  private readonly notifier = inject(Notifier);
  private readonly router = inject(Router);

  protected readonly configured = firebaseConfigured();
  protected readonly busy = signal(false);

  async signIn(): Promise<void> {
    this.busy.set(true);
    try {
      await this.session.signIn();
      await this.router.navigateByUrl('/');
    } catch (e) {
      const code = (e as { code?: string }).code;
      if (!code || !IGNORED_AUTH_ERRORS.includes(code)) this.notifier.error(e);
    } finally {
      this.busy.set(false);
    }
  }
}
