CREATE DATABASE chicago_crime
USE chicago_crime

CREATE TABLE location_detail(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	location_description VARCHAR(150) NOT NULL,
	block VARCHAR(150) NOT NULL,
	district INT NOT NULL,
	ward INT NOT NULL,
	beat INT NOT NULL,
	community_area INT NOT NULL
)

INSERT INTO location_detail(location_description,block,district,ward,beat,community_area)
SELECT DISTINCT Location_Description,Block,District,Ward,Beat,Community_Area FROM dbRadar.dbo.chicago_crime_data
--Was the insertion successful? compare that all record where moved
select * from location_detail --558,308 records 
--select top 10 Date from chicago_crime_data order by ID desc


CREATE TABLE location(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	x_coordinate INT NOT NULL,
	y_coordinate INT NOT NULL,
	latitude DECIMAL(11,9) NOT NULL,
	longitude DECIMAL(12,9) NOT NULL,
	location_detail_id INT FOREIGN KEY REFERENCES location_detail(id) NOT NULL
)

INSERT INTO location(x_coordinate,y_coordinate,latitude,longitude,location_detail_id)
SELECT DISTINCT x_coordinate,y_coordinate,latitude,longitude,ld.id 
FROM dbRadar.dbo.chicago_crime_data as ccd, location_detail as ld
WHERE 
	ld.location_description = ccd.Location_Description AND
	ld.block = ccd.Block AND
	ld.district = ccd.District AND
	ld.ward = ccd.Ward AND 
	ld.beat = ccd.Beat AND
	ld.community_area = ccd.Community_Area 
--Was the insertion successful?
SELECT * FROM LOCATION ORDER BY location_detail_id DESC 


CREATE TABLE law_enforcement_code(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FBI_code VARCHAR(16) NOT NULL,
	IUCR VARCHAR(8) NOT NULL
)

INSERT INTO law_enforcement_code(FBI_code,IUCR)
SELECT DISTINCT FBI_Code,IUCR FROM dbRadar.dbo.chicago_crime_data
SELECT count(DISTINCT IUCR) FROM law_enforcement_code


CREATE TABLE crime_description(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	description	VARCHAR(150) NOT NULL,
	updated_on DATETIME NOT NULL,
	arrest BIT NOT NULL,
	domestic BIT NOT NULL
)

INSERT INTO crime_description(description,updated_on,arrest,domestic)
SELECT DISTINCT Description,Updated_On,Arrest,Domestic 
FROM dbRadar.dbo.chicago_crime_data AS ccd

SELECT COUNT(*) FROM crime_description --151,181 rows_tally


CREATE TABLE crime(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
case_number VARCHAR(16) NOT NULL,
primary_type VARCHAR(50) NOT NULL,
date DATETIME NOT NULL,
crime_description_id INT FOREIGN KEY REFERENCES crime_description(id),
law_enforcement_code_id INT FOREIGN KEY REFERENCES law_enforcement_code(id),
location_id INT FOREIGN KEY REFERENCES location(id)
)

INSERT INTO crime(case_number,primary_type,date,crime_description_id,law_enforcement_code_id,location_id)
SELECT DISTINCT ccd.Case_Number,ccd.Primary_Type,ccd.Date,cd.id,lec.id,l.id 
FROM dbRadar.dbo.chicago_crime_data as ccd, crime_description as cd, law_enforcement_code as lec, location as l, location_detail as ld
	WHERE 
	cd.description	= ccd.Description AND
	cd.updated_on = ccd.Updated_On AND
	cd.arrest = ccd.Arrest AND
	cd.domestic = ccd.Domestic AND

	lec.FBI_code = ccd.FBI_Code AND
	lec.IUCR = ccd.IUCR AND

	l.x_coordinate = ccd.X_Coordinate AND
	l.y_coordinate = ccd.Y_Coordinate AND
	l.latitude = ccd.Latitude AND
	l.longitude = ccd.Longitude AND

	ld.location_description = ccd.Location_Description AND
	ld.block = ccd.Block AND
	ld.district = ccd.District AND
	ld.ward = ccd.Ward AND 
	ld.beat = ccd.Beat AND
	ld.community_area = ccd.Community_Area AND
	ld.id = l.location_detail_id
	

SELECT count(*) FROM crime 
WHERE year(Date)='2018'




