SELECT
 'Course Content' AS Type,
 c.fullname AS Name,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 LEFT JOIN prefix_course_modules cm ON ctx.instanceid = cm.id AND ctx.contextlevel = 70
 JOIN prefix_course c ON (
 (ctx.contextlevel = 50 AND ctx.instanceid = c.id) OR
 (ctx.contextlevel = 70 AND cm.course = c.id)
 )
WHERE
 f.filename != '.'
 AND f.component != 'backup' 
 AND f.component != 'tool_recyclebin'
GROUP BY
 c.id, c.fullname

UNION ALL

SELECT
 'User Private Files' AS Type,
 CONCAT(u.firstname, ' ', u.lastname) AS Name,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 JOIN prefix_user u ON ctx.instanceid = u.id
WHERE
 ctx.contextlevel = 30 -- User context
 AND f.filename != '.'
 AND f.component = 'user'
 AND f.filearea = 'private'
GROUP BY
 u.id, u.firstname, u.lastname

UNION ALL

SELECT
 'Automated Backup' AS Type,
 c.fullname AS Name,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 JOIN prefix_course c ON ctx.instanceid = c.id
WHERE
 f.component = 'backup'
 AND f.filearea = 'automated'
 AND f.filename != '.'
GROUP BY
 c.id, c.fullname

UNION ALL

SELECT
 'Recycle Bin' AS Type,
 COALESCE(c.shortname, 'Deleted Course') AS Name,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 LEFT JOIN prefix_course c ON ctx.instanceid = c.id
WHERE
 f.component = 'tool_recyclebin'
 AND f.filename != '.'
GROUP BY
 c.id, c.shortname

ORDER BY
 Size_GB DESC
