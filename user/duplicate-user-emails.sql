select id, auth, username, email
from prefix_user where email in (
select email
from prefix_user
where email like '%@%'
group by email
having count(email) >1)
order by email, id
