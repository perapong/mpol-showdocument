select a.* from bw_rirep a
where loc_code = '0342'
  and rep_code = 'CS-REJECT'
order by first_name

--update bw_rirep set rep_code = 'AUTO', validate_check = 0 where reg_no = ''
