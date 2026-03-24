-- Purpose: Inventory files with context links, size, and uploader details.
SELECT
 CASE
 WHEN ctx.contextlevel = 70 THEN CONCAT('<a target="_new" href="%%WWWROOT%%/mod/', m.name, '/view.php?id=', cm.id, '">', m.name, ' module</a>')
 WHEN ctx.contextlevel = 50 THEN CONCAT('<a target="_new" href="%%WWWROOT%%/course/view.php?id=', ctx.instanceid, '">Course</a>')
 WHEN ctx.contextlevel = 30 THEN CONCAT('<a target="_new" href="%%WWWROOT%%/user/view.php?id=', ctx.instanceid, '">User profile</a>')
 ELSE 'Other context'
 END AS 'Link',
 CASE
 WHEN ctx.contextlevel = 70 THEN c.fullname
 ELSE NULL
 END AS 'Course Name',
 CASE
 WHEN ctx.contextlevel = 30 THEN CONCAT(cu.firstname, ' ', cu.lastname)
 ELSE NULL
 END AS 'User Name',
 f.component AS 'Component',
 f.filearea AS 'File Area',
 f.filename AS 'File Name',
 ROUND(f.filesize / 1048576.0, 2) AS 'File Size (MB)',
 FROM_UNIXTIME(f.timemodified) AS 'Time Modified',
 CONCAT(u.firstname, ' ', u.lastname) AS 'Uploaded by'
FROM
 prefix_files f
JOIN prefix_context ctx ON f.contextid = ctx.id
LEFT JOIN prefix_course_modules cm ON ctx.contextlevel = 70 AND ctx.instanceid = cm.id
LEFT JOIN prefix_modules m ON cm.module = m.id
LEFT JOIN prefix_course c ON ctx.contextlevel = 70 AND cm.course = c.id
LEFT JOIN prefix_user cu ON ctx.contextlevel = 30 AND ctx.instanceid = cu.id
LEFT JOIN prefix_user u ON f.userid = u.id
WHERE
 f.filesize > 0
ORDER BY
 f.filesize DESC
