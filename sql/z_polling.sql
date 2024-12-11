-- Create the spatial index on the geometry columns
CREATE INDEX sa2_geometry_idx ON sa2 USING GIST (geometry);
CREATE INDEX polling_geometry_idx ON polling USING GIST (geometry);

-- Create temporary table pollingstats
CREATE TEMP TABLE pollingstatistics AS
SELECT 
    sa2."sa2_code", 
    sa2."sa2_name",
    population."total_people",
    COUNT(polling."polling_place_name") AS total_polling
FROM 
    sa2
LEFT OUTER JOIN 
    polling ON ST_Contains(sa2."geometry", polling."geometry")
JOIN 
    population ON sa2."sa2_code" = population."sa2_code"
WHERE 
    population."total_people" > 100 
GROUP BY 
    sa2."sa2_code", sa2."sa2_name", population."total_people"
ORDER BY 
    sa2."sa2_code" ASC;

-- Create temporary table avg_stddev_pollings
CREATE TEMP TABLE avg_stddev_polling AS
SELECT
    AVG(total_polling) AS mean_total_polling,
    STDDEV_POP(total_polling) AS stddev_total_polling
FROM 
    pollingstatistics;

-- Select and compute z-scores, then store in z_polls
SELECT 
    ps."sa2_code", 
    ps."sa2_name", 
    ps."total_people",
    ps."total_polling",
    ms."mean_total_polling",
    ms."stddev_total_polling",
    CASE
        WHEN ms."stddev_total_polling" = 0 THEN NULL
        ELSE (ps."total_polling" - ms."mean_total_polling") / ms."stddev_total_polling"
    END AS z_score_total_polling
INTO z_polls
FROM 
    pollingstatistics ps, avg_stddev_polling ms
ORDER BY 
    ps."sa2_code", 
    ps."sa2_name";