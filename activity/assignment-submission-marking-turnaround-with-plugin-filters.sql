/*
 Configurable Reports plugin filters required for this SQL:

 1) Student full-name text search
    %%FILTER_SEARCHTEXT_student:CONCAT(u.firstname,' ',u.lastname):~%%
    - Searches concatenated first+last name.

 2) Subcategory filter (category tree path)
    %%FILTER_SUBCATEGORIES:cc.path%%
    - Restricts report by course category/subcategory path.

 3) Course selector
    %%FILTER_COURSES:a.course%%
    - Restricts report to selected course(s).

 4) Marker text search
    %%FILTER_SEARCHTEXT_marker:ug.firstname:~%%
    - Currently searches marker FIRST NAME only.

 5) Marking month text search
    %%FILTER_SEARCHTEXT_month:MONTHNAME(FROM_UNIXTIME(ag.timemodified + 28800)):~%%
    - Filters by computed month name (timezone adjusted with +28800).

 6) Marking year text search
    %%FILTER_SEARCHTEXT_year:YEAR(FROM_UNIXTIME(ag.timemodified + 28800)):~%%
    - Filters by computed marking year.

 Notes:
 - +28800 applies UTC+8 conversion inside SQL for displayed dates and date-based filters.
 - Status values new/draft/reopened are treated as not submitted for marking metrics.
*/
SELECT
 c.fullname AS "Course name",
 a.name AS "Assignment name",
 u.username AS "Username",
 CONCAT(u.firstname, ' ', u.lastname) AS "Student name",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE FROM_UNIXTIME(sub.timemodified + 28800)
 END AS "Submission date",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE FROM_UNIXTIME(ag.timemodified + 28800)
 END AS "Marking date",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE YEAR(FROM_UNIXTIME(ag.timemodified + 28800))
 END AS "Marking(Year)",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE MONTHNAME(FROM_UNIXTIME(ag.timemodified + 28800))
 END AS "Marking(Month)",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE ROUND((ag.timemodified - sub.timemodified)/86400, 1)
 END AS "Duration(Day)",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE ROUND(ag.grade, 1)
 END AS "Grade",

 CASE
 WHEN sub.status IN ('new','draft','reopened') THEN NULL
 ELSE CONCAT(ug.firstname, ' ', ug.lastname)
 END AS "Marker",

 CONCAT(
 '<a target="_blank" href="%%WWWROOT%%/mod/assign/view.php?id=',
 cm.id,
 '&action=grader&userid=',
 u.id,
 '&attemptnumber=-1',
 '">Grade</a>'
 ) AS "Assignment link",

 sub.status AS "Status",
 afc.commenttext AS "Comments"

FROM prefix_assign_submission sub
JOIN prefix_assign a
 ON a.id = sub.assignment
JOIN prefix_user u
 ON u.id = sub.userid %%FILTER_SEARCHTEXT_student:CONCAT(u.firstname,' ',u.lastname):~%%
JOIN prefix_course c
 ON c.id = a.course
JOIN prefix_course_categories cc
 ON cc.id = c.category

JOIN prefix_course_modules cm
 ON cm.instance = a.id
JOIN prefix_modules m
 ON m.id = cm.module AND m.name = 'assign'

JOIN prefix_context cxt
 ON cxt.instanceid = c.id AND cxt.contextlevel = 50
JOIN prefix_role_assignments ra
 ON ra.contextid = cxt.id AND ra.roleid = 5 AND ra.userid = u.id

LEFT JOIN prefix_assign_grades ag
 ON ag.assignment = sub.assignment
 AND ag.userid = sub.userid
 AND (ag.attemptnumber = sub.attemptnumber OR ag.attemptnumber IS NULL)

LEFT JOIN prefix_user ug
 ON ug.id = ag.grader

LEFT JOIN prefix_assignfeedback_comments afc
 ON afc.grade = ag.id

WHERE
 (sub.latest = 1 OR sub.latest IS NULL)
 AND u.deleted = 0
 AND cm.deletioninprogress = 0

 %%FILTER_SUBCATEGORIES:cc.path%%
 %%FILTER_COURSES:a.course%%
 %%FILTER_SEARCHTEXT_marker:ug.firstname:~%%
 %%FILTER_SEARCHTEXT_month:MONTHNAME(FROM_UNIXTIME(ag.timemodified + 28800)):~%%
 %%FILTER_SEARCHTEXT_year:YEAR(FROM_UNIXTIME(ag.timemodified + 28800)):~%%

ORDER BY c.fullname, a.name, u.lastname, u.firstname
