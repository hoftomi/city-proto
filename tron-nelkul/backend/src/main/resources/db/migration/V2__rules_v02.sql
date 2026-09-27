-- Trón nélkül 0.0.2 – szabálykönyv v0.2 (Üzletek, Parlament, Alvilág).
-- A v0.1 állapota (befolyás, Gyanú, frakciók) nem fordítható át, ezért a játékok újraindulnak;
-- a mintajátékokat induláskor a SeedData hozza létre újra. A felhasználók megmaradnak.
delete from games;

drop table orders;
drop table suspicions;
drop table city_states;
drop table influence;
drop table routes;

-- A játék teljes állapota egy JSON-dokumentum (engine.EngineState).
alter table games drop column round;
alter table games add column settlements         integer     not null default 0;
alter table games add column maturation_minutes  integer     not null default 120;
alter table games add column time_offset_minutes integer     not null default 0;
alter table games add column mode                varchar(20) not null default 'polgar';
alter table games add column state               jsonb;

alter table players drop column pp;
alter table players drop column arany;
alter table players drop column bp;
alter table players drop column ke;
alter table players drop column favorite;
alter table players drop column npc_cooldown;
alter table players drop column sealed_round;
alter table players add column start_good varchar(40);

alter table reports rename column round to settlement;
alter table reports add column is_public boolean not null default false;
