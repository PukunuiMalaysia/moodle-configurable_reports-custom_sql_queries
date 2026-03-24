SELECT 
 c.fullname AS course_name,
 CONCAT(u.firstname, ' ', u.lastname) AS full_name,
 u.email,
 FROM_UNIXTIME(MIN(a.timemodified)) AS session_start,
 FROM_UNIXTIME(MAX(a.timemodified)) AS session_end,
 ROUND(SUM(a.duration) / 60.0) AS total_duration_minutes,
 h.name AS activity_name
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
 c.fullname, 
 u.lastname, 
 u.firstname, 
 h.name
