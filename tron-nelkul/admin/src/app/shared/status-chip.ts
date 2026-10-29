import { Component, computed, input } from '@angular/core';
import { STATUS_KEYS } from '../core/labels';
import { TPipe } from '../core/t.pipe';

@Component({
  selector: 'app-status-chip',
  imports: [TPipe],
  template: `<span class="chip" [class]="'chip status-' + status()">{{ label() | t }}</span>`,
})
export class StatusChip {
  readonly status = input.required<string>();
  protected readonly label = computed(() => STATUS_KEYS[this.status()] ?? this.status());
}
