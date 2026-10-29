import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { Notifier } from './notifier';
import { Session } from './session';

/** Signed in and role ADMIN; otherwise /login or /no-access. */
export const adminGuard: CanActivateFn = async () => {
  const session = inject(Session);
  const router = inject(Router);
  await session.ready;
  if (!session.user()) return router.parseUrl('/login');
  try {
    await session.loadMe();
  } catch (e) {
    inject(Notifier).error(e);
    return router.parseUrl('/no-access');
  }
  return session.isAdmin() ? true : router.parseUrl('/no-access');
};

/** The login page only for signed-out visitors. */
export const signedOutGuard: CanActivateFn = async () => {
  const session = inject(Session);
  await session.ready;
  return session.user() ? inject(Router).parseUrl('/') : true;
};
