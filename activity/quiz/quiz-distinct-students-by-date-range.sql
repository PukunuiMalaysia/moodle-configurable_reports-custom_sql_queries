-- Purpose: Count distinct students attempting quizzes within a date range.
/*
 Purpose:
   Count distinct students who took a quiz attempt within a chosen date/time window.

 How to update the time range:
   1) Replace START datetime in UNIX_TIMESTAMP('YYYY-MM-DD HH:MM:SS')
   2) Replace END datetime in UNIX_TIMESTAMP('YYYY-MM-DD HH:MM:SS')

 Current example window:
   START = '2025-04-01 00:00:00'
   END   = '2025-06-30 23:59:59'

 Example (change to July 2025):
   qa.timemodified BETWEEN UNIX_TIMESTAMP('2025-07-01 00:00:00')
                      AND UNIX_TIMESTAMP('2025-07-31 23:59:59')

 Timezone note:
   UNIX_TIMESTAMP() uses the database/session timezone context.
   Ensure your intended reporting timezone matches DB timezone settings.
*/
SELECT COUNT(DISTINCT qa.userid) AS num_students_taking_exam
FROM prefix_quiz_attempts qa
JOIN prefix_user u ON qa.userid = u.id
WHERE qa.timemodified BETWEEN UNIX_TIMESTAMP('2025-04-01 00:00:00') AND UNIX_TIMESTAMP('2025-06-30 23:59:59')
