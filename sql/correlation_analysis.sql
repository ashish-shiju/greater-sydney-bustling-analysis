WITH score_income AS (
	SELECT
		i."sa2_code" as "code",
		i."median_income" as "name",
		ts."final_score" as "score"
	from
		income i
	join 
		final_score ts on i."sa2_code" = ts."sa2_code"
)

SELECT 
	corr(j."name", j."score") AS correlation
FROM 
	score_income j

	