import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { AdminGame, AdminMap, AdminService, CreateGameRequest } from '../../api';
import { Notifier } from '../../core/notifier';
import { TPipe } from '../../core/t.pipe';

export const GAME_ID_PATTERN = /^[a-z0-9-]+$/;

/** Date → value of a datetime-local input (browser time zone). */
export function toLocalInput(d: Date): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}`;
}

/** datetime-local value → ISO-8601 instant, '' → null. */
export function fromLocalInput(v: string | null | undefined): string | null {
  if (!v) return null;
  const d = new Date(v);
  return isNaN(d.getTime()) ? null : d.toISOString();
}

export function parseTags(v: string | null | undefined): string[] {
  return (v ?? '')
    .split(',')
    .map((t) => t.trim())
    .filter(Boolean);
}

/** Creates a game (CreateGameRequest); closes with the created AdminGame. */
@Component({
  selector: 'app-create-game-dialog',
  imports: [
    ReactiveFormsModule, MatButtonModule, MatDialogModule, MatFormFieldModule, MatInputModule,
    MatProgressBarModule, MatSelectModule, TPipe,
  ],
  template: `
    <h2 mat-dialog-title>{{ 'create.title' | t }}</h2>
    <form [formGroup]="form" (ngSubmit)="submit()">
      <mat-dialog-content class="form-grid">
        <mat-form-field>
          <mat-label>{{ 'create.id' | t }}</mat-label>
          <input matInput formControlName="id" autocomplete="off" />
          <mat-hint>{{ 'create.id_hint' | t }}</mat-hint>
          @if (form.controls.id.hasError('pattern')) {
            <mat-error>{{ 'create.id_invalid' | t }}</mat-error>
          }
        </mat-form-field>
        <mat-form-field>
          <mat-label>{{ 'create.name' | t }}</mat-label>
          <input matInput formControlName="name" autocomplete="off" />
        </mat-form-field>
        <mat-form-field class="wide">
          <mat-label>{{ 'create.map' | t }}</mat-label>
          <mat-select formControlName="mapId" (selectionChange)="onMap($event.value)">
            @for (m of maps(); track m.id) {
              <mat-option [value]="m.id">{{ 'create.map_option' | t: { name: m.name, cities: m.cities, starts: m.starts } }}</mat-option>
            }
          </mat-select>
        </mat-form-field>
        <mat-form-field>
          <mat-label>{{ 'create.opens_at' | t }}</mat-label>
          <input matInput type="datetime-local" formControlName="opensAt" />
          <mat-hint>{{ 'create.opens_at_hint' | t }}</mat-hint>
        </mat-form-field>
        <mat-form-field>
          <mat-label>{{ 'create.closes_at' | t }}</mat-label>
          <input matInput type="datetime-local" formControlName="closesAt" />
          <mat-hint>{{ 'create.closes_at_hint' | t }}</mat-hint>
        </mat-form-field>
        <mat-form-field>
          <mat-label>{{ 'create.max_players' | t }}</mat-label>
          <input matInput type="number" min="1" formControlName="maxPlayers" />
        </mat-form-field>
        <mat-form-field>
          <mat-label>{{ 'create.npc_count' | t }}</mat-label>
          <input matInput type="number" min="0" formControlName="npcCount" />
        </mat-form-field>
        <mat-form-field class="wide">
          <mat-label>{{ 'create.tags' | t }}</mat-label>
          <input matInput formControlName="tags" autocomplete="off" />
          <mat-hint>{{ 'create.tags_hint' | t }}</mat-hint>
        </mat-form-field>
      </mat-dialog-content>
      @if (busy()) {
        <mat-progress-bar mode="indeterminate" />
      }
      <mat-dialog-actions align="end">
        <button mat-button type="button" mat-dialog-close>{{ 'common.cancel' | t }}</button>
        <button mat-flat-button type="submit" [disabled]="form.invalid || busy()">{{ 'create.submit' | t }}</button>
      </mat-dialog-actions>
    </form>
  `,
  styles: `
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 16px; padding-top: 8px; }
    .wide { grid-column: 1 / -1; }
    @media (max-width: 600px) { .form-grid { grid-template-columns: 1fr; } }
  `,
})
export class CreateGameDialog implements OnInit {
  private readonly adminApi = inject(AdminService);
  private readonly notifier = inject(Notifier);
  private readonly ref = inject<MatDialogRef<CreateGameDialog, AdminGame>>(MatDialogRef);

  protected readonly maps = signal<AdminMap[]>([]);
  protected readonly busy = signal(false);

  protected readonly form = inject(FormBuilder).nonNullable.group({
    id: ['', [Validators.required, Validators.pattern(GAME_ID_PATTERN)]],
    name: ['', Validators.required],
    mapId: ['', Validators.required],
    opensAt: [''],
    closesAt: [toLocalInput(new Date(Date.now() + 24 * 3600_000))],
    maxPlayers: [6, [Validators.required, Validators.min(1)]],
    npcCount: [0, [Validators.required, Validators.min(0)]],
    tags: [''],
  });

  ngOnInit(): void {
    this.adminApi.adminMaps().subscribe({
      next: (maps) => {
        this.maps.set(maps);
        if (maps.length && !this.form.controls.mapId.value) this.onMap(maps[0].id);
      },
      error: (e) => this.notifier.error(e),
    });
  }

  protected onMap(mapId: string): void {
    const map = this.maps().find((m) => m.id === mapId);
    this.form.patchValue({ mapId, ...(map ? { maxPlayers: map.starts } : {}) });
  }

  protected submit(): void {
    if (this.form.invalid) return;
    const v = this.form.getRawValue();
    const req: CreateGameRequest = {
      id: v.id.trim(),
      name: v.name.trim(),
      mapId: v.mapId,
      opensAt: fromLocalInput(v.opensAt),
      closesAt: fromLocalInput(v.closesAt),
      maxPlayers: Number(v.maxPlayers),
      npcCount: Number(v.npcCount),
      tags: parseTags(v.tags),
    };
    this.busy.set(true);
    this.adminApi
      .adminCreateGame(req)
      .pipe(finalize(() => this.busy.set(false)))
      .subscribe({
        next: (game) => {
          this.notifier.info('create.created', { name: game.name });
          this.ref.close(game);
        },
        error: (e) => this.notifier.error(e),
      });
  }
}
