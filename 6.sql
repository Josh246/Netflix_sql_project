--Find content added in the last 5 years
SELECT
	*
FROM 
	netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'