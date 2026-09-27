# ResourceChip

Egy erőforrás értéke, opcionálisan a kör végi változással.

**Mit ad a hívó:** `kind` (`arany` | `pp` | `legit` | `nep` | `ado`, régiek: `bp` | `ke`), `value`, `delta` (előjeles szám).

- A negatív változás `danger` színű, és valódi mínuszjellel (−) jelenik meg.
- A fejlécben egy sorban, tördelhetően legyenek.
- Az `arany`, `pp`, `legit`, `nep` és `ado` fajta teli játékikont kap (`GameIcon`), a többi vonalikont.
