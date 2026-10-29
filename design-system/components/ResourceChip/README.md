# ResourceChip

The value of a resource, optionally with its end-of-round change.

**What the caller provides:** `kind` (`arany` | `pp` | `legit` | `nep` | `ado`, legacy: `bp` | `ke`), `value`, `delta` (signed number).

- A negative change is `danger` colored and shown with a real minus sign (−).
- In the header they sit in one row, wrapping as needed.
- The `arany`, `pp`, `legit`, `nep` and `ado` kinds get a filled game icon (`GameIcon`), the rest a line icon.
