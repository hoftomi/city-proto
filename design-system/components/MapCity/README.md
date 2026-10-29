# MapCity

The marker and label of a city-state on the map.

**What the caller provides:** `x`, `y`, `name`, `keyCity`, `state` (`reachable` | `unreachable` | `cut`), `stability`, `labelSide` (`right` | `left`).

- `reachable`: verdigris halo, i.e. it is part of your network and you can act there.
- `unreachable`: dashed, faint. None of your routes lead there (4.3).
- `cut`: `danger` colored. A cut-off city where your influence remains but no new action can be started (4.6).
- A key city appears larger, with a filled core and a `map-label-major` label. An unstable city has a „!” or „!!” mark above the dot.
