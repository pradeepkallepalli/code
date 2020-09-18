CREATE COLUMN TABLE "BI"."config" 
	("group" NVARCHAR(32) NOT NULL ,
	 "parameter" NVARCHAR(124) NOT NULL,
	 "selection_type" NVARCHAR(12),
	 "value_From" NVARCHAR(512),
	 "value_To" NVARCHAR(512),
	 "comments" NVARCHAR(512),
	 PRIMARY KEY ("group",
	 	"parameter")) UNLOAD PRIORITY 5 AUTO MERGE ;