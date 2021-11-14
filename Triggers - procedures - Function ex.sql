create database Triggers;

use Triggers;

create table chec (
name varchar(25),
age int,
address varchar(255));

# create trigger for be sure before inserting in table from age not below 0

drop trigger age_check;

delimiter //
create trigger age_check
before insert on chec
for each row
begin
if new.age < 0 then set new.age = 0;
end if; 
end //
delimiter ;

insert into chec values 
("saher", 30, "minia"),
("amged", 20, "minia"),
("ali", -30, "minia");               # triger will convert -30 to 0


select * from chec;


#########################################################################
# Trigger before delete

create table source_TB (
id int primary key,
name varchar(25),
age int);

insert into source_TB values (1, "saher", 20),
(2, "emad", 30),
(3, "mohsen", 23),
(4, "ali", 50),
(5, "Mohamed", 43),
(6, "ahmed", 53),
(7, "john", 39),
(8, "omar", 45);


select * from source_TB;

create table deleted_TB (
id int primary key,
name varchar(25),
age int);

delimiter $$
create trigger names_deleted
before delete on source_TB
FOR each row
begin
insert into deleted_TB 
values (old.id, old.name, old.age);
end; $$
delimiter ;

delete from source_TB
where id = 4;

select * from deleted_TB;


#####################################################################################################
# stored procedure 

delimiter $$
create procedure above_20()
begin
select * from chec 
where age >20;
end $$
delimiter ;

select * from chec ;

call above_20() ;

################################################################################################
# SP With IN

delimiter $$
create procedure sorted_with_limit(in var int)
begin
select * from source_tb 
order by age desc
limit var;
end $$
delimiter ;

call sorted_with_limit(5);

delimiter $$
create procedure inserting_source(in id int, in name varchar(25), in age int)
begin
insert into source_tb 
values (id, name, age);
end $$
delimiter ;

call inserting_source (20,"saaaaher",31);

select * from source_tb; 


#########################################################################################
# sp with out


delimiter $$
create procedure oldest_one(out oldest varchar(25))
begin
select name into oldest from source_tb
where age = (select max(age) from source_tb);
end $$
delimiter ;

call oldest_one(@F_oldest);

select @F_oldest as oldest_one;

#####################################################################################
show full tables;
describe agents;

##################################################################################
# window function

select * from data;

select name, age, address, 
max(age) over (partition by address) as oldest 
from data ;

select name, age, address, 
row_number() over (partition by address order by age desc) as ranke 
from data ;

select name, age, address from 
(select name, age, address, 
row_number() over (partition by address order by age desc) as ranke 
from data ) as x
where x.ranke > 1;


select name, age, address, 
first_value(name) over (partition by address order by age desc) as oldest_name 
from data ;


#######################################################################
# function 

DELIMITER $$
CREATE FUNCTION double_ (starting_value INT )
RETURNS INT
DETERMINISTIC
BEGIN
   DECLARE num INT;
   set num = starting_value * 2 ;
   RETURN num;
END  $$
DELIMITER ;

select double_(3);