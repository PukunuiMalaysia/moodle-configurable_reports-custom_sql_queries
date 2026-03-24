-- This query retrieves user information along with related cohort information from a database
SELECT 
 u.firstname, -- user's first name
 u.lastname, -- user's last name
 u.username, -- user's username
 -- creates a clickable link to the user's profile page
 CONCAT('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=', u.id, '">Profile Link</a>') AS userprofile_link,
 u.email, -- user's email
 u.city, -- user's city
 u.country, -- user's country
 FROM_UNIXTIME(u.lastaccess) AS lastaccess_parsed, -- user's last access time in human-readable format
 u.suspended, -- user's suspended status (0 or 1)
 -- If the user is suspended, display 'Suspended', otherwise 'Not Suspended'
 IF(u.suspended = 1, 'Suspended', 'Not Suspended') AS suspended_status,
 (
 -- Get the names of all cohorts that the user is a member of
 SELECT GROUP_CONCAT(c.name SEPARATOR ', ') 
 FROM prefix_cohort_members AS cm 
 JOIN prefix_cohort AS c ON cm.cohortid = c.id
 WHERE cm.userid = u.id
 ) AS cohorts
FROM 
 prefix_user AS u -- main table to select user data from
WHERE 
 u.deleted = 0 -- only include users that are not deleted
