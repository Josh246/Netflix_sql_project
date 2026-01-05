--Find the top 5 countries with the most content on Netflix
SELECT 
	TRIM(country_name) AS country,
	COUNT(*) AS total_content
FROM 
	netflix
	CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name
WHERE 
	country_name IS NOT NULL
GROUP BY 
	country_name 
ORDER BY 
	total_content DESC
LIMIT 5;

