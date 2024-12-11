-- Create the spatial index on the geometry column of the hospitals table
CREATE INDEX hospitals_geometry_idx ON hospitals USING GIST (geometry);

-- Create a Common Table Expression (CTE) for hospital counts
WITH hospital_counts AS (
    SELECT 
        sa2."sa2_code", 
        sa2."sa2_name",
        COUNT(hospitals."hospital_name") as "total_hospitals"
    FROM 
        sa2
    LEFT OUTER JOIN 
        hospitals ON ST_Intersects(sa2."geometry", hospitals."geometry")
    JOIN 
        population ON sa2."sa2_code" = population."sa2_code"
    WHERE 
        population."total_people" > 100 
    GROUP BY 
        sa2."sa2_code", sa2."sa2_name"
),

-- Create a CTE for statistics
stats AS (
    SELECT 
        AVG("total_hospitals") AS mean_hospitals,
        STDDEV("total_hospitals") AS stddev_hospitals
    FROM 
        hospital_counts
)

-- Select and compute z-scores, then store in z_hospitals
SELECT 
    hc."sa2_code", 
    hc."sa2_name",
    hc."total_hospitals",
    mean_hospitals,
    stddev_hospitals,
    (hc."total_hospitals" - s.mean_hospitals) / s.stddev_hospitals AS z_score
INTO z_hospitals
FROM 
    hospital_counts hc, stats s
ORDER BY 
    hc."sa2_code" ASC;