# ControlBadge

An actor's control level in a faction or city: five steps from Presence to Protectorate.

**What the caller provides:** `level` (`jelenlet` | `partner` | `dominans` | `varoskontroll` | `protektoratus`, or empty if there is no presence).

- The number of steps and the text carry the meaning together; the color (verdigris) only highlights.
- Always compute the level from **open** influence. Hidden influence does not give a level.
