-- Purpose: List MP4 files for a target course and linked activity/course locations.
SELECT
 f.filename,
 ROUND(f.filesize / 1024 / 1024, 2) AS filesize_mb,
 
 -- This creates a clickable HTML link using the location name
 CONCAT(
 '<a href="',
 CASE 
 WHEN c.contextlevel = 50 THEN CONCAT('%%WWWROOT%%/course/view.php?id=', c.instanceid)
 WHEN c.contextlevel = 70 THEN CONCAT('%%WWWROOT%%/mod/', m.name, '/view.php?id=', cm.id)
 ELSE '#'
 END,
 '" target="_blank">',
 CASE 
 WHEN c.contextlevel = 50 THEN 'Course Main Page'
 WHEN c.contextlevel = 70 THEN CONCAT(UPPER(m.name), ': ', COALESCE(a.name, 'View Activity'))
 ELSE 'Unknown Location'
 END,
 '</a>'
 ) AS location

FROM
 prefix_files f
JOIN
 prefix_context c ON c.id = f.contextid

-- Join to identify the specific activity/module
LEFT JOIN
 prefix_course_modules cm ON cm.id = c.instanceid AND c.contextlevel = 70
LEFT JOIN
 prefix_modules m ON m.id = cm.module

-- Join to Assignment specifically to get the name for submissions
LEFT JOIN
 prefix_assign_submission s ON s.id = f.itemid AND f.component = 'assignsubmission_file'
LEFT JOIN
 prefix_assign a ON a.id = s.assignment

WHERE
 f.filename <> '.'
 AND f.filename LIKE '%.mp4'
 AND (
 -- Filter specifically for Course 13
 (c.contextlevel = 50 AND c.instanceid = 13)
 OR
 -- Filter for all child contexts (activities) of Course 13
 (c.contextlevel = 70 AND c.path LIKE CONCAT('%/', (
 SELECT id FROM prefix_context WHERE contextlevel = 50 AND instanceid = 13
 ), '/%'))
 )

ORDER BY
 location, f.filename
