/*

--------------------------------------------------------------------------------------------------------------------------
Pre Req:
	- download Spatial Data Delivery Unit, GEO CONTENT ANALYTICS CLD
	- HANA system has to be configured with a valid Spatial Reference Identifier (SRID) used by SAP Analytics Cloud

-----------------------------------------------
To add Spatial Reference Identifier (SRID) 3857
-----------------------------------------------

CREATE SPATIAL REFERENCE SYSTEM "WGS 84 / Pseudo-Mercator" IDENTIFIED BY 3857
TYPE PLANAR
SNAP TO GRID 1e-4
TOLERANCE 1e-4
COORDINATE X BETWEEN -20037508.3427892447 AND 20037508.3427892447
COORDINATE Y BETWEEN -19929191.7668547928 AND 19929191.766854766
ORGANIZATION "EPSG" IDENTIFIED BY 3857
LINEAR UNIT OF MEASURE "metre"
ANGULAR UNIT OF MEASURE NULL
POLYGON FORMAT 'EvenOdd'
STORAGE FORMAT 'Internal'
DEFINITION 'PROJCS["Popular Visualisation CRS / Mercator",GEOGCS["Popular Visualisation CRS",DATUM["Popular_Visualisation_Datum",SPHEROID["Popular Visualisation Sphere",6378137,0,AUTHORITY["EPSG","7059"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6055"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4055"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Mercator_1SP"],PARAMETER["central_meridian",0],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],AUTHORITY["EPSG","3785"],AXIS["X",EAST],AXIS["Y",NORTH]]'
TRANSFORM DEFINITION '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs'



--------------------------------------------------------------------------------------------------------------------------
*/

-- check for Spacial Reference System ID (3857) exists in HANA

SELECT *
FROM ST_SPATIAL_REFERENCE_SYSTEMS
WHERE "SRS_ID" = 3857;


-- Create table to update the ST_GEOMETRY column required

CREATE COLUMN TABLE "hd"."zipGeoLoc" (
	"zipCode" VARCHAR(5) PRIMARY KEY
	,"zipGeoLoc" ST_GEOMETRY(3857)
	);


-- Insert the table with primary key values - for whose we need to capture the geo location

UPSERT "hd"."zipGeoLoc" ("zipCode")
SELECT DISTINCT "ZipCode" AS "zipCode"
FROM "hd"."free_zipcode_database_Primary";


-- Update the table with ST_Geometery Object

UPDATE "hd"."zipGeoLoc"
SET "zipGeoLoc" = new ST_GEOMETRY('POINT(' || "longitude" || ' ' || "latitude" || ')', 4326).ST_Transform(3857)
FROM (
	SELECT "ZipCode"
		,MIN("Lat") AS "latitude"
		,MIN("Long") AS "longitude"
	FROM "hd"."free_zipcode_database_Primary"
	GROUP BY "ZipCode"
	), 
	"hd"."zipGeoLoc" 
WHERE "ZipCode" = "zipCode";