insert into billcode2
select *
from billcode 
where CAMP >= '201500';


insert into billcode_mispro2
select *
from billcode_mispro
where CAMP >= '201500';


insert into billcode_msg2
select * 
from billcode_msg
where CAMP >= '201500';


insert into billcode_short2
select * 
from billcode_short m
where SUBSTRING(CAMP, (LENGTH(CAMP)-3), 4) = '2015';


insert into billcodehbd2
select * 
from billcodehbd
where CAMP >= '201500';


insert into catalogue2
select * 
from catalogue
where CAMP >= '201500';


insert into catalogue_data2
select * 
from catalogue_data
where CAMP >= '201500';


insert into msl_register2
select *
from msl_register
where DWNFLAG = 'N'
and TRANDATE >= '20150420';


insert into mslmst2
select * 
from mslmst m
where DATE_FORMAT(LAST_LOGIN, '%Y') = '2015';


insert into order_header2
select *
from order_header
where ORDCAMP >= '201508'
  and DWNFLAG = 'N'
  and DELFLAG <> 'Y';


insert into order_detail2
select *  
from order_detail
where ORDCAMP >= '201508'
  and DWNFLAG = 'N'
  and DELFLAG <> 'Y';


insert into promotionheader2
select *  
from promotionheader
where CAMP >= '201500';


insert into tbl0082
select *  
from tbl008
where CAMP >= '201500';


insert into tbl0152
select *  
from tbl015
where CAMP >= '201500';


-------------------------------------------------------

select 1 type, count(*) a from billcode 
where CAMP >= '201500' 
union
select 2 type, count(*) a from billcode2;

select 1 type, count(*) a from billcode_mispro
where CAMP >= '201500'
union
select 2 type, count(*) a from billcode_mispro2;

select 1 type, count(*) a from billcode_msg
where CAMP >= '201500'
union
select 2 type, count(*) a from billcode_msg2;

select 1 type, count(*) a from billcode_short m
where SUBSTRING(CAMP, (LENGTH(CAMP)-3), 4) = '2015'
union
select 2 type, count(*) a from billcode_short2;

select 1 type, count(*) a from billcodehbd
where CAMP >= '201500'
union
select 2 type, count(*) a from billcodehbd2;

select 1 type, count(*) a from catalogue
where CAMP >= '201500'
union
select 2 type, count(*) a from catalogue2;

select 1 type, count(*) a from catalogue_data
where CAMP >= '201500'
union
select 2 type, count(*) a from catalogue_data2;

select 1 type, count(*) a from msl_register
where DWNFLAG = 'N'
and TRANDATE >= '20150420'
union
select 2 type, count(*) a from msl_register2;

select 1 type, count(*) a from mslmst m
where DATE_FORMAT(LAST_LOGIN, '%Y') = '2015'
union
select 2 type, count(*) a from mslmst2;

select 1 type, count(*) a from order_header
where ORDCAMP >= '201508'
  and DWNFLAG = 'N'
  and DELFLAG <> 'Y'
union
select 2 type, count(*) a from order_header2;

select 1 type, count(*) a from order_detail
where ORDCAMP >= '201508'
  and DWNFLAG = 'N'
  and DELFLAG <> 'Y'
union
select 2 type, count(*) a from order_detail2;

select 1 type, count(*) a from promotionheader
where CAMP >= '201500'
union
select 2 type, count(*) a from promotionheader2;

select 1 type, count(*) a from tbl008
where CAMP >= '201500'
union
select 2 type, count(*) a from tbl0082;

select 1 type, count(*) a from tbl015
where CAMP >= '201500'
union
select 2 type, count(*) a from tbl0152;