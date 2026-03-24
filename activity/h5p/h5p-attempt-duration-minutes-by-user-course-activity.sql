SELECT 
 u.id AS userid,
 u.firstname,
 u.lastname,
 c.fullname AS course_name,
 h.name AS activity_name,
 ROUND(SUM(a.duration) / 60.0) AS total_duration_minutes
FROM 
 prefix_user AS u
JOIN 
 prefix_h5pactivity_attempts AS a ON u.id = a.userid
JOIN 
 prefix_h5pactivity AS h ON a.h5pactivityid = h.id
JOIN 
 prefix_course AS c ON h.course = c.id
GROUP BY 
 u.id, c.id, h.id
ORDER BY 
 u.lastname, u.firstname, c.fullname, h.name
