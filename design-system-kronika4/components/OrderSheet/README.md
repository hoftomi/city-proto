# OrderSheet

The order sheet as a scroll, with a dark wooden header and the bronze title „Parancslap” (Order sheet).

**What the caller provides:** `orders` (`[{label, art?, city?, faction?, note?, cost, hidden?}]`), `available`, `sealed`, `onSeal`, `onRemove(i)`.

- Every row starts with the action's branch-colored tiled icon. Sealing is the bronze `seal` button.
