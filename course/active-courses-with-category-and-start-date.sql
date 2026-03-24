-- Purpose: List visible courses with category and formatted start date.
SELECT 
 c.id AS 'Course ID',
 c.fullname AS 'Course Name',
 c.shortname AS 'Course Short Name',
 cc.name AS 'Category',
 FROM_UNIXTIME(c.startdate, '%Y-%m-%d') AS 'Start Date'
FROM 
 prefix_course c
JOIN 
 prefix_course_categories cc ON c.category = cc.id
WHERE 
 c.visible = 1
ORDER BY 
 c.fullname ASC
