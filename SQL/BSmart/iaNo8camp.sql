select --stf_iastatus(reg_no) status, --pkgbw_dsm_bsmart.get_apptcamp( loc_code,'162012','162012'),
--(select min(mp.shipdate) from bev$_mailplan mp where mp.loc_code = a.loc_code and trunc(send_date) <= mp.shipdate) ship_date,
--(select r.repappt_campaign from ms_representative r where r.repou_code = '000' and r.reprep_code = a.rep_code) approve_camp,
--pkgbw_dsm_bsmart.ChkApptCamp('000', loc_code, Send_DATE,appt_campaign) est_camp, pkgbw_dsm_bsmart.getLoc_Campaign('000', loc_code,sysdate) cur_camp,
--pkgbw_iaverify.getxdivcode(loc_code) divcode,
a.* from bwprod.bw_rirep a
where fource_status='NO80' 
--and trunc(validate_date) = trunc(sysdate)
order by rep_code, cre_date desc


select distinct ''''||reg_no||''',' reg_no from (
select    rx.div_code,
          rx.loc_code,
          SUBSTR (rx.appt_campaign, 1, 2) || '/' || SUBSTR (rx.appt_campaign, 3, 4) appt_campaign,               
          trim(rx.rep_code) rep_code,
          rx.msl_name ||'(' || trim(rx.rep_code)||' )'  msl_name,
          rx.reg_no,
          rx.send_date,
          rx.validate_date ,
          nvl(e.err_code,rx.txt_error) err_code,
          --pkgbw_iaverify.GetTabletError( nvl(e.err_code,rx.txt_error) ) err_name,
          pkgbw_desc.getxRepFormat(e.rep_code )    err_rep_code,   
          e.rep_name err_rep_name,    
          --e.dept_amt err_dept_amt,     
          --fource_status
          (select repappt_status from ms_representative ms where ms.repou_code = '000' and ms.reprep_code = e.rep_code) appt_status,
          (select min(mp.shipdate) from bev$_mailplan mp where mp.loc_code = rx.loc_code and trunc(send_date) <= mp.shipdate) ship_date
  from bev$_iaprofile rx ,bw_richk_logerr e
    Where rx.reg_no = e.reg_no(+)
      and fource_status='NO80' 
      and validate_date >= to_date('28/11/2012 12:00:00','dd/mm/rrrr hh24:mi:ss')
      and err_code = '0101'
) where ship_date = to_date('28/11/2012','dd/mm/rrrr')
order by rep_code, reg_no






select rx.div_code,
          rx.loc_code,
          SUBSTR (rx.appt_campaign, 1, 2) || '/' || SUBSTR (rx.appt_campaign, 3, 4) appt_campaign,               
          trim(rx.rep_code) rep_code,
          rx.msl_name ||'(' || trim(rx.rep_code)||' )'  msl_name,
          rx.reg_no,
          rx.send_date,
          rx.validate_date ,
          --nvl(e.err_code,rx.txt_error) err_code,
          --pkgbw_iaverify.GetTabletError( nvl(e.err_code,rx.txt_error) ) err_name,
          pkgbw_desc.getxRepFormat(e.rep_code )    err_rep_code,   
          e.rep_name err_rep_name,    
          --e.dept_amt err_dept_amt,     
          --fource_status
          (select repappt_status from ms_representative ms where ms.repou_code = '000' and ms.reprep_code = e.rep_code) appt_status,
          (select min(mp.shipdate) from bev$_mailplan mp where mp.loc_code = rx.loc_code and trunc(send_date) <= mp.shipdate) ship_date
  from bev$_iaprofile rx ,bw_richk_logerr e
    Where rx.reg_no = e.reg_no(+)
      and fource_status='NO80' 
      and trunc(validate_date) between to_date('30/11/2012','dd/mm/rrrr') and to_date('02/12/2012','dd/mm/rrrr') 
      and err_code = '0101'
order by 1,2,rep_code


select * from ms_representative ms 
where repou_code = '000'
and reprep_code in (select dele_repcode from bw_rirep rx
                    where fource_status='NO80' 
                      and validate_date between to_date('28/11/2012 01:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('28/11/2012 12:00:00','dd/mm/rrrr hh24:mi:ss'))
                      
select * from ms_transaction
where retou_code = '000'
and rettran_reason_code = '7'
and retrep_seq in (select reprep_seq from ms_representative ms 
                    where repou_code = '000'
                    and reprep_code in (select dele_repcode from bw_rirep rx
                                        where fource_status='NO80' 
                                          and validate_date >= to_date('28/11/2012 12:00:00','dd/mm/rrrr hh24:mi:ss')))


select * from ms_transaction where rettran_reason_code = '7' and retrep_seq = 176527



/*-------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*  check case id card not equal  */

select * --''''||dele_repcode||''',' cc
from bw_rirep ri
where reg_no is not null
  and substr(nvl(rep_code,'null'),1,1) in ('1','2','3','4','5','6','7','8','9','0')
  and fource_status='NO80' 
--and rep_code = '0142164933'
  and validate_date between to_date('01/12/2012 12:00:00','dd/mm/rrrr hh24:mi:ss') and  to_date('04/12/2012 19:00:00','dd/mm/rrrr hh24:mi:ss')
  and exists (select * from ms_representative ms where ms.repou_code = '000' and ms.reprep_code = ri.dele_repcode and ms.repfirst_name = ri.first_name and ms.replast_name = ri.last_name)
  and not exists (select * from ms_representative ms where ms.repou_code = '000' and ms.reprep_code = ri.dele_repcode and ms.repid_card = ri.id_card)
  and exists (select * from ms_transaction t where t.rettran_type = 'DE' and t.retrep_seq in (select reprep_seq from ms_representative a where repou_code = '000' and reprep_code = ri.dele_repcode))
order by rep_code


select --(select rettran_date from ms_transaction t where t.retrep_seq = a.reprep_seq and t.rettran_type = 'RE') dd,
--(select distinct min(mx.mplcampaign) from bemv$_mailplan mx where mx.mplou_code = repou_code and mx.loc_code = reploc_code and trunc(repappt_st_date) between mx.start_ship and mx.end_ship),
a.* from ms_representative a
--update ms_representative a set repappt_st_date = (select rettran_date from ms_transaction t where t.retrep_seq = a.reprep_seq and t.rettran_type = 'RE')
--update ms_representative a set repappt_st_campaign = (select distinct min(mx.mplcampaign) from bemv$_mailplan mx where mx.mplou_code = repou_code and mx.loc_code = reploc_code and trunc(repappt_st_date) between mx.start_ship and mx.end_ship)
where repou_code = '000' and reprep_code in ('0442057037',
'0182092495','0220026051','0425045462','0102026212','0447053716','0047079731','0307171174','0796047252',
'0795007706','0765059218','0769022993','0380089818','0606167746','0450073822','0568035033','0650045861','0470046531','0336058718','0443061026',
'0579087076','0548075540','0039047902','0050043346','0653093599','0687079189','0743014508','0331037940','0840006688','0302025038','0632062995')


select * from ms_transaction t where  t.retrep_seq in (select reprep_seq from ms_representative a where repou_code = '000' and reprep_code in ('0548075540'))










