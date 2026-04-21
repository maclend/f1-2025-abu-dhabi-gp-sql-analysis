-- FASTEST LAP
SELECT driver, MIN(lap_time) FROM f1_lap_times
GROUP BY driver
ORDER BY MIN(lap_time)
LIMIT 1;
