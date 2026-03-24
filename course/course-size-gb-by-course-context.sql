SELECT 
 CONCAT('<a href="%%WWWROOT%%/course/view.php?id=', c.id, '">', c.fullname, '</a>') AS course_name,
 ROUND(SUM(f.filesize) / (1024 * 1024 * 1024), 2) AS course_size_gb
FROM 
 prefix_course c
JOIN 
 prefix_context ctx ON c.id = ctx.instanceid AND ctx.contextlevel = 50
JOIN 
 prefix_files f ON f.contextid = ctx.id
GROUP BY 
 c.id, c.fullname
ORDER BY 
 course_size_gb DESC
