-- 10. Find each year and the average numbers of content release by India on netflix. 
-- Return top 5 year with highest avg content release !

SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM 
	netflix
WHERE 
	country = 'India' 
GROUP BY 
	country, 2
ORDER BY 
	avg_release DESC 
LIMIT 
	5