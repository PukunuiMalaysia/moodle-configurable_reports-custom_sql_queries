/*
 Purpose:
   Report graded exam results with course filter and time-window filters.

 Configurable Reports plugin filters required:
 1) Course filter:
    %%FILTER_COURSES:c.id%%

 2) Start time filter (grade modified timestamp, UNIX epoch):
    %%FILTER_STARTTIME:gg.timemodified:>%%

 3) End time filter (grade modified timestamp, UNIX epoch):
    %%FILTER_ENDTIME:gg.timemodified:<%%

 Notes:
 - Custom profile field filter has been removed (no uid.fieldid restriction).
 - NRIC still reads from user profile data table (uid.data) when available.
 - FROM_UNIXTIME(gg.timemodified) displays DB/session-timezone interpreted datetime.
*/
SELECT 
 u.id AS UserID,
 u.firstname AS FirstName,
 u.lastname AS LastName,
 u.username AS UserName,
 REPLACE(uid.data, '-', '') AS NRIC,
 u.email AS Email,
 c.id AS CourseID,
 CONCAT('<a href="%%WWWROOT%%/course/view.php?id=', c.id, '">', c.fullname, '</a>') AS CourseName,
 gi.itemname AS ExamName,
 gg.finalgrade AS Grade,
 FROM_UNIXTIME(gg.timemodified) AS GradeTimestamp
FROM 
 prefix_user u
JOIN 
 prefix_user_enrolments ue ON u.id = ue.userid
LEFT JOIN
 prefix_user_info_data uid ON u.id = uid.userid
JOIN 
 prefix_enrol e ON ue.enrolid = e.id
JOIN 
 prefix_course c ON e.courseid = c.id
JOIN 
 prefix_grade_items gi ON c.id = gi.courseid
JOIN 
 prefix_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id
WHERE
 u.suspended = 0
 AND 1 %%FILTER_COURSES:c.id%%
 AND 1 %%FILTER_STARTTIME:gg.timemodified:>%% %%FILTER_ENDTIME:gg.timemodified:<%%
