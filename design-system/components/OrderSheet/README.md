# OrderSheet

The round's order sheet: the queued actions with their costs, the PP total and sealing.

**What the caller provides:** `orders` (`[{label, city, faction?, note?, cost: {pp, arany, bp, ke}, hidden?}]`), `available` (PP), `round`, `sealed`, `onSeal`.

- Sealing happens with the `seal` button. This is the only place where the sealing wax color appears.
- When PP is exceeded, the total turns `danger` colored and the seal button is disabled.
- A hidden action is marked by a grey „Rejtett” (Hidden) label in the `share-unknown` color, the same one used for the Unknown row of the influence bar.
- Per order `art`: the action id; it gets a branch-colored tiled icon at the start of the row.
