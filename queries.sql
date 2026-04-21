--Queries for F1 2025 Abu Dhabi SQL analysis project
--Divided into categories:
-- -lap analysis
-- -qualifying results
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
