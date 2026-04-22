--Queries for F1 2025 Abu Dhabi SQL analysis project
--Divided into categories:
-- -lap analysis
-- -qualifying session analysis
-- -race results

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


--Fastest laps by each lap
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



-- 2) Qualifying session analysis

--Fastest laps by each session
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


--Average lap time by each qualifying session
SELECT AVG(q1_time) AS Q1_avg_lap_time, 
AVG(q2_time) AS Q2_avg_lap_time,
AVG(q3_time) AS Q3_avg_lap_time
FROM f1_q_results;


--Average Q1 lap time by each team
SELECT team, AVG(q1_time) AS average_time FROM f1_q_results
GROUP BY team
ORDER BY average_time;


--Worst driver in qualifying session by team
WITH Q_results AS(
SELECT full_name, team,
ROW_NUMBER() OVER(PARTITION BY team ORDER BY pos) AS rnk
FROM f1_q_results
)
SELECT full_name, team
FROM Q_results 
WHERE rnk = 2
ORDER BY team;
