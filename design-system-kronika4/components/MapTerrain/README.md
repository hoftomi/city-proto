# MapTerrain

A táj részletes, festett rétege: minden elem saját rajz, árnyékkal és fénnyel.

**Mit ad a hívó** (mind opcionális):

- `sea`: tenger útvonal; a part mentén homok, sekély és mély víz, háromsoros tajték és hullámjelek.
- `rivers`: útvonal vagy `{d, w}` (szélesség); homokpart, mély meder, sodorvonal.
- `bridges` (`[x, y, szög]`): kőhíd ívekkel.
- `lakes` (`[x, y, rx, ry]`), `islands` (`[x, y, méret]`).
- `mountains` (`[x, y, méret]`): hegy napos és árnyékos oldallal, gerincvonalakkal, sraffozással, hósapkával, lábánál kövekkel.
- `hills`: dombok.
- `forests` (`[x, y, méret, fenyőarány]`): sűrű, vegyes erdő erdőtalaj-árnyékkal.
- `farms` (`[x, y, oszlop, sor, forgatás, tanya]`): mozaikos szántók sövénnyel, bokrokkal, legelő birkákkal és tanyával.
- `fields`, `villages` (`[x, y, házszám]`), `windmills`, `mines`, `lighthouses`, `ships`, `whales`, `marsh`.
- `labels` (`[x, y, szöveg, 'sea' | 'region', forgatás]`): tájnév, tengernév.
