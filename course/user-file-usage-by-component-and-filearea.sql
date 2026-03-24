SELECT
 u.username,
 u.firstname,
 u.lastname,
 f.component,
 f.filearea,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 JOIN prefix_user u ON ctx.instanceid = u.id
WHERE
 ctx.contextlevel = 30 -- User Context
 AND f.filename != '.'
GROUP BY
 u.id, u.username, u.firstname, u.lastname, f.component, f.filearea
ORDER BY
 Size_GB DESC
