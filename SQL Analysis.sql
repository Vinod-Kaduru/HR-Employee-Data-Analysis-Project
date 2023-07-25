create database project;

use project;

select*from hr;

alter table hr
change column ï»¿id emp_id varchar(20);

DESCRIBE hr;

select birthdate from hr;

set sql_safe_updates = 0;

update hr
set birthdate = case
	when birthdate like'%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like'%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end;

alter table hr
modify column birthdate date;

update hr
set hire_date = case
	when hire_date like'%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    when hire_date like'%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    else null
end;

alter table hr
modify column hire_date date;

update hr
set termdate = if(termdate is not null and termdate !='',date(str_to_date(termdate,'%Y-%m-%d %H:%i%s UTC')),'0000-00-00')
where true;

set sql_mode = 'allow_invalid_dates';
ALTER table hr
modify column termdate date;


alter table hr add column age int;

update hr
set age = timestampdiff(Year,birthdate,curdate());

select
	min(age) as youngest,
    max(age) as oldest
from hr;

select count(*) from hr where age < 18;


select gender,count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by gender;

select race, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by race
order by count(*) desc;

select
	min(age) as youngest,
    max(age) as oldest
from hr
where age >= 18 and termdate = '0000-00-00';

select
	case
		when age >=18 and age <= 24 then '18-24'
        when age >=25 and age <= 34 then '25-34'
        when age >=35 and age <= 44 then '35-44'
        when age >=45 and age <= 54 then '45-54'
        when age >=55 and age <= 64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
from hr
where age  >= 18 and termdate = '0000-00-00'
group by age_group
order by age_group;


select
	case
		when age >=18 and age <= 24 then '18-24'
        when age >=25 and age <= 34 then '25-34'
        when age >=35 and age <= 44 then '35-44'
        when age >=45 and age <= 54 then '45-54'
        when age >=55 and age <= 64 then '55-64'
        else '65+'
	end as age_group, gender,
    count(*) as count
from hr
where age  >= 18 and termdate = '0000-00-00'
group by age_group, gender
order by age_group, gender;

select location, count(*) as count,emp_id, count(*) as count1
from hr
where age  >= 18 and termdate = '0000-00-00'
group by location;

select
	round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employment
from hr
where termdate <= curdate() and termdate <>'0000-00-00' and age >= 18;

select department,gender, count(*) as count
from hr
where age  >= 18 and termdate = '0000-00-00'
group by department, gender
order by department;

select jobtitle, count(*) as count
from hr
where age  >= 18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

select department,
	total_count,
    terminated_count,
    terminated_count / total_count as termination_rate
from(
	select department,
    count(*) as total_count,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr
	where age  >= 18
    group by department
    ) as subquery
order by termination_rate desc;

select location_state, count(*) as count
from hr
where age  >= 18 and termdate = '0000-00-00'
group by location_state
order by count desc;

select
	year,
    hires,
    terminations,
    hires-terminations as net_change,
    round((hires-terminations)/hires*100,2) as net_change_percent
from(
	select
		year(hire_date) as year,
		count(*) as hires,
		sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
		from hr
		where age  >= 18
		group by year(hire_date)
		) as subquery
order by year asc;

select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate<> '0000-00-00' and age >= 18
group by department;

select
	year,
    hires,
    terminations,
    department,
    jobtitle,
    location_state,
    employee_count,
    location
from(
	select
		year(hire_date) as year,
		count(*) as hires,
		sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations,
		department,
        jobtitle,
        location_state,
        count(emp_id) as employee_count,
        location
        from hr
		where age  >= 18
		group by jobtitle
		) as subquery
order by year asc;

select departmeent


select jobtitle from hr;