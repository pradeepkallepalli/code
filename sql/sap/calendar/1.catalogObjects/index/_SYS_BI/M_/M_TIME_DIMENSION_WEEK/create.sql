CREATE COLUMN TABLE "_SYS_BI"."M_TIME_DIMENSION_WEEK" ("YEAR" VARCHAR(4), "HALFYEAR" VARCHAR(2), "QUARTER" VARCHAR(2), "MONTH" VARCHAR(2), "WEEK" VARCHAR(2), "CALQUARTER" VARCHAR(5), "CALMONTH" VARCHAR(6), "CALWEEK" VARCHAR(6), "YEAR_INT" INTEGER CS_INT, "HALFYEAR_INT" TINYINT CS_INT, "QUARTER_INT" TINYINT CS_INT, "MONTH_INT" TINYINT CS_INT, "WEEK_INT" TINYINT CS_INT, PRIMARY KEY ("YEAR", "WEEK")) UNLOAD PRIORITY 0  AUTO MERGE 