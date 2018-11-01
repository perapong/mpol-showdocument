select * from sa_channel_summary order by channelcode desc;
select * from sa_channel_summary_dtl order by channelcode desc, trans_date desc;
select * from db_logchanneltype order by channelcode desc;

select * from db_logsocial;
select * from db_logapplink;
select * from db_logchanneltype order by channelcode desc;

select *
from db_recruit_detail a
-- update db_recruit_detail set programcode = 4.01
where ProgramCode = 1
;
/*
select concat(',(', substr(mobile,2,10), ', ', substr(ProgramCode,4,1), ', ''https://app.ningnongmistine.com/ningnongmistinebloger/Channel/000', substr(ProgramCode,4,1), '/37?tel=', ''')') as ins, a.*
from db_recruit_detail a
where ProgramCode = 2.04
;
select concat(',(', substr(mobile,2,10), ', ', (substr(ProgramCode,4,1)+95), ', ''https://app.ningnongmistine.com/ningnongmistinebloger/Channel/000', (substr(ProgramCode,4,1)+3), '/44?tel=', ''')') as ins -- , a.*
from db_recruit_detail a
where ProgramCode between 3.01 and 3.04
;
*/

INSERT INTO db_logchannel_detail (channelcode, member_type, email, telephone, create_date) 
select 148 as channelcode, 'recruit' member_type, email, mobile telephone, NOW() create_date
# select * 
from db_recruit_detail
where ProgramCode = 5.4
;


#INSERT INTO db_logchannel_detail (channelcode, member_type, email, telephone, create_date) 
select 454 as channelcode, 'member' member_type, min(customer_email) as email, customer_telephone as telephone, NOW() create_date
from v_mkt_member_data
where customer_telephone is not null
  and length(customer_telephone) = 10 
  and customer_telephone not in ('0846014780','0821632104','0873247333')
group by customer_telephone
;  #1556


#INSERT INTO db_logchannel_detail (channelcode, member_type, email, telephone, create_date) 
select 455 as channelcode, 'guest' member_type, min(customer_email) as email, customer_telephone as telephone, NOW() create_date
from v_mkt_guest_data a
where a.customer_telephone is not null 
  and length(customer_telephone) = 10
  and customer_telephone not in ('0846014780','0821632104','0873247333')
  and not exists (select 1 from v_mkt_member_data t where t.customer_telephone = a.customer_telephone)
group by customer_telephone
;  #298


-- https://app.ningnongmistine.com/ningnongmistinebloger/Channel/0003/44
select distinct concat(',(', substr(telephone,2,10), ', ', a.channelcode, ', ''', b.channelurl, '?tel=', ''')') as ins -- , a.*
from db_logchannel_detail a
     inner join db_logchanneltype b on b.channelcode = a.channelcode
where a.channelcode in (508)
  and exists (select 1 from db_logchannel_detail t where t.channelcode in (151, 152) and t.telephone = a.telephone)
;


select * from db_logchannel_detail a
where a.channelcode in (107,108)
-- delete from 
db_recruit_detail where ProgramCode = 2.01;


select * from db_logchannel_detail;
select * from db_logchannel_detail where channelcode = 108;
select * from db_logchanneltype order by channelcode desc;
select * from db_logchannel_detail where channelcode = 118;
/*


INSERT into sms_20180427_1 (telephone,groupid,map_url)
VALUES (



*/

select trans_date, channelcode, cntconfirm, cntorder, sumitems, sumqty, sumamount from (
select date(c.created_at) trans_date, b.channelcode
-- , a.* 
-- , b.*
-- , c.*
 , count(distinct a.entity_id) cntconfirm, count(distinct c.entity_id) cntorder
 , sum(total_item_count) sumitems, sum(total_qty_ordered) sumqty, sum(base_subtotal_incl_tax) sumamount
from quote a  
 		 inner join (select distinct channelcode, quote_id, param from db_logquote) b on a.entity_id = b.quote_id
 		 inner join sales_order c on a.entity_id = c.quote_id
where date(c.created_at) >= date(20180427)
  and b.channelcode = 83
  and not exists (select 'p' from db_member_group t where substr(t.mobileno,2,10) = param)
group by date(c.created_at), channelcode
) p