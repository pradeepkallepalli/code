DO
BEGIN

# id or index column is mandatory to unnest the array as table
DECLARE id INTEGER ARRAY = ARRAY(1,2,3);  
DECLARE dept NVARCHAR(20) ARRAY = ARRAY('office','reg','corp');


tab = UNNEST(:id, :dept) as (id, dept);

select id, dept from :tab;

END;