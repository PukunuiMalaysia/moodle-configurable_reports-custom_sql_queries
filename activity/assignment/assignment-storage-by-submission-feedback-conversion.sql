-- Purpose: Compare assignment storage across submission, feedback, and conversion files.
SELECT
 a.id AS assignment_id,
 CONCAT('<a href="%%WWWROOT%%/mod/assign/view.php?id=', cm.id, '">', a.name, '</a>') AS assignment_name_link,
 ROUND(SUM(CASE WHEN files.file_type = 'submission' THEN files.filesize ELSE 0 END) / (1024 * 1024 * 1024), 2) AS submission_storage_GB,
 ROUND(SUM(CASE WHEN files.file_type = 'conversion' THEN files.filesize ELSE 0 END) / (1024 * 1024 * 1024), 2) AS conversion_storage_GB,
 ROUND(SUM(CASE WHEN files.file_type = 'feedback' THEN files.filesize ELSE 0 END) / (1024 * 1024 * 1024), 2) AS feedback_storage_GB
FROM
 prefix_assign a
JOIN (
 -- Submission Files
 SELECT DISTINCT
 asub.assignment AS assignment_id,
 f.contenthash,
 f.filesize,
 'submission' AS file_type
 FROM
 prefix_assign_submission asub
 JOIN
 prefix_files f ON f.itemid = asub.id
 WHERE
 f.filesize > 0
 AND f.component = 'assignsubmission_file'
 
 UNION ALL
 
 -- Feedback Files
 SELECT DISTINCT
 ag.assignment AS assignment_id,
 f.contenthash,
 f.filesize,
 'feedback' AS file_type
 FROM
 prefix_assign_grades ag
 JOIN
 prefix_files f ON f.itemid = ag.id
 WHERE
 f.filesize > 0
 AND f.component = 'assignfeedback_file'
 
 UNION ALL
 
 -- Conversion Files
 SELECT DISTINCT
 ag.assignment AS assignment_id,
 f.contenthash,
 f.filesize,
 'conversion' AS file_type
 FROM
 prefix_assign_grades ag
 JOIN
 prefix_files f ON f.itemid = ag.id
 WHERE
 f.filesize > 0
 AND f.component = 'assignfeedback_editpdf'
) AS files ON a.id = files.assignment_id
JOIN prefix_course_modules cm ON cm.instance = a.id AND cm.module = (
 SELECT id FROM prefix_modules WHERE name = 'assign'
)
GROUP BY
 a.id, a.name, cm.id
ORDER BY
 submission_storage_GB DESC
