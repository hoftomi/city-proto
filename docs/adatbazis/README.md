# Database schema

The PostgreSQL schema of the Trón nélkül backend (`tron-nelkul/backend`) after the Flyway V1–V3 migrations, and the internal structure of the `games.state` JSONB column (`engine/EngineState.java`).

- [`tron_nelkul.dbml`](tron_nelkul.dbml): editable ERD with field-level notes. Open it on [dbdiagram.io](https://dbdiagram.io) (new diagram, paste the file's contents); there the tables can be dragged around and the diagram exported as PNG/PDF/SQL.
- The Mermaid diagrams below render on GitHub and in the VS Code Markdown preview, and can also be edited on [mermaid.live](https://mermaid.live).

## Relational tables

```mermaid
erDiagram
  users ||--o{ user_identities : "external accounts"
  users |o--o{ players : "houses"
  games ||--o{ players : "participants"
  games ||--o{ reports : "reports"
  players ||--o{ reports : "recipient"
  archived_games ||--o{ archived_players : "houses"
  archived_games ||--o{ archived_reports : "reports"
  archived_players ||--o{ archived_reports : "recipient"
  users |o--o{ archived_players : "houses"
  users {
    uuid id PK "internal id"
    varchar display_name "display name"
    varchar role "PLAYER or ADMIN"
    timestamptz created_at "time of registration"
  }
  user_identities {
    uuid id PK "id"
    uuid user_id FK "owning user"
    varchar provider "google, apple, discord"
    varchar subject "account id at the provider"
    varchar email "e-mail, if any"
  }
  games {
    varchar id PK "readable game id"
    varchar name "game name"
    varchar status "announced/open/running"
    varchar map_id "map from the catalog"
    timestamptz opens_at "registration opens"
    timestamptz closes_at "registration closes = start"
    int max_players "capacity"
    int npc_count "number of NPC houses"
    varchar tags "tags, comma-separated"
    varchar mode "game mode (citizen)"
    jsonb state "full engine state"
    timestamptz created_at "created at"
  }
  archived_games {
    varchar id PK "readable game id"
    varchar name "game name"
    varchar map_id "map from the catalog"
    timestamptz opens_at "registration opens"
    varchar tags "tags, comma-separated"
    varchar mode "game mode"
    varchar winner "winning house"
    timestamptz created_at "created at"
  }
  archived_players {
    uuid id PK "id of the players row"
    varchar game_id FK "finished game it belongs to"
    uuid user_id FK "owner, empty for NPCs"
    varchar house_name "house name"
    varchar tincture "crest color"
    boolean npc "computer house?"
    int legit "final Legitimacy"
    int place "final place, 1 = winner"
    varchar etc "other columns: as in players"
  }
  archived_reports {
    uuid id PK "id of the reports row"
    varchar game_id FK "finished game it belongs to"
    uuid player_id FK "recipient house"
    varchar etc "other columns: as in reports"
  }
  players {
    uuid id PK "house id"
    varchar game_id FK "game it belongs to"
    uuid user_id FK "owner, empty for NPCs"
    varchar house_name "house name, unique within a game"
    varchar tincture "crest color"
    varchar background "merchant/noble/shadow"
    varchar start_slot "starting estate"
    boolean npc "computer house?"
    varchar persona "NPC strategy"
    varchar start_good "merchant's starting good"
    int legit "Legitimacy for the lobby"
    timestamptz created_at "joined at"
  }
  reports {
    uuid id PK "id"
    varchar game_id FK "game it belongs to"
    uuid player_id FK "recipient house"
    int settlement "settlement number"
    varchar kind "spy/faction/diplomacy/event"
    varchar confidence "reliability of a spy report"
    varchar title "title"
    varchar body "text, max 2000"
    varchar tone "info/ok/warn"
    boolean is_public "public chronicle?"
    timestamptz created_at "by the game clock"
  }
```

## The `games.state` JSONB (EngineState)

These are not real tables: the relationships are string ids and the database does not check them.

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
  Intel ||--o{ Offer : "for sale"
  EngineState {
    long clock "time processed so far, ms"
    int settlements "settlements completed"
    long seq "internal id counter"
    map festivals "city|house: last festival"
    map protection "city|good|house: protected until"
  }
  PlayerSt {
    string id PK "players.id as a string"
    string name "house name"
    string tincture "crest color"
    string persona "NPC strategy"
    string background "background"
    string estate "estate node"
    double gold "gold"
    int pp "command points"
    int legit "Legitimacy"
    int lastInfoSale "last info sale"
    boolean npc "computer house?"
    long nextPlanAt "next sealing by the NPC"
    map verified "news: was it true"
  }
  CitySt {
    string city PK "city id, map key"
    map pop "house: popularity 0-100"
    map parties "house: party program"
    map council "house: council seats"
    map spies "house: number of spies"
    map guards "house: number of guards"
    double lastTaxPool "last tax base"
  }
  Good {
    string good PK "good id, map key"
    string name "display name"
    int supply "supply"
    int demand "demand"
    map shares "house: share points"
    map margins "house: margin level"
    map sold "house: last sale"
    list history "last 3 profit/point"
  }
  Edge {
    string player FK "owning house, map key"
    string from "start node"
    string to "end node"
  }
  Order {
    string id PK "order id"
    string type "order type"
    string city "target city"
    string good "target good"
    string level "level or program"
    string target "target house"
    string template "news template"
    string newsId "affected news item"
    string lapId "affected order sheet"
    string orderId "affected order"
    string from "route start"
    string to "route end"
    int pts "points"
    int gold "reserved gold"
  }
  Lap {
    string id PK "order sheet id"
    string player FK "owning house"
    long sealedAt "sealing time"
    long executeAt "execution time"
    int pp "reserved command points"
    int gold "reserved gold"
  }
  News {
    string id PK "news id"
    string city "city"
    string author FK "author house"
    string target FK "affected house"
    string template "template"
    string good "affected good"
    string goodName "name of the good"
    int effect "size of the effect"
    boolean trueAtCreation "true when created?"
    boolean debunked "debunked?"
    long createdAt "created at, ms"
  }
  MarketEvent {
    string type "buyout/defend/defendUsed"
    string city "city"
    string good "good"
    string by FK "initiating house"
    string target FK "affected house"
    string lapId "source order sheet"
    string orderId "source order"
    int settlement "settlement number"
  }
  Intel {
    string id PK "intel id"
    string owner FK "who knows it"
    string lapId FK "scouted sheet"
    string of FK "whose sheet"
    long executeAt "execution of the sheet"
    list lines "lines learned"
    int depth "scouting depth"
    boolean bought "bought?"
    list offeredTo "offered to"
  }
  Offer {
    string id PK "offer id"
    string intelId FK "intel being sold"
    string seller FK "selling house"
    string buyer FK "buying house"
    int price "price, paid on acceptance"
  }
```
