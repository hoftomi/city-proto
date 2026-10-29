-- Trón nélkül 0.0.3 – egyetlen játékmód fix tempóval (1 hónap, napi 2 elszámolás, 2 óra érlelés),
-- és a lezárult játékok archívuma. A lezárult játék a games táblából az archived_* táblákba költözik.

create table archived_games (
    id         varchar(40)  primary key,
    name       varchar(80)  not null,
    map_id     varchar(40)  not null,
    opens_at   timestamptz,
    tags       varchar(300) not null default '',
    mode       varchar(20)  not null default 'polgar',
    winner     varchar(80),
    created_at timestamptz  not null
);

create table archived_players (
    id         uuid primary key,
    game_id    varchar(40) not null references archived_games (id) on delete cascade,
    user_id    uuid references users (id),
    house_name varchar(40) not null,
    tincture   varchar(20) not null,
    background varchar(20),
    start_slot varchar(40),
    npc        boolean     not null default false,
    persona    varchar(20),
    start_good varchar(40),
    legit      integer     not null default 0,
    created_at timestamptz not null
);
create index ix_archived_players_game on archived_players (game_id);
create index ix_archived_players_user on archived_players (user_id);

create table archived_reports (
    id         uuid primary key,
    game_id    varchar(40)   not null references archived_games (id) on delete cascade,
    player_id  uuid          not null references archived_players (id) on delete cascade,
    settlement integer       not null,
    kind       varchar(20)   not null,
    confidence varchar(20),
    title      varchar(200)  not null,
    body       varchar(2000) not null,
    tone       varchar(20)   not null,
    is_public  boolean       not null default false,
    created_at timestamptz   not null
);
create index ix_archived_reports_player on archived_reports (game_id, player_id, created_at desc);

-- A már lezárult játékok átköltöztetése
insert into archived_games (id, name, map_id, opens_at, tags, mode, winner, created_at)
    select id, name, map_id, opens_at, tags, mode, winner, created_at from games where status = 'FINISHED';
insert into archived_players (id, game_id, user_id, house_name, tincture, background, start_slot, npc, persona, start_good, legit, created_at)
    select p.id, p.game_id, p.user_id, p.house_name, p.tincture, p.background, p.start_slot, p.npc, p.persona, p.start_good, p.legit, p.created_at
    from players p join games g on g.id = p.game_id where g.status = 'FINISHED';
insert into archived_reports (id, game_id, player_id, settlement, kind, confidence, title, body, tone, is_public, created_at)
    select r.id, r.game_id, r.player_id, r.settlement, r.kind, r.confidence, r.title, r.body, r.tone, r.is_public, r.created_at
    from reports r join games g on g.id = r.game_id where g.status = 'FINISHED';
delete from games where status = 'FINISHED';

-- games: a jelentkezés zárása az indulás; a tempó a kódban rögzített
alter table games rename column starts_at to closes_at;
alter table games drop column season;
alter table games drop column days;
alter table games drop column rounds_per_day;
alter table games drop column settlements;
alter table games drop column maturation_minutes;
alter table games drop column time_offset_minutes;
alter table games drop column winner;
