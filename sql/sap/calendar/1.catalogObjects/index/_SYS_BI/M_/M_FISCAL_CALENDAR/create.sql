CREATE COLUMN TABLE "_SYS_BI"."M_FISCAL_CALENDAR" ("CALENDAR_VARIANT" VARCHAR(2), "DATE" VARCHAR(8), "DATE_SQL" DATE CS_DAYDATE, "FISCAL_YEAR" VARCHAR(4), "FISCAL_PERIOD" VARCHAR(3), "CURRENT_YEAR_ADJUSTMENT" VARCHAR(2), PRIMARY KEY ("CALENDAR_VARIANT", "DATE")) UNLOAD PRIORITY 0  AUTO MERGE 