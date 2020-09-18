# notes (https://help.sap.com/viewer/9de0171a6027400bb3b9bee385222eff/2.0.04/en-US/e6ecf3e9ed9d4c4080dc8c99f1f47143.html)

	@Catalog.tableType: #COLUMN
	@nokey
	Entity unionPruningTable {
			SCHEMA : String(32) NOT NULL;
	    	CALC_SCENARIO : String(256) NOT NULL; 
	    	INPUT : String(124) NOT NULL;    	
	    	COLUMN	: String (64) NOT NULL;
			OPTION : String(32) NOT NULL;
			LOW_VALUE : String(64);
	    	HIGH_VALUE : String(64);
	    };
		

	insert into "bi"."hd.bi.db.ddl::tables.unionPruningTable" 
	values('SYS_BIC','hd.bi.db.models.dentrix.transactional/productionContractFee','clsd_mon','procLogYearMonthSAP','<=','201911','');
	
	insert into "bi"."hd.bi.db.ddl::tables.unionPruningTable" 
	values('SYS_BIC','hd.bi.db.models.dentrix.transactional/productionContractFee','open_mon','procLogYearMonthSAP','>','201911','');

	UPDATE "bi"."hd.bi.db.ddl::tables.unionPruningTable"
	SET "LOW_VALUE" = :vMaxClosedMonth
	WHERE "SCHEMA" = '_SYS_BIC'
		AND "CALC_SCENARIO" = 'hd.bi.db.models.dentrix.transactional/productionContractFee'
		AND "INPUT" = 'clsd_mon'
		AND "COLUMN" = 'procLogYearMonthSAP'
		AND "OPTION" = '<='
		AND "HIGH_VALUE" = ''
	;
	
	UPDATE "bi"."hd.bi.db.ddl::tables.unionPruningTable"
	SET "LOW_VALUE" = :vMaxClosedMonth
	WHERE "SCHEMA" = '_SYS_BIC'
	AND "CALC_SCENARIO" = 'hd.bi.db.models.dentrix.transactional/productionContractFee'
	AND "INPUT" = 'open_mon'
	AND "COLUMN" = 'procLogYearMonthSAP'
	AND "OPTION" = '>'
	AND "HIGH_VALUE" = ''
	;