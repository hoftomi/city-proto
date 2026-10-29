# Toast

Short feedback after an action or processing, in four tones.

**What the caller provides:** `tone` (`info` | `ok` | `warn` | `danger`), `title`, `children`, optionally `icon`.

- The title says what happened („Lebuktál Feketerévben”, You were exposed in Feketerév), the body the consequence and what to do.
- The `danger` tone is `role="alert"`, the others `status`.
