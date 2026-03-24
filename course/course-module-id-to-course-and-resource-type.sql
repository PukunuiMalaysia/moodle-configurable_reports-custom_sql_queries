-- Purpose: Resolve a course module ID to its course and module/resource type.
/*
 Purpose:
   Lookup a specific course module ID and return its course + module/resource type.

 How to use:
   - Replace the hardcoded module id in WHERE cm.id = 53816
     with the module id you want to inspect.

 Optional (Configurable Reports parameterized filter):
   - Instead of hardcoding, you can use:
     %%FILTER_INT_moduleid:cm.id:=%
*/
SELECT c.id AS course_id, c.fullname AS course_name, m.name AS resource_type
FROM prefix_course_modules cm
JOIN prefix_course c ON cm.course = c.id
JOIN prefix_modules m ON cm.module = m.id
WHERE cm.id = 53816
