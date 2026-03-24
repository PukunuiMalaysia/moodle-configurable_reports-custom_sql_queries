-- Purpose: Estimate course storage size with placeholder PDF-exclusion condition note.
SELECT
 c.fullname AS Course_Name,
 c.shortname AS Short_Name,
 c.id AS Course_ID,
 COUNT(f.id) AS File_Count,
 ROUND(SUM(f.filesize) / 1073741824, 2) AS Size_GB
FROM
 prefix_files f
 JOIN prefix_context ctx ON f.contextid = ctx.id
 -- Link context to course, handling both Course Level (50) and Module Level (70)
 LEFT JOIN prefix_course_modules cm ON ctx.instanceid = cm.id AND ctx.contextlevel = 70
 JOIN prefix_course c ON (
 (ctx.contextlevel = 50 AND ctx.instanceid = c.id) OR
 (ctx.contextlevel = 70 AND cm.course = c.id)
 )
WHERE
 -- NOTE: This likely acted as a placeholder during query iteration to keep a WHERE clause present.
 -- It only excludes files literally named '.pdf' (rare), not normal '*.pdf' files.
 -- If the real intent is to exclude PDFs, use: AND LOWER(f.filename) NOT LIKE '%.pdf'
 f.filename != '.pdf'
GROUP BY
 c.id, c.fullname, c.shortname
ORDER BY
 Size_GB DESC
