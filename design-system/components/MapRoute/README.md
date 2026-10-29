# MapRoute

An edge on the map, with the state of the route on it.

**What the caller provides:** `from`, `to` (`[x, y]`), `state` (`base` | `own` | `pending` | `rival` | `blocked` | `closed`), `tincture` (for the `rival` state).

- `base`: dotted, unbuilt road. `own`: thick verdigris. `pending`: dashed verdigris, active from the next round. `rival`: the rival house's tincture. `blocked`: Roadblock, `danger` colored, with a prohibition sign in the middle. `closed`: closure caused by an event, grey and dashed.
