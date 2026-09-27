# Adatbázis-séma

A Trón nélkül backend (`tron-nelkul/backend`) PostgreSQL-sémája a Flyway V1 + V2 migrációk után, és a `games.state` JSONB oszlop belső szerkezete (`engine/EngineState.java`).

- [`tron_nelkul.dbml`](tron_nelkul.dbml): szerkeszthető ERD mezőszintű megjegyzésekkel. Nyisd meg a [dbdiagram.io](https://dbdiagram.io)-n (új diagram, a fájl tartalmát illeszd be), ott a táblák húzhatók és az ábra PNG/PDF/SQL formátumban exportálható.
- Az alábbi Mermaid-ábrák a GitHubon és a VS Code Markdown-előnézetében jelennek meg, és a [mermaid.live](https://mermaid.live) oldalon is szerkeszthetők.

## Relációs táblák

```mermaid
erDiagram
  users ||--o{ user_identities : "külső fiókok"
  users |o--o{ players : "házai"
  games ||--o{ players : "résztvevők"
  games ||--o{ reports : "jelentések"
  players ||--o{ reports : "címzett"
  users {
    uuid id PK "belső azonosító"
    varchar display_name "megjelenített név"
    varchar role "PLAYER vagy ADMIN"
    timestamptz created_at "regisztráció ideje"
  }
  user_identities {
    uuid id PK "azonosító"
    uuid user_id FK "melyik felhasználóé"
    varchar provider "google, apple, discord"
    varchar subject "fiók-ID a szolgáltatónál"
    varchar email "e-mail, ha van"
  }
  games {
    varchar id PK "olvasható játék-ID"
    varchar name "játék neve"
    varchar season "szezon neve"
    varchar status "hamarosan/nyitott/fut/lezárult"
    varchar map_id "térkép a katalógusból"
    timestamptz opens_at "jelentkezés nyitása"
    timestamptz starts_at "szezon kezdete"
    int days "szezon hossza napban"
    int rounds_per_day "elszámolás naponta (2)"
    int max_players "férőhely"
    int npc_count "NPC-házak száma"
    varchar tags "címkék, vesszővel"
    int settlements "eddigi elszámolások"
    int maturation_minutes "parancs érlelési ideje"
    int time_offset_minutes "admin időeltolás"
    varchar mode "játékmód (polgar)"
    jsonb state "teljes motorállapot"
    varchar winner "győztes ház"
    timestamptz created_at "létrehozás"
  }
  players {
    uuid id PK "ház azonosító"
    varchar game_id FK "melyik játékban"
    uuid user_id FK "tulajdonos, NPC-nél üres"
    varchar house_name "háznév, játékon belül egyedi"
    varchar tincture "címerszín"
    varchar background "kereskedo/nemesi/arnyek"
    varchar start_slot "kezdő birtok"
    boolean npc "gépi ház-e"
    varchar persona "NPC stratégia"
    varchar start_good "kereskedő induló árucikke"
    int legit "Legitimitás a lobbihoz"
    timestamptz created_at "csatlakozás"
  }
  reports {
    uuid id PK "azonosító"
    varchar game_id FK "melyik játék"
    uuid player_id FK "címzett ház"
    int settlement "hányadik elszámolásnál"
    varchar kind "kem/frakcio/diplomacia/esemeny"
    varchar confidence "kémhír biztossága"
    varchar title "cím"
    varchar body "szöveg, max 2000"
    varchar tone "info/ok/warn"
    boolean is_public "nyilvános krónika-e"
    timestamptz created_at "a játék órája szerint"
  }
```

## A `games.state` JSONB (EngineState)

Ezek nem valódi táblák: a kapcsolatok szöveges azonosítók, az adatbázis nem ellenőrzi őket.

```mermaid
erDiagram
  EngineState ||--o{ PlayerSt : "players"
  EngineState ||--o{ CitySt : "cities"
  CitySt ||--o{ Good : "goods"
  EngineState ||--o{ Edge : "routes"
  EngineState ||--o{ Order : "drafts"
  EngineState ||--o{ Lap : "laps"
  Lap ||--o{ Order : "orders"
  EngineState ||--o{ News : "news"
  EngineState ||--o{ MarketEvent : "events"
  EngineState ||--o{ Intel : "intel"
  EngineState ||--o{ Offer : "offers"
  Intel ||--o{ Offer : "eladásra"
  EngineState {
    long clock "eddig feldolgozott idő, ms"
    int settlements "lefutott elszámolások"
    long seq "belső ID-számláló"
    map festivals "város|ház: utolsó fesztivál"
    map protection "város|áru|ház: védett eddig"
  }
  PlayerSt {
    string id PK "players.id szövegként"
    string name "háznév"
    string tincture "címerszín"
    string persona "NPC stratégia"
    string background "háttér"
    string estate "birtok csomópont"
    double gold "arany"
    int pp "parancspont"
    int legit "Legitimitás"
    int lastInfoSale "utolsó infóeladás"
    boolean npc "gépi ház-e"
    long nextPlanAt "NPC következő pecsételése"
    map verified "hír: igaz volt-e"
  }
  CitySt {
    string city PK "város-ID, map kulcs"
    map pop "ház: népszerűség 0-100"
    map parties "ház: pártprogram"
    map council "ház: tanácsi helyek"
    map spies "ház: kémek száma"
    map guards "ház: őrök száma"
    double lastTaxPool "utolsó adóalap"
  }
  Good {
    string good PK "árucikk-ID, map kulcs"
    string name "megjelenített név"
    int supply "kínálat"
    int demand "kereslet"
    map shares "ház: részesedés pont"
    map margins "ház: árfokozat"
    map sold "ház: utolsó eladás"
    list history "utolsó 3 haszon/pont"
  }
  Edge {
    string player FK "tulajdonos ház, map kulcs"
    string from "kezdő csomópont"
    string to "cél csomópont"
  }
  Order {
    string id PK "parancs-ID"
    string type "parancs típusa"
    string city "célváros"
    string good "célárucikk"
    string level "fokozat vagy program"
    string target "célpont ház"
    string template "hírsablon"
    string newsId "érintett hír"
    string lapId "érintett parancslap"
    string orderId "érintett parancs"
    string from "útvonal eleje"
    string to "útvonal vége"
    int pts "pontok"
    int gold "lefoglalt arany"
  }
  Lap {
    string id PK "parancslap-ID"
    string player FK "tulajdonos ház"
    long sealedAt "pecsételés ideje"
    long executeAt "végrehajtás ideje"
    int pp "lefoglalt parancspont"
    int gold "lefoglalt arany"
  }
  News {
    string id PK "hír-ID"
    string city "város"
    string author FK "szerző ház"
    string target FK "érintett ház"
    string template "sablon"
    string good "érintett árucikk"
    string goodName "árucikk neve"
    int effect "hatás mértéke"
    boolean trueAtCreation "igaz volt-e születéskor"
    boolean debunked "megcáfolták-e"
    long createdAt "létrehozás, ms"
  }
  MarketEvent {
    string type "buyout/defend/defendUsed"
    string city "város"
    string good "árucikk"
    string by FK "kezdeményező ház"
    string target FK "érintett ház"
    string lapId "forrás parancslap"
    string orderId "forrás parancs"
    int settlement "elszámolás sorszáma"
  }
  Intel {
    string id PK "felderítés-ID"
    string owner FK "ki tudja"
    string lapId FK "kifürkészett lap"
    string of FK "kinek a lapja"
    long executeAt "a lap végrehajtása"
    list lines "megismert sorok"
    int depth "felderítés mélysége"
    boolean bought "vásárolt-e"
    list offeredTo "kiknek ajánlották"
  }
  Offer {
    string id PK "ajánlat-ID"
    string intelId FK "eladott felderítés"
    string seller FK "eladó ház"
    string buyer FK "vevő ház"
    int price "ár, elfogadáskor fizet"
  }
```
