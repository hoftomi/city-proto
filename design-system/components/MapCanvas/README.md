# MapCanvas

A térképlap: papír alap, fokhálózat és egy SVG-vászon, amelybe a `MapRoute`, `MapEstate` és `MapCity` elemek kerülnek (ebben a sorrendben, hogy a városok legyenek felül).

**Mit ad a hívó:** `width`, `height` (a viewBox mérete), `grid` (a fokhálózat lépésköze, alapérték 40), `title`, `children`.

- A vászon kitölti a szélességet, és arányosan skálázódik. Telefonon a teljes szélességet kapja, 16px margóval.
