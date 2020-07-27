create database dbRadar
use dbRadar

create table locationDescription(
locationDescription_id int primary key,
description varchar(100),
domestic bit
)
insert into locationDescription(locationDescription_id,description,domestic)
select ID,Location_Description,Domestic from chicago_crime_data

--Was the insertion successful? compare that all record where moved
select * from locationDescription 
select top 100 * from chicago_crime_data


create table location(
location_id int primary key,
block varchar(50),
locationDescription_id int foreign key(locationDescription_id) references locationDescription(locationDescription_id)
)
insert into location(location_id,block,locationDescription_id)
select ID,block,locationDescription_id from chicago_crime_data,locationDescription
where chicago_crime_data.ID = locationDescription.locationDescription_id
--Was the insertion successful?
select * from location order by location_id desc 


create table crimeDescription(
crimeDescription_id int primary key,
description varchar(100),
arrest bit
)
insert into crimeDescription(crimeDescription_id,description,arrest)
select ID,Description,Arrest from chicago_crime_data
--Was the insertion successful?
select * from crimeDescription order by crimeDescription_id desc 


create table Crime(
crime_id int primary key identity(1,1),
date datetime,
primaryType varchar(50),
crimeDescription_id int foreign key(crimeDescription_id) references crimeDescription(crimeDescription_id),
location_id int foreign key(location_id) references location(location_id)
)
insert into Crime(date,primaryType,crimeDescription_id,location_id)
select Date,Primary_Type,crimeDescription_id,location_id
from chicago_crime_data,crimeDescription,location
where crimeDescription_id=chicago_crime_data.ID and
location_id = chicago_crime_data.ID

select top 100 * from crime order by crime_id desc


