select * from ar_transactions_hdr
where tshrep_code = '0793060488'


select * from ar_apply_hdr where aahrep_code = '0793060488'


declare
    vErrMsg varchar2(2000);
    vErrCode varchar2(200);
begin 
    --vErrCode := pkgbw_dms.ScanNewOrder('11007938932', 'BEDMPC01', 'perapong', vErrMsg);
    --vErrCode := pkgbw_dms.ScanCtrlPallet('11007938932', null, 'perapong', '1', 'BEDMPC01', 'perapong', vErrMsg);
    vErrCode := pkgbw_dms.ScanCtrlPallet('11007876112', 'ttno', null, '2', 'BEDMPC01', 'perapong', vErrMsg);
end;



select * from dm_fragile_tracking 
where trunc(ftrcre_date) = trunc(sysdate)
  and ftrfragile_no in ('11007876112','11007919812','11007938932')
--and ftrtracking_status = '00'
--and  --'11007757752'
1100796338
1100793109
1100798754
1100785466  
  
select * from sh_ship_scan s
where sssship_date = trunc(sysdate)
  --and not exists (select * from dm_fragile_tracking where trunc(ftrcre_date) = trunc(sysdate) and ftrfragile_no = sssfragile_no)
  and sssfragile_no in ('11007876112','11007919812','11007938932')


select * from dm_order_tracking
where otrinv_trans_no in ('1100787611','1100791981','1100793893')

