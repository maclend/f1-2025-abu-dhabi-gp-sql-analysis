-- LAP TIMES
CREATE TABLE f1_lap_times (
	id SERIAL PRIMARY KEY,
    driver TEXT,
    lap_number INT,
    lap_time INTERVAL,
    pos INT,
    race_time INTERVAL,
    sector1 INTERVAL,
    sector2 INTERVAL,
    sector3 INTERVAL
);

INSERT INTO f1_lap_times (
    driver,
    lap_number,
    lap_time,
    pos,
    race_time,
    sector1,
    sector2,
    sector3
)
SELECT
    driver,
    lap_number::INT,
    REPLACE(lap_time, '0 days ', '')::INTERVAL,
    pos::INT,
    REPLACE(time, '0 days ', '')::INTERVAL,
    NULLIF(sector1, '')::INTERVAL,
    NULLIF(sector2, '')::INTERVAL,
    NULLIF(sector3, '')::INTERVAL
FROM lap_times;


CREATE TABLE f1_q_results (
    id SERIAL PRIMARY KEY,
    abbreviation TEXT,
    driver_id TEXT,
    full_name TEXT,
    team TEXT,
    q1_time INTERVAL,
    q2_time INTERVAL,
    q3_time INTERVAL,
    pos INT
);



-- QUALIFYING RESULTS
INSERT INTO f1_q_results(
    abbreviation,
    driver_id,
    full_name,
    team,
    q1_time,
    q2_time,
    q3_time,
    pos
)
SELECT
    abbreviation,
    driver_id,
    full_name,
    team,
    NULLIF(REPLACE(q1_time, '0 days ', ''), '')::INTERVAL,
    NULLIF(REPLACE(q2_time, '0 days ', ''), '')::INTERVAL,
    NULLIF(REPLACE(q3_time, '0 days ', ''), '')::INTERVAL,
    pos
FROM qualifying_results;



-- RACE RESULTS
CREATE TABLE f1_race_results(
id SERIAL PRIMARY KEY,
driver INT,
broadcast_name TEXT,
abbreviation TEXT,
driver_id TEXT,
team_name TEXT,
team_color TEXT,
team_id TEXT,
first_name TEXT,
last_name TEXT,
full_name TEXT,
headshot_url TEXT,
pos INT,
classified_pos INT,		
grid_pos INT,
race_time INTERVAL,
status TEXT,
points INT,
laps INT
);

INSERT INTO f1_race_results(
driver,
broadcast_name,
abbreviation,
driver_id,
team_name,
team_color,
team_id,
first_name,
last_name,
full_name,
headshot_url,
pos,
classified_pos,		
grid_pos,
race_time,
status,
points,
laps)
SELECT
driver_nr,
broadcast_name,
abbreviation,
driver_id,
team_name,
team_color,
team_id,
first_name,
last_name,
full_name,
headshot_url,
pos::INT,
classified_pos::INT,		
grid_pos::INT,
time::INTERVAL,
status,
points::INT,
laps::INT
FROM race_results;
