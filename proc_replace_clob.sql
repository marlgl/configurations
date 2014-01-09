create or replace procedure proc_replace_clob(
    i_id INTEGER DEFAULT 0, i_value VARCHAR2 DEFAULT NULL, i_offset INTEGER DEFAULT 1)
IS
    old_value       CLOB;
    new_value       VARCHAR2(5000);
    v_id            INTEGER;
    value_length    BINARY_INTEGER;
    erase_length    INTEGER := 0;
begin
    IF i_value is NULL THEN
        new_value := '8=IMIX.1.0^A9=920^A35=8^A34=509290^A49=CFETS-ComSTP^A52=20140102-13:21:49.544^A56=139^A57=server_test^A115=WMS^A15=CNY^A32=2000000000.
00000000^A44=100.00000000^A54=1^A60=20140102-13:21:49.242^A64=20121207^A75=20121207^A119=2000000000.00000000^A553=195^A731=3^A1126=N^A10002=0.0000000
0^A10041=NA2013101400362^A10048=100.00000000^A10105=1^A10221=20131014-21:20:04^A10318=21:20:04^A10410=20131015-11:35:04^A10411=195^A10676=A/R_ZCGL791
0000001212003^A10687=0^A10748=0^A10808=9823^A10890=25424^A11026=20131014^A11107=N00139XA1212003^A11108=山西省交通厅^A11109=139_12^A11110=证券公司资产
管理计划^A11119=2000000000^A11120=4000000000^A11123=0^A136=3^A137=0.00000000^A139=2^A137=0.00000000^A139=101^A137=0.00000000^A139=103^A232=1^A233=Yie
ld2^A234=10.53874119^A453=2^A448=139^A452=119^A802=2^A523=0^A803=168^A523=195^A803=101^A448=-^A452=120^A802=1^A523=0^A803=157^A10866=2^A10535=NA20131
01400362^A10869=13^A10535=NA2013101400360^A10869=14^A11104=3^A11106=9^A11105=Y^A11106=10^A11105=N^A11106=20^A11105=N^A10=084^A';
    ELSE
        new_value := i_value;
    END IF;

    IF i_id = 0  THEN
        v_id := 4958208;
    ELSE
        v_id := i_id;
    END IF;
    
    value_length  := length(new_value);
    dbms_output.put_line('--> NEW length: ' || value_length); 
    select message into old_value from comstp_imix where id = v_id for update;
    dbms_lob.write(old_value, value_length, i_offset, new_value);

    -- Erase
    IF value_length > 0 AND length(new_value) < length(old_value) THEN
        erase_length := length(old_value) - value_length;
        dbms_output.put_line('--> OLD length: ' || length(old_value) 
            || ' EARSE length: ' || erase_length);
        dbms_lob.erase(old_value, erase_length, value_length + 1);
        dbms_lob.trim(old_value, value_length);
    END IF;
    commit;
end;
/

/*
begin
   proc_replace_clob(4958208, rpad('*', 1200, '*'));
end;
*/
