WITH businesses_stats AS (
    SELECT 
        sa2."sa2_code", 
        sa2."sa2_name", 
        population."total_people",
        SUM(businesses."total_businesses") AS total_businesses,
        (SUM(businesses."total_businesses") / (population."total_people" / 1000.0)) AS businesses_per_1000_people,
        AVG(SUM(businesses."total_businesses") / (population."total_people" / 1000.0)) OVER () AS mean_businesses_per_1000,
        STDDEV_POP(SUM(businesses."total_businesses") / (population."total_people" / 1000.0)) OVER () AS stddev_businesses_per_1000
    FROM 
        sa2
    JOIN 
        population ON sa2."sa2_code" = population."sa2_code"
    JOIN 
        businesses ON sa2."sa2_code" = businesses."sa2_code"
    WHERE 
        population."total_people" > 100 AND 
        businesses."industry_code" IN ('D', 'G', 'H', 'I', 'J', 'O', 'P', 'Q')
    GROUP BY 
        sa2."sa2_code", 
        sa2."sa2_name", 
        population."total_people"
)
SELECT 
    "sa2_code", 
    "sa2_name", 
    "total_people",
    total_businesses,
	mean_businesses_per_1000,
	stddev_businesses_per_1000,
    businesses_per_1000_people,

    (businesses_per_1000_people - mean_businesses_per_1000) / stddev_businesses_per_1000 AS z_score_businesses_per_1000
INTO z_businesses
FROM 
    businesses_stats
ORDER BY 
    "sa2_code" ASC, 
    "sa2_name" ASC;

