# Tabs

Tabs within a view. On the phone they scroll horizontally.

**What the caller provides:** `tabs` (`[{id, label, badge?}]`), `active`, `onChange` (if not provided, the component manages the state itself).

- `badge` is only for the number of unread reports.
- Per tab `art` (game icon) and `tone` (`vasarter` | `varoshaza` | `alvilag`): underlines the selected tab with the branch's color.
