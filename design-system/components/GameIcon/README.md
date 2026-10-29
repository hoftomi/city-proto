# GameIcon

A filled, illustrative icon for the game's things: resource, good, branch of power and action. Control icons (navigation, status) remain the `Icon` line icons.

**What the caller provides:** `name`, `size` (default 20), `label` (if the icon carries meaning on its own), `tile` (`true` = the tile of the action's branch; or `vasarter` | `varoshaza` | `alvilag` | `kozos`).

- Resource: `arany`, `pp`, `legit`, `nep`, `ado`.
- Good: `gabona`, `bor`, `vas`, `ko`, `so`, `hal`, `fuszer`, `tozeg`, `csempesz`, `gyapju`, `lo`.
- Branch: `vasarter`, `varoshaza`, `alvilag`.
- Action: `route`, `margin`, `buyShares`, `buyout`, `defend`, `foundParty`, `program`, `festival`, `news`, `hireSpy`, `guard`, `spy`, `verify`, `debunk`.

For an unknown name it falls back to the line icon. The paints are the `ic-*` tokens; the tile color comes from the `branch-*` tokens.

Related props in other components:

- `Button`: `art` (game icon before the label, instead of `icon`).
- `Tabs`: per tab `art` (icon) and `tone` (branch-colored underline).
- `OrderSheet`: per order `art` (the action's tiled icon).
- `ResourceChip`: the `arany`, `pp`, `legit`, `nep`, `ado` kinds automatically get a game icon.
