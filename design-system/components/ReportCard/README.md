# ReportCard

A report from the round's results: kind, source quality, round, title and the chronicle sentence.

**What the caller provides:** `kind` (`kem` | `katonai` | `frakcio` | `diplomacia` | `esemeny`), `confidence` (`gyenge` | `kozepes` | `eros`, only for spy reports), `tick` (for example „7. kör · 20:00”, round 7 · 20:00), `title`, `children` (the chronicle sentence), optionally `footer` (buttons).

- The sentence is in the `chronicle` style, italic serif text: the voice of the world. Numbers go into the title or the footer, not the sentence.
- Source quality is shown with three bars and text. For a weak source the text should be uncertain („valószínűleg”, probably).
