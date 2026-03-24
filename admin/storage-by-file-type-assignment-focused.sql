-- Purpose: Summarize storage by assignment-related file types and fallback component:filearea.
SELECT
 CASE
 WHEN f.component = 'assignsubmission_file' AND f.filearea = 'submission_files' THEN 'Assignment Submissions'
 WHEN f.component = 'assignfeedback_file' AND f.filearea = 'feedback_files' THEN 'Assignment Feedback Files'
 WHEN f.component = 'assignfeedback_editpdf' THEN 'Assignment PDF Conversions'
 ELSE CONCAT(f.component, ':', f.filearea)
 END AS File_Type,
 COUNT(*) AS File_Count,
 ROUND(SUM(f.filesize) / (1024 * 1024 * 1024), 2) AS Total_Storage_GB
FROM
 prefix_files f
WHERE
 f.filesize > 0
GROUP BY
 File_Type
ORDER BY
 Total_Storage_GB DESC
