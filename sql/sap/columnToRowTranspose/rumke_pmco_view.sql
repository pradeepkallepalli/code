-- Steps Achieve the Required Result

-- 1. Create the table with following SQL
	
		CREATE COLUMN TABLE "PKALLEPALLI"."matrix" ("constant" INTEGER CS_INT,
			 "period" NVARCHAR(5),
			 "INDIC_WRT00" INTEGER CS_INT,
			 "INDIC_WRT01" INTEGER CS_INT,
			 "INDIC_WRT02" INTEGER CS_INT,
			 "INDIC_WRT03" INTEGER CS_INT,
			 "INDIC_WRT04" INTEGER CS_INT,
			 "INDIC_WRT05" INTEGER CS_INT,
			 "INDIC_WRT06" INTEGER CS_INT,
			 "INDIC_WRT07" INTEGER CS_INT,
			 "INDIC_WRT08" INTEGER CS_INT,
			 "INDIC_WRT09" INTEGER CS_INT,
			 "INDIC_WRT10" INTEGER CS_INT,
			 "INDIC_WRT11" INTEGER CS_INT,
			 "INDIC_WRT12" INTEGER CS_INT) UNLOAD PRIORITY 5 AUTO MERGE 
		;

-- 2. Load the table with CSV provided
-- 3. Create a graphical calculation view /Table function with the following sql 
-- Note: Please change the schema name in the sql from "PKALLEPALLI" to the appropriate schema names

		select
		A."MANDT",
		A."OBJNR",
		A."COCUR",
		A."BELTP",
		A."WRTTP",
		A."GJAHR",
		A."ACPOS",
		A."VERSN",
		A."PERBL",
		A."VORGA",
		A."BEMOT",
		A."ABKAT",
		right(B."period",2) as "RPT_PERIOD",
		(A."WRT00" * B."INDIC_WRT00" + A."WRT01" * B."INDIC_WRT01" + A."WRT02" * B."INDIC_WRT02" + A."WRT03" * B."INDIC_WRT03" + A."WRT04" * B."INDIC_WRT04" + A."WRT05" * B."INDIC_WRT05" + A."WRT06" * B."INDIC_WRT06" + A."WRT07" * B."INDIC_WRT07" + A."WRT08" * B."INDIC_WRT08" + A."WRT09" * B."INDIC_WRT09" + A."WRT10" * B."INDIC_WRT10" + A."WRT11" * B."INDIC_WRT11" + A."WRT12" * B."INDIC_WRT12") as "WRT_VALUE"
		FROM (
		select 
		"MANDT",
		"OBJNR",
		"COCUR",
		"BELTP",
		"WRTTP",
		"GJAHR",
		"ACPOS",
		"VERSN",
		"PERBL",
		"VORGA",
		"BEMOT",
		"ABKAT",
		"WRT00",
		"WRT01",
		"WRT02",
		"WRT03",
		"WRT04",
		"WRT05",
		"WRT06",
		"WRT07",
		"WRT08",
		"WRT09",
		"WRT10",
		"WRT11",
		"WRT12"+"WRT13"+"WRT14"+"WRT15"+"WRT16" AS "WRT12"
		 from "PKALLEPALLI"."pmco") AS A CROSS JOIN "PKALLEPALLI"."matrix" B
		 ORDER BY A."OBJNR", B."period"
		 ;