# Button

A button in four variants and a small size. The default variant is the quiet, secondary action.

**What the caller provides:** `variant` (`default` | `primary` | `seal` | `quiet` | `danger`), `size` (`md` | `sm`), `icon` (an `Icon` name), `children`, and the usual button attributes.

- `primary`: on ink, at most one per screen.
- `seal`: exclusively for sealing orders.
- `danger`: outlined, for irreversible actions or ones that risk exposure (for example Lejáratás, discrediting).
- The touch target is at least 44px tall. The `sm` size may only be used inside cards.
- The button label is a verb: „Lepecsételés” (Seal), „Útvonal kiépítése” (Build route).
- `art`: a filled game icon (`GameIcon`) before the label, instead of `icon`. Use this on action buttons.
