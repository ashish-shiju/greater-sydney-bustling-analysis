-- SELECT *
-- --     sa2."SA2_CODE21", 
-- --     sa2."SA2_NAME21",
SELECT 
    sa2."SA2_CODE21",
    sa2."SA2_NAME21",
	ST_Area(catchments.geometry::geography),
	catchments."USE_DESC",
	(population."0-4_people" + population."5-9_people" + population."10-14_people" + population."15-19_people") AS total_young_people

FROM
    sa2
JOIN
    catchments ON ST_Intersects(sa2.geometry, catchments.geometry)
JOIN 
    population ON sa2."SA2_CODE21" = population."sa2_code"
WHERE 
    population."total_people" > 100 
-- GROUP BY
--     sa2."SA2_CODE21",
--     sa2."SA2_NAME21",
-- 	total_young_people
ORDER BY
    sa2."SA2_CODE21" ASC;


