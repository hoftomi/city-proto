# Button

A matte, slightly convex button with a thin ink outline, a bottom rim and a soft drop shadow. It sinks 1.5px when pressed.

**What the caller provides:** `variant` (`default` | `primary` | `seal` | `quiet` | `danger`), `size` (`md` | `sm`), `icon` (an `Icon` name; if a game icon with that name exists, it gets that), `art` (a `GameIcon` name), `children`, and the usual button attributes.

- `default`: steel blue, the basic action.
- `primary`: forest green, at most one per screen.
- `seal`: bronze, in Cinzel, with a dark label, exclusively for sealing.
- `danger`: brick red, for buyouts and debunking.
- `quiet`: parchment, with a dark label.
- The label is Nunito Sans 800, light, with a soft dark shadow. The touch target is at least 44px, 34px in `sm` size.
