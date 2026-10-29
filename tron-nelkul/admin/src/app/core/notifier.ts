import { Injectable, inject } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ProblemDetail } from '../api';
import { TParams, Translator } from './translator';

/** Snackbar messages; errors show the server's ProblemDetail.detail (already localized). */
@Injectable({ providedIn: 'root' })
export class Notifier {
  private readonly snackBar = inject(MatSnackBar);
  private readonly translator = inject(Translator);

  info(k: string, params?: TParams): void {
    this.snackBar.open(this.translator.t(k, params), this.translator.t('common.ok'), { duration: 4000 });
  }

  error(err: unknown): void {
    this.snackBar.open(this.describe(err), this.translator.t('common.close'), {
      duration: 8000,
      panelClass: 'snack-error',
    });
  }

  describe(err: unknown): string {
    if (err instanceof HttpErrorResponse) {
      const body = err.error as ProblemDetail | string | null;
      if (body && typeof body === 'object' && body.detail) return body.detail;
      if (err.status === 0) return this.translator.t('error.network');
      return this.translator.t('error.http', { status: err.status });
    }
    const code = (err as { code?: unknown } | null)?.code;
    if (typeof code === 'string' && code.startsWith('auth/')) {
      return this.translator.t('error.auth', { code });
    }
    return this.translator.t('error.unexpected');
  }
}
