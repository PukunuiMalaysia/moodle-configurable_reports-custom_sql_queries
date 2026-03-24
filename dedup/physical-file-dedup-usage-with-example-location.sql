-- Purpose: Identify large physical files by contenthash and show representative usage/location.
/*
 Purpose:
   Detect large physical files (grouped by contenthash) and show how widely each file is reused.

 Why Example_* columns exist:
   A single physical file (same contenthash) can be referenced from multiple Moodle contexts
   (different courses/modules/users). To keep output compact and fast, this report shows ONE
   representative value using MIN(...), not a full list of all locations/usages.

 Important:
   Example_Component / Example_Course_Location / Example_User_Or_Owner are representative hints
   only. They are NOT exhaustive or canonical for all usages of the file.
*/
SELECT
 -- 1) Physical file details (grouped by contenthash, i.e., one underlying stored file)
 MIN(f.filename) AS Example_Filename,
 ROUND(MAX(f.filesize) / 1048576, 2) AS Physical_Size_MB,
 COUNT(f.id) AS Usage_Count,
 MAX(f.mimetype) AS Type,
 
 -- 2) Representative component only (compact output; not exhaustive)
 MIN(f.component) AS Example_Component,

 -- 3) Representative course location only (may exist in many locations)
 MIN(CASE
 WHEN ctx.contextlevel = 50 THEN c.fullname
 WHEN ctx.contextlevel = 70 THEN c_mod.fullname
 ELSE NULL
 END) AS Example_Course_Location,

 -- 4) Representative owner/user only
 MIN(CASE
 WHEN ctx.contextlevel = 30 THEN CONCAT('Private: ', u.firstname, ' ', u.lastname)
 ELSE CONCAT(u_real.firstname, ' ', u_real.lastname)
 END) AS Example_User_Or_Owner,

 FROM_UNIXTIME(MIN(f.timecreated)) AS First_Uploaded_At

FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 LEFT JOIN prefix_course c ON (ctx.contextlevel = 50 AND ctx.instanceid = c.id)
 LEFT JOIN prefix_course_modules cm ON (ctx.contextlevel = 70 AND ctx.instanceid = cm.id)
 LEFT JOIN prefix_course c_mod ON cm.course = c_mod.id
 LEFT JOIN prefix_user u ON (ctx.contextlevel = 30 AND ctx.instanceid = u.id)
 LEFT JOIN prefix_user u_real ON f.userid = u_real.id

WHERE
 f.filename != '.'
 AND f.filesize > 1048576 -- show files larger than 1 MB
GROUP BY
 f.contenthash
ORDER BY
 Physical_Size_MB DESC
