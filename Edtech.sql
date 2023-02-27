/***********************************************SQL Project Edtech EDA*****************************************************************************************/
/*********************************************by Shreetama Dasgupta*******************************************************************************************/
create database Edutech_DataAnalysis;

use Edutech_DataAnalysis;

--------------------------------------------------------------------------------------------------------------------------------------------------------------

# DATA CLEANING

/*Getting the records of the table leads_basic_details */
select * from leads_basic_details;

/* Searching for the outliers in the data */
select max(age) from leads_basic_details;

select min(age) from leads_basic_details;

/*Since age above 100 seem irrelevant. 
Thus deleting the records where age is greater than 100 from the leads_basic_details*/

set sql_safe_updates=0;

delete from leads_basic_details where age>100;



/* Getting the records from the table leads_demo_watched_details */

select * from leads_demo_watched_details;

/* Searching for the outliers in the data */
select max( watched_percentage) from leads_demo_watched_details;

/* Since percentage cannot be greater than 100 
Thus deleteting rows where percentage is greater than 100 */

delete from leads_demo_watched_details where  watched_percentage>100;

/*Handling the blank values in the table leads_reasons_for_no_interest */
/*replaced the blanks with "NA" in each column of leads_reasons_for_no_interest in MS-Excel
Now replacing the NA with null */

update leads_reasons_for_no_interest
set reasons_for_not_interested_in_demo = Null where reasons_for_not_interested_in_demo="NA";

update leads_reasons_for_no_interest
set reasons_for_not_interested_to_consider = Null where reasons_for_not_interested_to_consider="NA";

update leads_reasons_for_no_interest
set reasons_for_not_interested_to_convert = Null where reasons_for_not_interested_to_convert="NA";

select * from leads_reasons_for_no_interest;




-------------------------------------------------------------------------------------------------------

/*Ranking of the cities with respect to the number of leads */

select current_city as city, count(*) as No_of_leads,
rank() over (order by count(*) desc) as `Rank`
from leads_basic_details 
group by current_city;

/* Observation
Visakhapatnam and Hyderabad have the maximum number of leads


Mumbai and Chennai have comparatively lesser number of candidates
New strategies should be developed to attract more leads in these cities*/
-------------------------------------------------------------------------------------------------

/*Major sources of generation of leads*/

select count(*) into @Total_count from leads_basic_details;

select lead_gen_source, round((count(*)/@Total_count)*100,0) as Percentage
from leads_basic_details
group by lead_gen_source
order by 2 desc;

/*Some of the major sources for generating leads can be Social Media, SEO and Email Marketing.
About 24% of the leads came to know about the company through social media.
The next important sources were SEO and email_marketing each contributing 21% and 20 % respectively. */
--------------------------------------------------------------------------------------------------------------

/* Educational backgrounds of the leads */

select current_education as Educational_Background, count(*) as No_of_leads
from leads_basic_details
group by Educational_Background
order by 2 desc;

/* Maximum number of leads have B.Tech educational background or are looking for jobs*/
--------------------------------------------------------------------------------------------------------

/* Most preferred language for demo */

select Language, count(*) as No_of_leads
from leads_demo_watched_details
group by language
order by 2 desc;

select language, current_city, count(*) as No_of_leads_watched_demo
from leads_basic_details inner join leads_demo_watched_details
using (lead_id)
group by language, current_city
order by language, 2 desc;

/*English is the most preferred language followed by Telugu which is mostly spoken in Hyderabad 
and Vishakapatnam. */
---------------------------------------------------------------------------------------------------------------------------------------

/*Percentage of the demo video watched by people */
 
select count(*) into @Demo_watched_people from leads_demo_watched_details;

select concat(round(count(*)/@Demo_watched_people*100,0),"%") as `%Watched_less_than_60%` 
from leads_demo_watched_details
where watched_percentage<=60;

/*More than 50% of the leads are watching less than 60% of the video
The watched_percentage can be increased if the demo is brief and concise as well as 
of shorter duration.*/

------------------------------------------------------------------------------------------------------------------
/*Percentage of successful calls*/

 select count(*) into @Total_Calls from leads_interaction_details;
 
select call_status,round((count(*)/@Total_Calls)*100,0) as Percentage
from leads_interaction_details
group by call_status;

select current_education, count(distinct lead_id) as No_of_leads
from leads_basic_details inner join leads_interaction_details
using(lead_id)
where call_status="Successful"
group by current_education
order by 2 desc;

/* Most of the leads with successful call_status are having B.Tech educational background
or are on the verge of job hunting */

--------------------------------------------------------------------------------------------------------------------
/* Reasons leads are not interested in demo */
select reasons_for_not_interested_in_demo, count(*)as No_of_leads
from leads_reasons_for_no_interest
where reasons_for_not_interested_in_demo is not Null
group by reasons_for_not_interested_in_demo
order by 2 desc;

/*Reasons leads are not interested to consider */
select reasons_for_not_interested_to_consider, count(*) as No_of_leads
from leads_reasons_for_no_interest
where reasons_for_not_interested_to_consider is not Null
group by reasons_for_not_interested_to_consider
order by 2 desc;

/* Reasons leads are not interested to convert */
select reasons_for_not_interested_to_convert, count(*) as No_of_leads
from leads_reasons_for_no_interest
where reasons_for_not_interested_to_convert is not Null
group by reasons_for_not_interested_to_convert
order by 2 desc;

/*Most of the leads are dropping at different stages due to affordability.
Since most of the leads are students or are in the job hunting stage, higher price
of the course can be an issue.*/

-------------------------------------------------------------------------------------------------------------------------------------------------







