import { Component, inject } from '@angular/core';
import { FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { TPipe } from '../../core/t.pipe';

/** AdvanceRequest.minutes: 1 minute to 7 days. */
export const MAX_ADVANCE_MINUTES = 7 * 24 * 60;

/** Asks for a custom number of minutes; closes with the number. */
@Component({
  selector: 'app-advance-dialog',
  imports: [ReactiveFormsModule, MatButtonModule, MatDialogModule, MatFormFieldModule, MatInputModule, TPipe],
  template: `
    <h2 mat-dialog-title>{{ 'advance.custom_title' | t }}</h2>
    <mat-dialog-content>
      <mat-form-field class="full">
        <mat-label>{{ 'advance.minutes' | t }}</mat-label>
        <input matInput type="number" min="1" [max]="max" [formControl]="minutes" (keyup.enter)="ok()" />
        <mat-hint>{{ 'advance.minutes_hint' | t: { max: max } }}</mat-hint>
      </mat-form-field>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>{{ 'common.cancel' | t }}</button>
      <button mat-flat-button [disabled]="minutes.invalid" (click)="ok()">{{ 'advance.submit' | t }}</button>
    </mat-dialog-actions>
  `,
  styles: `.full { width: 100%; margin-top: 8px; }`,
})
export class AdvanceDialog {
  private readonly ref = inject<MatDialogRef<AdvanceDialog, number>>(MatDialogRef);
  protected readonly max = MAX_ADVANCE_MINUTES;
  protected readonly minutes = new FormControl<number>(60, {
    nonNullable: true,
    validators: [Validators.required, Validators.min(1), Validators.max(MAX_ADVANCE_MINUTES)],
  });

  protected ok(): void {
    if (this.minutes.valid) this.ref.close(Number(this.minutes.value));
  }
}
