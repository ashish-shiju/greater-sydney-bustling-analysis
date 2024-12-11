SELECT DISTINCT F."sa2_code", F."sa2_name", F."final_score", S."geometry"
FROM final_score F
JOIN sa2 S ON (F."sa2_code" = S."sa2_code")
ORDER BY F."sa2_code" ASC;


