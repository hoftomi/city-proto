# ReportCard

Egy jelentés a kör eredményeiből: fajta, forrásminőség, kör, cím és a krónikás mondat.

**Mit ad a hívó:** `kind` (`kem` | `katonai` | `frakcio` | `diplomacia` | `esemeny`), `confidence` (`gyenge` | `kozepes` | `eros`, csak kémjelentésnél), `tick` (például „7. kör · 20:00”), `title`, `children` (a krónikás mondat), opcionálisan `footer` (gombok).

- A mondat `chronicle` stílusú, dőlt serif szöveg: a világ hangja. A számok a címbe vagy a láblécbe kerülnek, ne a mondatba.
- A forrásminőséget három oszlop és szöveg jelzi. Gyenge forrásnál a szöveg legyen bizonytalan („valószínűleg”).
