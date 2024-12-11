SELECT 
    sa2."sa2_code", 
    sa2."sa2_name", 
    SUM(unemployment."total_unemployment") AS total_unemployment,
    (SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) AS unemployment_per_1000_people,
    AVG(SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) OVER () AS mean_unemployment_per_1000,
    STDDEV_POP(SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) OVER () AS stddev_unemployment_per_1000,
    CASE
        WHEN STDDEV_POP(SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) OVER () = 0 THEN NULL
        ELSE ((SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) - 
              AVG(SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) OVER ()) / 
              STDDEV_POP(SUM(unemployment."total_unemployment") / (SUM(population."total_people") / 1000.0)) OVER ()
    END AS z_score
INTO z_unemployments
FROM 
    sa2
JOIN 
    unemployment ON sa2."sa2_code" = unemployment."sa2_code"
JOIN 
    population ON sa2."sa2_code" = population."sa2_code"
WHERE 
    population."total_people" > 100
GROUP BY 
    sa2."sa2_code", 
    sa2."sa2_name"
ORDER BY 
    "sa2_code" ASC, 
    "sa2_name" ASC;
	
