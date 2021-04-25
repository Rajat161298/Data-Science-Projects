show tables;
/*converting string to date format*/
update `bajaj auto`
set `Date`  = str_to_date(`bajaj auto`.Date ,'%d-%M-%Y');
update `eicher motors`
set `Date` = str_to_date(`eicher motors`.Date ,'%d-%M-%Y');
update `hero motocorp`
set `Date` = str_to_date(`hero motocorp`.Date ,'%d-%M-%Y');
update infosys
set `Date` = str_to_date(infosys.Date ,'%d-%M-%Y');
update tcs
set `Date` = str_to_date(tcs.Date ,'%d-%M-%Y');
update `tvs motors`
set `Date` = str_to_date(`tvs motors`.Date ,'%d-%M-%Y');
/*creating new table with moving average*/
create table bajaj1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `bajaj auto`;
create table eicher1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `eicher motors`;
create table hero1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `hero motocorp`;
create table infosys1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `infosys`;
create table tcs1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `tcs`;
create table tvs1 as
select `Date` , `close price`,
round(avg(`close price`) over(order by `Date` rows between 19 preceding and current row),2) as 20_day_mov_avg ,
round(avg(`close price`) over(order by `Date` rows between 49 preceding and current row),2) as 50_day_mov_avg
from `tvs motors`;
/*creating master table with close price of scrips*/
create table master_table as
select b.`Date` , b.`close price` as Bajaj , t.`close price` as Tcs,  tv.`close price` as Tvs,
i.`close price` as Infosys , e.`close price` as Eicher , h.`close price` as Hero from bajaj1 b
inner join eicher1 e on b.`Date` = e.`Date` inner join hero1 h on b.`Date` = h.`Date`
inner join infosys1 i on b.`Date` = i.`Date` inner join tcs1 t on b.`Date` = t.`Date`
inner join tvs1 tv on b.`Date` = tv.`Date`;
/*creating new table with signal*/
create table bajaj_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from bajaj1 order by `Date`;
create table eicher_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from eicher1 order by `Date`;
create table hero_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from hero1 order by `Date`;     
create table infosys_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from infosys1 order by `Date`;
create table tcs_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from tcs1 order by `Date`;
create table tvs_signal as
select `Date` , `close price` ,
case when 20_day_mov_avg > 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) < lag(50_day_mov_avg,1) over(order by `Date`) then 'Buy'
when 20_day_mov_avg < 50_day_mov_avg and lag(20_day_mov_avg,1) over(order by `Date`) > lag(50_day_mov_avg,1) over(order by `Date`) then 'Sell'
else "Hold" end as "Signal" from tvs1 order by `Date`;
/*creating user defined function to generate signal  given a date for bajaj motors*/
CREATE FUNCTION sig (dt date)
RETURNS float8 deterministic
RETURN (SELECT `Signal` from bajaj_signal where `Date` = dt);
