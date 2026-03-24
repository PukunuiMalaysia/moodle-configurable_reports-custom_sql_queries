-- Purpose: Dynamic course-page summary of student book views, quiz attempts, and feedback responses.
/*
 Dynamic report note:
 - This SQL is dynamic and intended to run ONLY on course pages.
 - It depends on the placeholder %%COURSEID%% being resolved by Configurable Reports.
 - If run outside a course-page context (or where %%COURSEID%% is not injected),
   the query will fail or return incorrect results.
*/

/* One row per student: books, quizzes, feedback in separate columns */
SELECT
 u.userid,
 u.student,
 u.email,
 b.books AS book_views_by_activity,
 q.quizzes AS quiz_attempts,
 f.feedback AS feedback_responses
FROM (
 /* distinct enrolled, active users in this course */
 SELECT DISTINCT
 uu.id AS userid,
 CONCAT(uu.firstname, ' ', uu.lastname) AS student,
 uu.email
 FROM prefix_enrol e
 JOIN prefix_user_enrolments ue ON ue.enrolid = e.id AND ue.status = 0
 JOIN prefix_user uu ON uu.id = ue.userid AND uu.deleted = 0 AND uu.suspended = 0
 WHERE e.courseid = %%COURSEID%%
) u

/* Books: per user, list each book with views (0 if never viewed) */
LEFT JOIN (
 SELECT
 ub.userid,
 GROUP_CONCAT(CONCAT(bi.name, ': ', IFNULL(v.views, 0))
 ORDER BY bi.name SEPARATOR '<br>') AS books
 FROM (
 SELECT DISTINCT ue.userid
 FROM prefix_enrol e
 JOIN prefix_user_enrolments ue ON ue.enrolid = e.id AND ue.status = 0
 WHERE e.courseid = %%COURSEID%%
 ) ub
 JOIN (
 SELECT cm.id AS cmid, b.name
 FROM prefix_course_modules cm
 JOIN prefix_modules m ON m.id = cm.module AND m.name = 'book'
 JOIN prefix_book b ON b.id = cm.instance
 WHERE cm.course = %%COURSEID%%
 ) bi
 /* views aggregated per user x book cmid */
 LEFT JOIN (
 SELECT userid, contextinstanceid AS cmid, COUNT(*) AS views
 FROM prefix_logstore_standard_log
 WHERE courseid = %%COURSEID%%
 AND component = 'mod_book'
 AND target = 'course_module'
 AND action = 'viewed'
 GROUP BY userid, contextinstanceid
 ) v ON v.userid = ub.userid AND v.cmid = bi.cmid
 GROUP BY ub.userid
) b ON b.userid = u.userid

/* Quizzes: per user, each attempt with score% and duration */
LEFT JOIN (
 SELECT
 qa.userid,
 GROUP_CONCAT(
 CONCAT(
 q.name, ' #', qa.attempt, ': ',
 IF(q.sumgrades > 0 AND qa.sumgrades IS NOT NULL,
 CONCAT(ROUND(100 * qa.sumgrades / NULLIF(q.sumgrades,0), 2), '%'),
 '—'
 ),
 ' ',
 IF(qa.timefinish > 0,
 CONCAT('(', SEC_TO_TIME(qa.timefinish - qa.timestart), ')'),
 ''
 )
 )
 ORDER BY q.name, qa.attempt SEPARATOR '<br>'
 ) AS quizzes
 FROM prefix_quiz_attempts qa
 JOIN prefix_quiz q ON q.id = qa.quiz
 WHERE q.course = %%COURSEID%%
 GROUP BY qa.userid
) q ON q.userid = u.userid

/* Feedback: per user, each response as "Feedback — Question: Answer" */
LEFT JOIN (
 SELECT
 fc.userid,
 GROUP_CONCAT(
 CONCAT(f.name, ' — ', fi.name, ': ', fv.value)
 ORDER BY f.name, fi.position SEPARATOR '<br>'
 ) AS feedback
 FROM prefix_feedback f
 JOIN prefix_feedback_item fi ON fi.feedback = f.id
 JOIN prefix_feedback_completed fc ON fc.feedback = f.id
 JOIN prefix_feedback_value fv ON fv.completed = fc.id AND fv.item = fi.id
 WHERE f.course = %%COURSEID%%
 GROUP BY fc.userid
) f ON f.userid = u.userid

ORDER BY u.student
