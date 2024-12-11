-- Create the spatial index on the geom column of the stops table
CREATE INDEX stops_geometry_idx ON stops USING GIST (geometry);

-- Step 1: Calculate the total number of stops per neighborhood
CREATE TEMP TABLE stops_stats AS
SELECT 
    sa2."sa2_code", 
    sa2."sa2_name",
    population."total_people",
    COUNT(stops."stop_id") AS total_stops
FROM 
    sa2
JOIN 
    stops ON ST_Contains(sa2."geometry", stops."geometry")
JOIN 
    population ON sa2."sa2_code" = population."sa2_code"
WHERE 
    population."total_people" > 100
GROUP BY 
    sa2."sa2_code", sa2."sa2_name", population."total_people"
ORDER BY 
    sa2."sa2_code" ASC;

-- Step 2: Calculate the mean and standard deviation of the total number of stops
CREATE TEMP TABLE mean_stddev_stops AS
SELECT
    AVG(total_stops) AS mean_total_stops,
    STDDEV_POP(total_stops) AS stddev_total_stops
FROM 
    stops_stats;

-- Step 3: Compute the z-score for the number of stops for each neighborhood
SELECT 
    ss."sa2_code", 
    ss."sa2_name", 
    ss."total_people",
    ss."total_stops",
    ms."mean_total_stops",
    ms."stddev_total_stops",
    CASE
        WHEN ms."stddev_total_stops" = 0 THEN NULL
        ELSE (ss."total_stops" - ms."mean_total_stops") / ms."stddev_total_stops"
    END AS z_score_total_stops
INTO z_stops
FROM 
    stops_stats ss, mean_stddev_stops ms
ORDER BY 
    ss."sa2_code" ASC, 
    ss."sa2_name";
