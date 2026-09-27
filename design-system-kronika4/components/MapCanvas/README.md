# MapCanvas

A festett térkép alapja:

- réti zöld színátmenet elmosott színfoltokkal és domborzati fény-árnyék foltokkal, így a talaj nem egyszínű;
- ritkított fűcsomók és vadvirágok;
- sűrű fűtextúra és papírszemcse (`kg-grain`) az egész lapon, ettől festett és nem rajzolóprogramos a hatás;
- a bal felső sarokból érkező meleg fény és a szélek felé sötétedő vignetta;
- belső keretvonal fokbeosztással.

A lap a közös `kg-*` festett eszközkészletet (színátmenetek, szűrők) is betölti, ezt használják a hegyek, a fák és a szántók. A kontúrok lágyított tintabarna színűek.

**Mit ad a hívó:** `width`, `height`, `title`, `children`.

A lap az izometrikus `i4` színátmeneteket is betölti, így a térkép városai, hegyei, fái és szántói ugyanazzal az anyaggal rajzolódnak, mint a városnézet.
