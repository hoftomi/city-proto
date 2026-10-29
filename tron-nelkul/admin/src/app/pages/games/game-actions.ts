import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Observable, catchError, filter, map, of, switchMap } from 'rxjs';
import { AdminGame, AdminResult, AdminService } from '../../api';
import { formatDuration } from '../../core/format';
import { Translator } from '../../core/translator';
import { Notifier } from '../../core/notifier';
import { ConfirmData, confirm } from '../../shared/confirm-dialog';

/** Game operations shared by the list and the detail page: confirm → call → snackbar. Emits once on success. */
@Injectable({ providedIn: 'root' })
export class GameActions {
  private readonly adminApi = inject(AdminService);
  private readonly dialog = inject(MatDialog);
  private readonly notifier = inject(Notifier);
  private readonly translator = inject(Translator);

  start(game: AdminGame): Observable<AdminResult> {
    return this.confirmed(
      { title: 'actions.start', message: 'actions.start_confirm', params: { name: game.name }, confirm: 'actions.start' },
      () => this.adminApi.adminStart(game.id),
      () => this.notifier.info('actions.started', { name: game.name }),
    );
  }

  settle(game: AdminGame): Observable<AdminResult> {
    return this.confirmed(
      { title: 'actions.settle', message: 'actions.settle_confirm', params: { name: game.name }, confirm: 'actions.settle', danger: true },
      () => this.adminApi.adminSettle(game.id),
      (r) => this.notifier.info('actions.settled', { n: r.settlements ?? '–' }),
    );
  }

  /** minutes = null: to the next event. No confirmation (the clock only moves forward by a chosen amount). */
  advance(game: AdminGame, minutes: number | null): Observable<AdminResult> {
    return this.run(
      () => this.adminApi.adminAdvance(game.id, { minutes }),
      (r) => this.notifier.info('actions.advanced', { duration: formatDuration(this.translator, r.advancedMinutes) }),
    );
  }

  finish(game: AdminGame): Observable<AdminResult> {
    return this.confirmed(
      { title: 'actions.finish', message: 'actions.finish_confirm', params: { name: game.name }, confirm: 'actions.finish', danger: true },
      () => this.adminApi.adminFinish(game.id),
      () => this.notifier.info('actions.finished', { name: game.name }),
    );
  }

  delete(game: AdminGame): Observable<unknown> {
    return this.confirmed(
      { title: 'actions.delete', message: 'actions.delete_confirm', params: { name: game.name }, confirm: 'actions.delete', danger: true },
      () => this.adminApi.adminDeleteGame(game.id).pipe(map(() => true)),
      () => this.notifier.info('actions.deleted', { name: game.name }),
    );
  }

  removeHouse(game: AdminGame, playerId: string, houseName: string): Observable<unknown> {
    return this.confirmed(
      { title: 'actions.remove_house', message: 'actions.remove_house_confirm', params: { house: houseName }, confirm: 'actions.remove', danger: true },
      () => this.adminApi.adminRemovePlayer(game.id, playerId).pipe(map(() => true)),
      () => this.notifier.info('actions.house_removed', { house: houseName }),
    );
  }

  seed(): Observable<AdminResult> {
    return this.confirmed(
      { title: 'actions.seed', message: 'actions.seed_confirm', confirm: 'actions.seed' },
      () => this.adminApi.adminSeed(),
      (r) => this.notifier.info('actions.seeded', { n: r.created ?? 0 }),
    );
  }

  private confirmed<T>(data: ConfirmData, call: () => Observable<T>, done: (r: T) => void): Observable<T> {
    return confirm(this.dialog, data).pipe(
      filter(Boolean),
      switchMap(() => this.run(call, done)),
    );
  }

  private run<T>(call: () => Observable<T>, done: (r: T) => void): Observable<T> {
    return call().pipe(
      map((r) => {
        done(r);
        return r;
      }),
      catchError((e: unknown) => {
        this.notifier.error(e);
        return of();
      }),
    );
  }
}
