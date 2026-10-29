# CommandPoints

The Command Point counter: the available points, those reserved on the order sheet, and the empty slots, up to the storage cap of 20.

**What the caller provides:** `available` (the PP you have), `pending` (the PP reserved on the order sheet), optionally `daily` (default 10) and `max` (default 20).

- A filled dot is a spendable point, a dashed seal-colored one is reserved.
- Show it once, in the header at the top of the screen. Elsewhere `ResourceChip kind="pp"` is the short form.
