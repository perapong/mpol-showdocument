BEGIN
    stp_iajob_process;
END;

/*
select count(*), sysdate from bw_rirep where reg_batchno is null

select * from bw_rirep where appt_campaign in ('012011','002011','022012') or appt_campaign is null or appt_campaign = ''

begin
    pkgbw_iaverify.mainprocedure; end;

begin
    pkgbw_iaverify.RegNoRecValidate(); end;

begin
    pkgbw_dsmsmart.createbatcid; end;

begin
    pkgbw_dsm_bsmart.transfertobsmart; end;
*/
