/*
 Purpose:
   Compare quiz submissions vs enrolled participants for quizzes opened in a selected date window.

 Annotation notes:
 1) Date window filter (q.timeopen)
    - Update these two values to change the reporting window:
      UNIX_TIMESTAMP('2023-12-01 00:00:00')  -- window start (inclusive)
      UNIX_TIMESTAMP('2024-05-01 00:00:00')  -- window end (exclusive)

 2) Timezone display adjustment (+8 hours)
    - open_time_adjusted uses DATE_ADD(..., INTERVAL 8 HOUR) to display UTC+8 style time.
    - If your report timezone differs, update/remove the +8 adjustment.

 3) participant_count meaning
    - participant_count is based on enrolled users in the course (user_enrolments + enrol),
      not only users who attempted this quiz.
*/
SELECT q.name AS quiz_name,
 DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(q.timeopen), INTERVAL 8 HOUR), '%W, %d %M %Y, %h:%i %p') AS open_time_adjusted,
 CONCAT('<a target="_new" href="%%WWWROOT%%/mod/quiz/view.php?id=', cm.id, '">',q.name,'</a>') AS quiz_url,
 COUNT(DISTINCT qa.id) AS submission_count,
 (SELECT COUNT(DISTINCT ue.userid)
 FROM prefix_user_enrolments ue
 JOIN prefix_enrol e ON e.id = ue.enrolid
 WHERE e.courseid = cm.course) AS participant_count
FROM prefix_quiz q
JOIN prefix_course_modules cm ON cm.instance = q.id
JOIN prefix_modules m ON m.id = cm.module AND m.name = 'quiz'
LEFT JOIN prefix_quiz_attempts qa ON qa.quiz = q.id
WHERE cm.deletioninprogress = 0
AND (q.timeopen >= UNIX_TIMESTAMP('2023-12-01 00:00:00') AND q.timeopen < UNIX_TIMESTAMP('2024-05-01 00:00:00'))
GROUP BY q.id
ORDER BY q.timeopen
