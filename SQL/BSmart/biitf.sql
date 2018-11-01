SELECT *
from table (bwprod.PKGBW_YUPIN_ORD.Pip_XMLUpdate(to_date('25/07/2016 00:00:00','dd/mm/rrrr hh24:mi:ss'))) a
;


SELECT length(a.tmp_xmltag) dd, a.*
from table ( BWPROD.PKGBW_YUPIN_ORD.Pip_XMLUpdate ( trunc(sysdate)-1 ) ) a
where not (tmp_repseq = 9213214 and tmp_salecamp = '162016') 
order by 1 desc
;


length(a.tmp_xmltag) < 65535