WITH CombinedZScores AS (
    SELECT  
        DISTINCT S."sa2_code",
        S."sa2_name",
        ROUND(B.z_score_businesses_per_1000, 2) AS business,
        ROUND(ST.z_score_total_stops, 2) AS stops,
        ROUND(PO.z_score_total_polling, 2) AS polls,
        ROUND(CAST((SC.z_score_catchment_area_per_1000_young_people) AS numeric), 2) AS schools,
        ROUND(H.z_score, 2) AS hospitals,
        ROUND(U.z_score, 2) AS unemployment,
        (B.z_score_businesses_per_1000 + 
         ST.z_score_total_stops + 
         PO.z_score_total_polling + 
         SC.z_score_catchment_area_per_1000_young_people +
         H.z_score +
         U.z_score) AS combined_z_score
    FROM 
        sa2 S
        JOIN z_businesses B ON S."sa2_code" = B."sa2_code"
        JOIN z_stops ST ON S."sa2_code" = ST."sa2_code"
        JOIN z_polls PO ON S."sa2_code" = PO."sa2_code"
        JOIN z_schools SC ON S."sa2_code" = SC."sa2_code"
        JOIN z_hospitals H ON S."sa2_code" = H."sa2_code"
        JOIN z_unemployments U ON S."sa2_code" = U."sa2_code"
)
SELECT 
    "sa2_code",
    "sa2_name",
    business,
    stops,
    polls,
    schools,
    hospitals,
    unemployment,
    ROUND(CAST((1 / (1 + EXP(-combined_z_score))) AS numeric), 2) AS final_score
INTO final_score
FROM 
    CombinedZScores
ORDER BY 
    "sa2_code" ASC;
	
