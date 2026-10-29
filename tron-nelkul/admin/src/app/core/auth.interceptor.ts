import { HttpErrorResponse, HttpInterceptorFn, HttpRequest } from '@angular/common/http';
import { inject } from '@angular/core';
import { catchError, from, switchMap, throwError } from 'rxjs';
import { Session } from './session';

const PUBLIC_PREFIX = '/api/i18n/';

function needsToken(req: HttpRequest<unknown>): boolean {
  const path = req.url.replace(/^https?:\/\/[^/]+/, '');
  return path.startsWith('/api/') && !path.startsWith(PUBLIC_PREFIX);
}

function withToken(req: HttpRequest<unknown>, token: string | null): HttpRequest<unknown> {
  return token ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } }) : req;
}

/** Adds the Firebase ID token to /api calls; on 401 retries once with a force-refreshed token. */
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  if (!needsToken(req)) return next(req);
  const session = inject(Session);
  return from(session.idToken()).pipe(
    switchMap((token) => next(withToken(req, token))),
    catchError((err: unknown) => {
      if (!(err instanceof HttpErrorResponse) || err.status !== 401) return throwError(() => err);
      return from(session.idToken(true)).pipe(
        switchMap((token) => (token ? next(withToken(req, token)) : throwError(() => err))),
      );
    }),
  );
};
