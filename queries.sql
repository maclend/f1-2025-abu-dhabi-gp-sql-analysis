--Queries for F1 2025 Abu Dhabi SQL analysis project
--Divided into categories:
-- -lap analysis
-- -qualifying session analysis
-- -race results analysis

-- 1) Lap analysis

-- Fastest lap
SELECT driver, MIN(lap_time) AS fastest_lap 
FROM f1_lap_times
GROUP BY driver
ORDER BY fastest_lap
LIMIT 1;


-- Average pace
WITH avg_times AS(
SELECT driver, AVG(lap_time) AS avg_lap_time
FROM f1_lap_times
GROUP BY driver
)
SELECT driver, avg_lap_time, avg_lap_time - MIN(avg_lap_time) OVER() AS difference 
FROM avg_times
ORDER BY avg_lap_time;


-- Fastest laps per lap
WITH laps AS(
SELECT lap_number, driver, 
ROW_NUMBER() OVER(PARTITION BY lap_number ORDER BY lap_time) AS rnk
FROM f1_lap_times)
SELECT lap_number, driver FROM laps WHERE rnk = 1;


-- Fastest sectors
WITH S1 AS(
SELECT driver, sector1,
ROW_NUMBER() OVER(ORDER BY sector1) AS rnk
FROM f1_lap_times
),
S2 AS(
SELECT driver, sector2,
ROW_NUMBER() OVER(ORDER BY sector2) AS rnk
FROM f1_lap_times
),
S3 AS(
SELECT driver, sector3,
ROW_NUMBER() OVER(ORDER BY sector3) AS rnk
FROM f1_lap_times
)
SELECT 'Sector 1' AS sector, driver, sector1 AS time
FROM S1
WHERE rnk = 1
UNION ALL
SELECT 'Sector 2', driver, sector2
FROM S2
WHERE rnk = 1
UNION ALL
SELECT 'Sector 3', driver, sector3
FROM S3
WHERE rnk = 1;


-- Fastest laps by each driver
WITH laps AS(
SELECT driver, lap_number, lap_time,
ROW_NUMBER() OVER(PARTITION BY driver ORDER BY lap_time) AS rnk
FROM f1_lap_times)
SELECT full_name, lap_number, lap_time
FROM laps
JOIN f1_race_results
ON f1_race_results.abbreviation = laps.driver
WHERE rnk = 1
ORDER BY lap_time;


-- Max Verstappen's lap-by-lap performance
SELECT lap_number, lap_time, 
lap_time - LAG(lap_time) OVER(ORDER BY lap_number) AS delta
FROM f1_lap_times
WHERE driver = 'VER'
ORDER BY lap_number;


-- Ideal lap combining best sectors of each driver
SELECT full_name,
MIN(sector1) + MIN(sector2) + MIN(sector3) AS ideal_lap
FROM f1_lap_times
JOIN f1_race_results
ON f1_lap_times.driver = f1_race_results.abbreviation
GROUP BY full_name
ORDER BY ideal_lap;


-- 2) Qualifying session analysis

-- Fastest laps by each session
WITH Q1 AS(
SELECT full_name, q1_time,
ROW_NUMBER() OVER(ORDER BY q1_time) AS rnk
FROM f1_q_results),
Q2 AS(
SELECT full_name, q2_time,
ROW_NUMBER() OVER(ORDER BY q2_time) AS rnk
FROM f1_q_results),
Q3 AS(
SELECT full_name, q3_time,
ROW_NUMBER() OVER(ORDER BY q3_time) AS rnk
FROM f1_q_results)
SELECT 'Q1' AS qualifying_session, full_name, q1_time 
FROM Q1
WHERE rnk = 1
UNION ALL
SELECT 'Q2', full_name, q2_time 
FROM Q2
WHERE rnk = 1
UNION ALL
SELECT 'Q3', full_name, q3_time 
FROM Q3
WHERE rnk = 1;


-- Average lap time by each qualifying session
SELECT AVG(q1_time) AS Q1_avg_lap_time, 
AVG(q2_time) AS Q2_avg_lap_time,
AVG(q3_time) AS Q3_avg_lap_time
FROM f1_q_results;


-- Average Q1 lap time by each team
SELECT team, AVG(q1_time) AS average_time FROM f1_q_results
GROUP BY team
ORDER BY average_time;


-- Worst performing driver in qualifying session per team
WITH Q_results AS(
SELECT full_name, team,
ROW_NUMBER() OVER(PARTITION BY team ORDER BY pos) AS rnk
FROM f1_q_results
)
SELECT full_name, team
FROM Q_results 
WHERE rnk = 2
ORDER BY team;



-- 3) Race results analysis

-- Lapped vs not lapped drivers
SELECT COUNT(CASE WHEN status = 'Lapped' THEN 1 END) AS Lapped,
COUNT(CASE WHEN status = 'Finished' THEN 1 END) AS Not_lapped
FROM f1_race_results;


-- Points by each team
SELECT team_name, SUM(points) AS points
FROM f1_race_results
GROUP BY team_name
ORDER BY points DESC;


-- Positions gained by each driver
SELECT full_name,  (grid_pos - pos) AS pos_gained
FROM f1_race_results
ORDER BY pos_gained DESC;


-- Better driver by each team
WITH race AS(
SELECT team_name, full_name,
ROW_NUMBER() OVER(PARTITION BY team_name ORDER BY pos) AS rnk
FROM f1_race_results
)
SELECT team_name, full_name
FROM race
WHERE rnk = 1;
