
declare
    cursor all_installments IS
        select contract_ID, contract_enddate, contract_startdate, 
                 contract_total_fees-contract_deposit_fees as amount , 
                 client_ID, contract_payment_type as type 
        from contracts ;
        
v_installments_no number(12,9) ;
v_amount number(12,3);
v_months_no number(2) ;
v_date date ;
begin
           
    -- Is to reset the table and re create the sequence
    reset_seq_table();
    
    
    FOR inst in all_installments LOOP
        v_installments_no := months_between(inst.contract_enddate, inst.contract_startdate);
        IF inst.type = 'ANNUAL' THEN
            v_installments_no := round(v_installments_no/12);
            v_months_no := 12 ;
        END IF;
        IF inst.type = 'MONTHLY' THEN
            v_installments_no := round(v_installments_no);
            v_months_no := 1;
        END IF;
         IF inst.type = 'QUARTER' THEN
            v_installments_no := round(v_installments_no/3);
            v_months_no := 3;
        END IF;
         IF inst.type = 'HALF_ANNUAL' THEN
            v_installments_no := round(v_installments_no/6);
            v_months_no := 6;
        END IF;
        v_amount := round(inst.amount/v_installments_no,2 );
        v_date := inst.contract_startdate ;
        FOR i in 1 ..v_installments_no LOOP
            insert into installments_paid(INSTALLMENT_ID, CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
            values(contract_ID_seq.nextval , inst.contract_ID, v_date, v_amount, null);
            v_date := add_months(v_date, v_months_no) ;
        END LOOP;
    END LOOP;
End;









