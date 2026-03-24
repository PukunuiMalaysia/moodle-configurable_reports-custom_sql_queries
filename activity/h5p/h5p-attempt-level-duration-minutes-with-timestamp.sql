-- Purpose: List H5P attempts with per-attempt duration and timestamp.
SELECT 
 u.id AS userid,
 u.firstname,
 u.lastname,
 c.fullname AS course_name,
 h.name AS activity_name,
 a.id AS attempt_id,
 ROUND(a.duration / 60.0) AS duration_minutes,
 FROM_UNIXTIME(a.timemodified) AS attempt_time -- Converting timestamp to human-readable format
FROM 
 prefix_user AS u
JOIN 
 prefix_h5pactivity_attempts AS a ON u.id = a.userid
JOIN 
 prefix_h5pactivity AS h ON a.h5pactivityid = h.id
JOIN 
 prefix_course AS c ON h.course = c.id
ORDER BY 
 u.lastname, u.firstname, c.fullname, h.name, a.timemodified
