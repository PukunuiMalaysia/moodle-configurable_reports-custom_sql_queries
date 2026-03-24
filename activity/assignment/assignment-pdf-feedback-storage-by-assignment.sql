-- Purpose: Summarize assignment PDF feedback conversion storage by assignment.
SELECT 
 c.fullname AS course_name,
 a.id AS assignment_id,
 a.name AS assignment_name,
 CONCAT('<a target="_new" href="%%WWWROOT%%/mod/assign/view.php?id=', cm.id, '">Assignment Link</a>') AS assignment_url,
 ROUND(SUM(f.filesize) / (1024 * 1024 * 1024), 2) AS total_storage_gb
FROM 
 prefix_files f
JOIN 
 prefix_context con ON f.contextid = con.id AND con.contextlevel = 70
JOIN 
 prefix_course_modules cm ON cm.id = con.instanceid
JOIN 
 prefix_modules m ON m.id = cm.module AND m.name = 'assign'
JOIN 
 prefix_assign a ON a.id = cm.instance
JOIN 
 prefix_course c ON cm.course = c.id
WHERE 
 f.component = 'assignfeedback_editpdf'
GROUP BY 
 a.id
ORDER BY 
 total_storage_gb DESC
