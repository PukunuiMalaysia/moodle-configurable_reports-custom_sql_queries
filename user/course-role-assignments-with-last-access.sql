-- Purpose: List course role assignments with user last access per course.
SELECT 
 u.firstname AS "First Name",
 u.lastname AS "Last Name",
 u.email AS "Email",
 r.shortname AS "Role",
 c.fullname AS "Course",
 FROM_UNIXTIME(ul.timeaccess) AS "Last Access"
FROM
 prefix_role_assignments ra
JOIN
 prefix_user u ON u.id = ra.userid
JOIN
 prefix_role r ON r.id = ra.roleid
JOIN
 prefix_context ctx ON ctx.id = ra.contextid
JOIN
 prefix_course c ON c.id = ctx.instanceid
JOIN
 prefix_user_lastaccess ul ON ul.userid = ra.userid AND ul.courseid = ctx.instanceid
WHERE
 ctx.contextlevel = 50
