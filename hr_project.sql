CREATE DATABASE projects;
USE projects;

select * from hr;

## Data Cleaning ##

alter table hr
change column ï»¿id emp_id varchar(20) null;

select birthdate from hr;

set sql_safe_updates = 0; #turning of security feature to allow to update the data anytime 

update hr
set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

alter table hr
modify column birthdate date; #before I just formatted the data in the column, but now I'm modify the datatype of the column 

select birthdate from hr;

update hr
set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
	when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

alter table hr
modify column hire_date date;

update hr
set termdate = if(termdate is not null and termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
where true;

set sql_mode = 'ALLOW_INVALID_DATES';

alter table hr
modify column termdate date;

alter table hr add column age int;

update hr
set age = timestampdiff(YEAR, birthdate, curdate());

UPDATE hr #there were more than 900 negative values in age column, so the following lines will fix this (The reason age was showing negative is instead of 1960 it was mentioned as 2060)
SET birthdate = DATE_SUB(birthdate, INTERVAL 100 YEAR)
WHERE birthdate >= '2060-01-01' AND birthdate < '2070-01-01';

select birthdate, age from hr;



    