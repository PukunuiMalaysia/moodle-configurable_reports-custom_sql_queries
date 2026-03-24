-- Purpose: Show user-course H5P session window and totals using max-duration attempts.
SELECT 
 CONCAT('<a href="%%WWWROOT%%/course/view.php?id=', c.id, '">', c.fullname, '</a>') AS course_name,
 CONCAT(u.firstname, ' ', u.lastname) AS full_name,
 u.email,
 u.city AS city,
 u.alternatename AS alt_name,
 u.idnumber AS id_number,
 u.institution,
 u.department AS dept,
 u.phone1 AS phone,
 FROM_UNIXTIME(MIN(a.timemodified)+28800) AS session_start,
 FROM_UNIXTIME(MAX(a.timemodified)+28800) AS session_end,
 ROUND(SUM(a.duration) / 60.0) AS total_mins
FROM 
 prefix_user AS u
JOIN 
 prefix_h5pactivity_attempts AS a ON u.id = a.userid
JOIN 
 (
 SELECT 
 userid, 
 h5pactivityid, 
 MAX(duration) AS max_duration
 FROM 
 prefix_h5pactivity_attempts
 GROUP BY 
 userid, h5pactivityid
 ) AS max_attempts ON a.userid = max_attempts.userid 
 AND a.h5pactivityid = max_attempts.h5pactivityid 
 AND a.duration = max_attempts.max_duration
JOIN 
 prefix_h5pactivity AS h ON a.h5pactivityid = h.id
JOIN 
 prefix_course AS c ON h.course = c.id
GROUP BY 
 u.id, c.id
ORDER BY 
 c.fullname, 
 u.lastname, 
 u.firstname
