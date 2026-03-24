WITH conv AS (
 SELECT
 a.id AS assignmentid,
 COUNT(*) AS conv_count
 FROM prefix_files f
 JOIN prefix_context ctx
 ON f.contextid = ctx.id
 AND ctx.contextlevel = 70
 JOIN prefix_course_modules cm
 ON cm.id = ctx.instanceid
 JOIN prefix_modules m
 ON m.id = cm.module
 AND m.name = 'assign'
 JOIN prefix_assign a
 ON a.id = cm.instance
 WHERE f.component = 'assignfeedback_editpdf'
 GROUP BY a.id
),
subs AS (
 SELECT
 a.id AS assignmentid,
 COUNT(*) AS subm_count
 FROM prefix_files f
 JOIN prefix_context ctx
 ON f.contextid = ctx.id
 AND ctx.contextlevel = 70
 JOIN prefix_course_modules cm
 ON cm.id = ctx.instanceid
 JOIN prefix_modules m
 ON m.id = cm.module
 AND m.name = 'assign'
 JOIN prefix_assign a
 ON a.id = cm.instance
 WHERE f.component = 'assignsubmission_file'
 AND f.filearea = 'submission_files'
 GROUP BY a.id
)
SELECT
 a.id AS assignment_id,
 a.name AS assignment_name,
 COALESCE(subs.subm_count,0) AS submission_files,
 COALESCE(conv.conv_count,0) AS conversion_files
FROM prefix_assign a
LEFT JOIN subs ON subs.assignmentid = a.id
LEFT JOIN conv ON conv.assignmentid = a.id
WHERE COALESCE(conv.conv_count,0) > 0
 AND COALESCE(subs.subm_count,0) = 0
