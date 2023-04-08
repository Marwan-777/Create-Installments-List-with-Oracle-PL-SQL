create or replace procedure reset_seq_table
as
begin
    execute immediate 'drop sequence contract_ID_seq';
    execute immediate 'create sequence contract_ID_seq start with 1  increment by 1';
    delete installments_paid;
   
end;



