-- Admin time advance: the game clock is real time + time_offset_minutes (only a running game's clock is moved).
alter table games add column time_offset_minutes integer not null default 0;
