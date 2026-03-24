-- Purpose: List courses not modified in the last 6 years.
SELECT c.id, c.fullname, c.shortname, FROM_UNIXTIME(c.timemodified) AS last_modified, 
CONCAT('<a href="%%WWWROOT%%/course/view.php?id=', c.id, '" target="_blank">', c.fullname, '</a>') AS course_link
FROM prefix_course AS c
WHERE c.timemodified < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 6 YEAR))
ORDER BY c.timemodified
