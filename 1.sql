--Count the number of Movies vs TV Shows
SELECT 
	show_type,
	COUNT(*)
FROM 
	netflix
GROUP by
	show_type