/*
 Configurable Reports plugin filters required for this SQL:

 1) Course selector
    %%FILTER_COURSES:c.id%%
    - Binds selected course(s) to c.id.

 2) User selector
    %%FILTER_USERS:u.username%%
    - Filters by Moodle user username.

 3) Assignment/activity text search (H5P activity name)
    %%FILTER_SEARCHTEXT_assignment:h.name:~%%
    - Case-insensitive LIKE-style text filter on h5p assignment name.

 4) Student text search
    %%FILTER_SEARCHTEXT_student:u.firstname:~%%
    - Currently matches FIRST NAME only.
    - If you need broader matching, consider replacing with last name/full name logic.

 Notes:
 - This query uses window functions (FIRST_VALUE, ROW_NUMBER), so DB must support them.
 - Time conversion adds +28800 seconds (UTC+8). Adjust if server timezone/report timezone differs.
*/
SELECT 
 c.fullname AS course_name, 
 h.name AS h5p_assignment_name,
 u.username,
 CONCAT(u.firstname, ' ', u.lastname) AS student_name,
 u.email,
 IF(MAX(COALESCE(ha.completion, 0)) = 1, 'Completed', 'Not Completed') AS status_completion,
 first_value(DATE_FORMAT(FROM_UNIXTIME(ha.timemodified + 28800), '%Y-%m-%d %H:%i:%s')) Over 
 (Partition by ha.userid, ha.h5pactivityid order by ha.attempt) AS date_first_attempt,
 first_value(SEC_TO_TIME(ha.duration)) Over 
 (Partition by ha.userid, ha.h5pactivityid order by ha.attempt) AS duration_first_attempt,
 first_value(ha.rawscore) Over 
 (Partition by ha.userid, ha.h5pactivityid order by ha.attempt) AS score_first_attempt,
 first_value(concat(round(( ha.rawscore/ha.maxscore * 100 ),2),'%') ) Over 
 (Partition by ha.userid, ha.h5pactivityid order by ha.attempt) AS perc_score_first_attempt,
 DATE_FORMAT(FROM_UNIXTIME(ha2.timemodified + 28800), '%Y-%m-%d %H:%i:%s') AS date_highest_score_attempt,
 SEC_TO_TIME(ha2.duration) AS duration_highest_attempt,
 ha2.rawscore AS score_highest_attempt,
 concat(round(( ha2.rawscore/ha2.maxscore * 100 ),2),'%') AS perc_score_highest_attempt,
 COUNT(ha.id) AS total_attempts
FROM
 prefix_course AS c
JOIN prefix_h5pactivity AS h ON c.id = h.course
JOIN prefix_enrol AS e ON e.courseid = c.id
JOIN prefix_user_enrolments AS ue ON ue.enrolid = e.id
JOIN prefix_user AS u ON u.id = ue.userid 
LEFT JOIN prefix_h5pactivity_attempts AS ha ON ha.h5pactivityid = h.id AND ha.userid = u.id
LEFT JOIN (
 SELECT * from(
 SELECT ha2.*,
 ROW_NUMBER() OVER(PARTITION BY ha2.h5pactivityid, ha2.userid ORDER BY ha2.rawscore desc) AS RN
 FROM prefix_h5pactivity_attempts ha2
 ) ha2 WHERE ha2.RN = 1
) ha2 on ha2.h5pactivityid=ha.h5pactivityid AND ha2.userid=ha.userid
WHERE
 u.deleted = 0 
 %%FILTER_COURSES:c.id%%
 %%FILTER_USERS:u.username%%
 %%FILTER_SEARCHTEXT_assignment:h.name:~%%
 %%FILTER_SEARCHTEXT_student:u.firstname:~%%
GROUP BY
 c.id,
 h.id,
 u.id
