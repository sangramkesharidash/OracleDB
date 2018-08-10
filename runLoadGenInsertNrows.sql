
DECLARE
var_number_c1 NUMBER(10);
var_varchar210_c2 VARCHAR2(10); 
var_varchar2100_eximmd VARCHAR2(100); 
BEGIN
  FOR i IN 1 .. 100 LOOP
  var_number_c1 := TO_NUMBER(trunc(dbms_random.value(9999,99999999)));
  var_varchar210_c2 := DBMS_RANDOM.string('x',10) ;
  
  dbms_output.Put_line('var_number_c1 :: '|| var_number_c1);
  dbms_output.Put_line('var_varchar210_c2 :: '|| var_varchar210_c2);
  
  DBMS_OUTPUT.put_line('INSERT INTO rv2 VALUES ( ' ||var_number_c1||','||''''|| var_varchar210_c2||''''||', '''');'  );
  execute immediate 'INSERT INTO rv2 VALUES ( ' ||var_number_c1||','||''''|| var_varchar210_c2||''''||', '''')' ;

  END LOOP;
END;
/

commit;
select count(*) from RV2;

!date
exit
