# InfluenceBar

The distribution of a faction's 100 support points: houses, Unknown (hidden) and Neutral, with the 10 / 25 / 35 thresholds.

**What the caller provides:** `faction` (`nemesseg` | `kereskedok` | `katonasag`), `segments` (`[{name, tincture, value, self?}]`, open influence), `unknown` (all hidden points), `precision` (`exact` | `band5` | `band10`, according to the visibility level), optionally `aside` (for example a `ControlBadge`), `thresholds={false}`, `legend={false}`.

- The Neutral value is the remainder: the component computes it, not the caller.
- The player's own segment (`self`) gets a verdigris outline and always appears with its exact value in the legend.
- Segments are separated by a 2px paper gap, so two similar tinctures stay distinct, and the legend also gives the names in text.
- Do not color by faction: the bar's colors always mean **houses**.
- The Unknown row is visible to every player with a presence. The bar never says whose it is.
