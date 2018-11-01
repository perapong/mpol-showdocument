select d.odtbill_campaign, sum(d.odttrans_unit*b.bdtunit) unit--, sum(d.odttrans_ttlunit) ttlunit
--d.*
from om_transaction_dtl d ,  om_billing_dtl b
where d.odtou_code = '000' and d.odtyear = 12 and d.odttrans_group in (11,12,13)
            and d.odtbill_campaign in ('182012','192012','202012') and b.bdtou_code = d.odtou_code and b.bdtcampaign = d.odtbill_campaign
            and d.odtbill_code = b.bdtbill_code
            and bdtfinished_code = '37144'
group by d.odtbill_campaign
order by d.odtbill_campaign

--select * from om_billing_dtl where bdtou_code = '000' and bdtfinished_code = '37144' and bdtcampaign in ('182012')
