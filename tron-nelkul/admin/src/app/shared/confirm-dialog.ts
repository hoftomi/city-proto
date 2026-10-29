import { Component, inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { Observable, map } from 'rxjs';
import { TPipe } from '../core/t.pipe';
import { TParams } from '../core/translator';

export interface ConfirmData {
  title: string;
  message: string;
  params?: TParams;
  confirm?: string;
  danger?: boolean;
}

/** Yes/no dialog; title, message and confirm are translation keys. */
@Component({
  selector: 'app-confirm-dialog',
  imports: [MatDialogModule, MatButtonModule, TPipe],
  template: `
    <h2 mat-dialog-title>{{ data.title | t: data.params }}</h2>
    <mat-dialog-content>{{ data.message | t: data.params }}</mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button [mat-dialog-close]="false">{{ 'common.cancel' | t }}</button>
      <button
        mat-flat-button
        [class.danger]="data.danger"
        [mat-dialog-close]="true"
        cdkFocusInitial
      >
        {{ data.confirm ?? 'common.confirm' | t }}
      </button>
    </mat-dialog-actions>
  `,
})
export class ConfirmDialog {
  readonly data = inject<ConfirmData>(MAT_DIALOG_DATA);
}

/** Opens the confirm dialog; emits true only on confirmation. */
export function confirm(dialog: MatDialog, data: ConfirmData): Observable<boolean> {
  return dialog
    .open(ConfirmDialog, { data, width: '440px' })
    .afterClosed()
    .pipe(map((r) => r === true));
}
