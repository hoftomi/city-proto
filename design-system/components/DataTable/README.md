# DataTable

A data table for the ranking and the city overview. Number columns are right-aligned, with tabular figures.

**What the caller provides:** `columns` (`[{key, label, align?, render?}]`), `rows` (the player's own row has `self: true`), `caption`.

- On narrow screens the table scrolls inside its own container, not the page.
