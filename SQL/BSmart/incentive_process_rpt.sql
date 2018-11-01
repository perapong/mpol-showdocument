select trunc(spslastdate), count(*)
from SA_POINT_MNTLY_RG1
group by trunc(spslastdate)
order by trunc(spslastdate) DESC

select trunc(spslastdate), count(*)
from sa_point_yearly_rg1
group by trunc(spslastdate)
order by trunc(spslastdate) DESC

select trunc(spslastdate), count(*)
from SA_POINT_MNTLY_YS
group by trunc(spslastdate)
order by trunc(spslastdate) DESC

select trunc(spslastdate), count(*)
from SA_POINT_YEARLY_YS
group by trunc(spslastdate)
order by trunc(spslastdate) DESC



declare 
    enddate     date;
    nProcSts    number;
    sErrMsg     varchar2(200);
begin
        enddate := to_date('31/01/2014','dd/mm/rrrr');
        bwprod.pkgbw_update_bpr.Update_Point_Campaignly('000',to_char(enddate,'dd/mm/rrrr'),'CTD','CAMPAIGNEND','BWOMRP73',73,nProcSts,sErrMsg);
--            bwprod.pkgbw_update_bpr.Update_Point_Campaignly('000',to_char(enddate,'dd/mm/rrrr'),'YTD','CAMPAIGNEND','BWOMRP73',73,nProcSts,sErrMsg);
--            
 --       commit;
--            
end;

