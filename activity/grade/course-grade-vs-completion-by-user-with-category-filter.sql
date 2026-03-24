-- Purpose: Compare per-user course grade percentage vs completion percentage by category.
/*
 Purpose:
   Compare per-user course grade (%) vs activity completion (%) by course/category.

 Configurable Reports plugin filter required:
   %%FILTER_CATEGORIES:cc.id%%
   - Restricts report by selected course category.

 Important notes:
 - This query joins role assignments at course context level. If your site has multiple roles
   assigned in course context, results may include users beyond learners unless further filtered.
 - Percentage uses (gg.finalgrade / gg.rawgrademax). If rawgrademax can be 0, add NULLIF guard.
 - Completion percentage uses TotalActivities from completion-enabled modules only.
*/
SELECT
 u.firstname AS firstname,
 u.lastname AS lastname,
 c.fullname AS Module,
 cc.name AS Course,
 ROUND(gg.finalgrade,2) AS Grade,
 ROUND(gg.rawgrademax,2) AS Max,
 ROUND((gg.finalgrade / gg.rawgrademax * 100), 2) AS Percentage,
 SUM(p.completionstate) AS Completions,
 x.TotalActivities AS MaxC,
 ROUND((SUM(p.completionstate) / x.TotalActivities * 100),2) AS PercentageC

FROM prefix_course AS c
JOIN prefix_context AS ctx ON c.id = ctx.instanceid
JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
JOIN prefix_user AS u ON u.id = ra.userid
JOIN prefix_grade_grades AS gg ON gg.userid = u.id
JOIN prefix_grade_items AS gi ON gi.id = gg.itemid
JOIN prefix_course_categories AS cc ON cc.id = c.category
JOIN prefix_course_modules AS cm ON cm.course = c.id
JOIN prefix_course_modules_completion AS p ON p.coursemoduleid=cm.id AND p.userid = u.id
JOIN (
 SELECT c2.id, COUNT(cm2.completion) AS TotalActivities
 FROM prefix_course c2
 JOIN prefix_course_modules cm2 ON cm2.course = c2.id
 WHERE cm2.completion > 0
 GROUP BY c2.id
 ) AS x ON x.id = c.id

%%FILTER_CATEGORIES:cc.id%%
WHERE
 gi.courseid = c.id
 AND gi.itemtype = 'course'

GROUP BY u.firstname, u.lastname, cc.name, Grade, Max, Percentage, x.TotalActivities

ORDER BY cc.id, c.fullname, u.lastname
