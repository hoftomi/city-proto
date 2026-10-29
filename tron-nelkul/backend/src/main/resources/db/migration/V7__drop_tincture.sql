-- House tinctures are removed. Game states may still hold a `tincture` per player: it is ignored when read and dropped on the next write.
alter table players drop column tincture;
alter table archived_players drop column tincture;
