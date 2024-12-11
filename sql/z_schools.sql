-- Create the spatial index on the geometry column of the catchments table
CREATE INDEX catchments_geometry_idx ON catchments USING GIST (geometry);

-- Create the temporary table catchmentstats
CREATE TEMP TABLE catchmentstats AS
SELECT 
    sa2."sa2_code",
    sa2."sa2_name",
    (population."0-4_people" + population."5-9_people" + population."10-14_people" + population."15-19_people") AS total_young_people,
    SUM(ST_Area(catchments.geometry::geography)) AS total_catchment_area,
    (SUM(ST_Area(catchments.geometry::geography)) / 
     NULLIF((population."0-4_people" + population."5-9_people" + population."10-14_people" + population."15-19_people"), 0)) * 1000 AS catchment_area_per_1000_young_people
FROM
    sa2
JOIN
    catchments ON ST_Intersects(sa2.geometry, catchments.geometry)
JOIN 
    population ON sa2."sa2_code" = population."sa2_code"
WHERE 
    population."total_people" > 100 
GROUP BY
    sa2."sa2_code",
    sa2."sa2_name",
    population."0-4_people", 
    population."5-9_people", 
    population."10-14_people", 
    population."15-19_people"
ORDER BY
    sa2."sa2_code" ASC;

-- Create the temporary table meanstddev_catchment
CREATE TEMP TABLE meanstddev_catchment AS
SELECT
    AVG(catchment_area_per_1000_young_people) AS mean_catchment_area_per_1000_young_people,
    STDDEV_POP(catchment_area_per_1000_young_people) AS stddev_catchment_area_per_1000_young_people
FROM 
    catchmentstats;

-- Select and compute z-scores, then store in z_schools
SELECT 
    cs."sa2_code",
    cs."sa2_name",
    cs.total_young_people,
    cs.total_catchment_area,
    cs.catchment_area_per_1000_young_people,
    ms.mean_catchment_area_per_1000_young_people,
    ms.stddev_catchment_area_per_1000_young_people,
    CASE
        WHEN ms.stddev_catchment_area_per_1000_young_people = 0 THEN NULL
        ELSE (cs.catchment_area_per_1000_young_people - ms.mean_catchment_area_per_1000_young_people) / ms.stddev_catchment_area_per_1000_young_people
    END AS z_score_catchment_area_per_1000_young_people
INTO z_schools
FROM 
    catchmentstats cs, meanstddev_catchment ms
ORDER BY 
    cs."sa2_code", 
    cs."sa2_name";
