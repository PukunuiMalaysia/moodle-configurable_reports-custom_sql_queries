-- Purpose: List backup files with context details and course backup manage link when applicable.
SELECT
 f.id AS 'File ID',
 f.filename AS 'File Name',
 ROUND(f.filesize / 1048576, 2) AS 'File Size (MB)',
 FROM_UNIXTIME(f.timecreated) AS 'Created Time',
 f.filearea AS 'Backup Type',
 CASE
 WHEN ctx.contextlevel = 50 THEN 'Course'
 WHEN ctx.contextlevel = 30 THEN 'User'
 ELSE 'Other'
 END AS 'Context Type',
 CASE
 WHEN ctx.contextlevel = 50 THEN c.fullname
 WHEN ctx.contextlevel = 30 THEN CONCAT(u.firstname, ' ', u.lastname)
 ELSE 'N/A'
 END AS 'Associated With',
 CASE
 WHEN ctx.contextlevel = 50 THEN CONCAT('<a href="%%WWWROOT%%/backup/restorefile.php?contextid=', ctx.id, '">Manage backup</a>')
 ELSE 'No direct link'
 END AS 'Manage Link'
FROM
 prefix_files f
JOIN prefix_context ctx ON f.contextid = ctx.id
LEFT JOIN prefix_course c ON ctx.contextlevel = 50 AND ctx.instanceid = c.id
LEFT JOIN prefix_user u ON ctx.contextlevel = 30 AND ctx.instanceid = u.id
WHERE
 f.component = 'backup'
ORDER BY
 f.filesize DESC
