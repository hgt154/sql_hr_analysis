# Data Analysis #

# Questions
-- 1. What is the gender breakdown of employees in the company
select gender, count(*) as gender_count
from hr
where age >= 18 and termdate = 0000-00-00
group by gender;

-- 2. What is the race/ethinicity breakdown of employees in the company
select race, count(*) as race_count
from hr
where age >= 18 and termdate = 0000-00-00
group by race
order by count(*) desc;

-- 3. What is the age distribution of employees in the company
select 
	min(age) as youngest,
    max(age) as oldest
from hr 
where age >= 18 and termdate = 0000-00-00;

select 
	case
		when age >= 18 and age <= 24 then '18-24'
		when age >= 25 and age <= 34 then '25-34'
        when age >= 35 and age <= 44 then '35-44'
        when age >= 45 and age <= 54 then '45-54'
        when age >= 55 and age <= 64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as age_group_count
from hr 
where age >= 18 and termdate = 0000-00-00
group by age_group
order by age_group;

-- 4. What is the age distribution of employees by gender in the company
select 
	case
		when age >= 18 and age <= 24 then '18-24'
		when age >= 25 and age <= 34 then '25-34'
        when age >= 35 and age <= 44 then '35-44'
        when age >= 45 and age <= 54 then '45-54'
        when age >= 55 and age <= 64 then '55-64'
        else '65+'
	end as age_group, gender,
    count(*) as age_group_count
from hr 
where age >= 18 and termdate = 0000-00-00
group by age_group, gender
order by age_group, gender;

-- 5. How many employees work at headquarters vs remote locations?
select location, count(*) as loc_count
from hr
where age >= 18 and termdate = 0000-00-00
group by location;

-- 6. What is the average time of employment for those who had their contract terminated?
select 
	round(avg(datediff(termdate, hire_date))/365, 2) as avg_time_employment
from hr 
where termdate <= curdate() and termdate <> 0000-00-00 and age >= 18;

-- 7. How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count
from hr
where age >= 18 and termdate = 0000-00-00
group by department, gender
order by department;

-- 8. What is the distribution of job titles across the company?
select jobtitle, count(*) as count
from hr 
where age >= 18 and termdate = 0000-00-00
group by jobtitle
order by jobtitle desc;

-- 9. Which department has the highest turnover rate?
select department,
	total_count,
    terminated_count, 
    terminated_count/total_count as termination_rate
from (
	select department,
    count(*) as total_count,
    sum(case when termdate <> 0000-00-00 and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr
    where age >= 18
    group by department
    ) as subquery
order by termination_rate desc;

-- 10. What is the distribution of employees across locations by city and state?
select location_state, count(*) as location_count
from hr
where age >= 18 and termdate = 0000-00-00
group by location_state 
order by location_count desc;

-- 11. How has the company's employees count changed over time based on hire and term dates?
select 
	year,
    hires,
    terminations,
    hires - terminations as net_change,
    round((hires - terminations)/hires * 100, 2) as net_change_percent 
from (
	select 
		year(hire_date) as year,
        count(*) as hires, 
        sum(case when termdate <> 0000-00-00 and termdate <= curdate() then 1 else 0 end) as terminations
        from hr
        where age >= 18
        group by year(hire_date)
        ) as subquery
order by year asc;

-- 12. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate, hire_date)/365), 2) as avg_tenure
from hr
where termdate <= curdate() and termdate <> 0000-00-00 and age >= 18
group by department;

