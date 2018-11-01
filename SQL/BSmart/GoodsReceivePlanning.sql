select * from pp_po_hdr
where pohou_code = '000'
  and pohpo_no = '1PO13002772'



select * from pp_po_dtl
--update pp_po_dtl set podstatus = 'A'
where podou_code = '000'
  and podpo_no = '1PO13002772'
  and podfs_code = '42035'



select * 
from pp_ctc_dtl
where pcdou_code = '000'
  and pcdpo_no = '1PO13002772'
  and pcdfs_code = '42035'
  


select * from bw_whrc_plan
where ou_code = '000'
  and brand = 1
--and sup_code = '002070'
--and plan_rec_date = to_date('04/09/2014','dd/mm/rrrr')
  and po_no = '1PO13002772'
  and fs_code = '42035'
  
  
  
select *
from bw_whrc_transaction 
where ou_code = '000'
  and po_no = '1PO13002772'
  and fs_code = '42035'
order by trans_date


/*
trans_type
GRP = Plan
REC = Receive Memo
*/


select * from bw_whrc_log
where ou_code = '000'
  and po_no =  '1PO13002772'
  and fs_code = '42035'
order by  log_date, log_seq
  
  
-------   Receive Memo data Transaction from WMS Interface    ------

select * from wh_rcv_memo_hdr
where rmhpo_no = '1PO13002772'

select * from wh_rcv_memo_dtl
where rmdou_code = '000'
  and rmdmemo_no in (select rmhmemo_no from wh_rcv_memo_hdr where rmhpo_no = '2PO14011273')
  and rmdfinished_code = '42035'


1410002200
1410002867
