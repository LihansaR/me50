select distinct(people.name) from stars
join people on stars.person_id = people.id
join movies on strs.movie_id = movies.id
where movies.year = 2004
order by birth;