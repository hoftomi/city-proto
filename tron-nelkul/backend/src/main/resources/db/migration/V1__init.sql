-- Trón nélkül 0.0.1 – kezdő séma

create table users (
    id           uuid primary key,
    display_name varchar(80)  not null,
    role         varchar(20)  not null default 'PLAYER',
    created_at   timestamptz  not null
);

create table user_identities (
    id        uuid primary key,
    user_id   uuid         not null references users (id) on delete cascade,
    provider  varchar(20)  not null,
    subject   varchar(200) not null,
    email     varchar(320),
    constraint uq_identity unique (provider, subject)
);

create table games (
    id             varchar(40)  primary key,
    name           varchar(80)  not null,
    season         varchar(80)  not null,
    status         varchar(20)  not null,
    map_id         varchar(40)  not null,
    starts_at      timestamptz,
    opens_at       timestamptz,
    days           integer      not null,
    rounds_per_day integer      not null,
    max_players    integer      not null,
    npc_count      integer      not null,
    tags           varchar(300) not null default '',
    round          integer      not null default 0,
    winner         varchar(80),
    created_at     timestamptz  not null
);

create table players (
    id           uuid primary key,
    game_id      varchar(40) not null references games (id) on delete cascade,
    user_id      uuid references users (id),
    house_name   varchar(40) not null,
    tincture     varchar(20) not null,
    background   varchar(20),
    start_slot   varchar(40),
    npc          boolean     not null default false,
    persona      varchar(20),
    favorite     varchar(20),
    pp           integer     not null,
    arany        integer     not null,
    bp           integer     not null,
    ke           integer     not null,
    legit        integer     not null default 0,
    npc_cooldown integer     not null default 0,
    sealed_round integer     not null default 0,
    created_at   timestamptz not null,
    constraint uq_player_user unique (game_id, user_id)
);
create unique index uq_player_house on players (game_id, lower(house_name));
create index ix_players_game on players (game_id);

create table routes (
    id        uuid primary key,
    game_id   varchar(40) not null references games (id) on delete cascade,
    player_id uuid        not null references players (id) on delete cascade,
    node_a    varchar(60) not null,
    node_b    varchar(60) not null
);
create index ix_routes_game on routes (game_id);

create table influence (
    id           uuid primary key,
    game_id      varchar(40)      not null references games (id) on delete cascade,
    city         varchar(40)      not null,
    faction      varchar(20)      not null,
    player_id    uuid             not null references players (id) on delete cascade,
    open_value   double precision not null,
    hidden_value double precision not null
);
create index ix_influence_game on influence (game_id);

create table city_states (
    id        uuid primary key,
    game_id   varchar(40) not null references games (id) on delete cascade,
    city      varchar(40) not null,
    stability varchar(20) not null,
    constraint uq_city_state unique (game_id, city)
);

create table suspicions (
    id         uuid primary key,
    game_id    varchar(40) not null references games (id) on delete cascade,
    player_id  uuid        not null references players (id) on delete cascade,
    city       varchar(40) not null,
    faction    varchar(20) not null,
    value      integer     not null,
    last_round integer     not null
);
create index ix_suspicions_game on suspicions (game_id);

create table orders (
    id         uuid primary key,
    game_id    varchar(40) not null references games (id) on delete cascade,
    player_id  uuid        not null references players (id) on delete cascade,
    round      integer     not null,
    type       varchar(20) not null,
    city       varchar(40),
    faction    varchar(20),
    hidden     boolean     not null default false,
    target_id  uuid,
    node_from  varchar(60),
    node_to    varchar(60),
    created_at timestamptz not null
);
create index ix_orders_game on orders (game_id);

create table reports (
    id         uuid primary key,
    game_id    varchar(40)   not null references games (id) on delete cascade,
    player_id  uuid          not null references players (id) on delete cascade,
    round      integer       not null,
    kind       varchar(20)   not null,
    confidence varchar(20),
    title      varchar(200)  not null,
    body       varchar(2000) not null,
    tone       varchar(20)   not null,
    created_at timestamptz   not null
);
create index ix_reports_player on reports (game_id, player_id, created_at desc);
