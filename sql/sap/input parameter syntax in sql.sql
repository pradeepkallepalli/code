-- syntax for input parameter with constant in sql script

	('PLACEHOLDER' = ('$$ip_firstDayOfTheMonth$$','2015-05-01')) 
	
-- syntax for input parameter with variable  in sql script

	(PLACEHOLDER."$$ip_firstDayOfTheMonth$$" => :ip_firstDayOfTheMonth)