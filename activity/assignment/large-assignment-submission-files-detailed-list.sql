-- Purpose: List large assignment submission files with student/course/assignment context.
SELECT
 a.name AS 'Assignment Name',
 c.fullname AS 'Course Name',
 CONCAT(u.firstname, ' ', u.lastname) AS 'Student Name',
 f.filename AS 'File Name',
 ROUND(f.filesize / 1048576.0, 2) AS 'File Size (MB)',
 FROM_UNIXTIME(f.timemodified) AS 'Time Modified',
 CONCAT('<a target="_new" href="%%WWWROOT%%/mod/assign/view.php?id=', cm.id, '">Assignment Link</a>') AS 'Assignment URL'
FROM
 prefix_files f
JOIN prefix_assign_submission asub ON f.itemid = asub.id
JOIN prefix_assign a ON asub.assignment = a.id
JOIN prefix_course_modules cm ON cm.instance = a.id
JOIN prefix_modules m ON m.id = cm.module AND m.name = 'assign'
JOIN prefix_course c ON cm.course = c.id
JOIN prefix_user u ON f.userid = u.id
WHERE
 f.component = 'assignsubmission_file' AND
 f.filearea = 'submission_files'
ORDER BY
 f.filesize DESC
