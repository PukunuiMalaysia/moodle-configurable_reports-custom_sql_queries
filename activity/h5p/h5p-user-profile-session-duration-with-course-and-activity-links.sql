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
 FROM_UNIXTIME(MIN(a.timemodified)) AS session_start,
 FROM_UNIXTIME(MAX(a.timemodified)) AS session_end,
 ROUND(SUM(a.duration) / 60.0) AS total_mins,
 CONCAT('<a href="%%WWWROOT%%/mod/h5pactivity/report.php?a=', h.id, '&userid=', u.id, '">', h.name, '</a>') AS activity_name
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
