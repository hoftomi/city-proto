-- Tron Nelkul 0.0.4 – every data id is English now (statuses, mode, backgrounds, personas, goods, margins, programs,
-- news templates, report kinds, tinctures, start slots, estate nodes, seed game ids). Game states, players and reports
-- hold the old ids and are not converted: game data is wiped, and on startup SeedData recreates the sample games.
-- Users stay.
delete from archived_reports;
delete from archived_players;
delete from archived_games;
delete from reports;
delete from players;
delete from games;

alter table games alter column mode set default 'citizen';
alter table archived_games alter column mode set default 'citizen';
