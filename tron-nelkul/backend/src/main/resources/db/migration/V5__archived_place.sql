-- The final place of every house is stored when the game is archived (by Legitimacy, highest first),
-- so the lobby does not rank the houses again on every request.
alter table archived_players add column place integer;

update archived_players ap set place = ranked.place
from (select id, row_number() over (partition by game_id order by legit desc) as place from archived_players) ranked
where ap.id = ranked.id;

alter table archived_players alter column place set not null;
