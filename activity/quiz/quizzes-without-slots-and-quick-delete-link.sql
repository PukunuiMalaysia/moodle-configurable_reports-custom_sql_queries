SELECT
 CONCAT('<a target="_new" href="%%WWWROOT%%/mod/quiz/view.php?id=', cm.id, '">', q.name, '</a>') AS Quiz,
 CONCAT('<a target="_new" href="%%WWWROOT%%/course/view.php?id=', c.id, '">', c.fullname, '</a>') AS Course,
 CONCAT('<a target="_new" href="%%WWWROOT%%/course/mod.php?&#100elete=', cm.id, '">X</a>') AS X_Link
FROM
 prefix_quiz q
LEFT JOIN
 prefix_quiz_slots qs ON q.id = qs.quizid
JOIN
 prefix_course c ON q.course = c.id
JOIN
 prefix_course_modules cm ON cm.instance = q.id AND cm.module = (SELECT id FROM prefix_modules WHERE name = 'quiz')
WHERE
 qs.id IS NULL
