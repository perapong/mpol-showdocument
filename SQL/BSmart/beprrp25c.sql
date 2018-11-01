Select 
       '000' ou_code, Ax.brand, ax.prd_id, ax.category1, ax.fscode,
       Ax.QtyCol1, Ax.QtyCol2, Ax.QtyCol3, Ax.QtyCol4, Ax.QtyCol5, Ax.QtyCol6,
       Ax.InvCol1, Ax.InvCol2, Ax.InvCol3, Ax.InvCol4, Ax.InvCol5, Ax.InvCol6,
       Bx.PlanAmt1,  Bx.PlanAmt2, Bx.PlanAmt3, Bx.PlanAmt4, Bx.PlanAmt5, Bx.PlanAmt6,
       Bx.PlanUnit1, Bx.PlanUnit2, Bx.PlanUnit3, Bx.PlanUnit4, Bx.PlanUnit5, Bx.PlanUnit6,
       case when Bx.PlanAmt1 <>0 Then round(Ax.InvCol1 /Bx.PlanAmt1 ,2) end M1Cover,
       case when Bx.PlanAmt2 <>0 Then round(Ax.InvCol2 /Bx.PlanAmt2 ,2) end M2Cover,
       case when Bx.PlanAmt3 <>0 Then round(Ax.InvCol3 /Bx.PlanAmt3 ,2) end M3Cover,
       case when Bx.PlanAmt4 <>0 Then round(Ax.InvCol4 /Bx.PlanAmt4 ,2) end M4Cover, 
       case when Bx.PlanAmt5 <>0 Then round(Ax.InvCol5 /Bx.PlanAmt5 ,2) end M5Cover,
       case when Bx.PlanAmt6 <>0 Then round(Ax.InvCol6 /Bx.PlanAmt6 ,2) end M6Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol1 /Bx.PlanUnit1 ,2) end Q1Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol2 /Bx.PlanUnit2 ,2) end Q2Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol3 /Bx.PlanUnit3 ,2) end Q3Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol4 /Bx.PlanUnit4 ,2) end Q4Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol5 /Bx.PlanUnit5 ,2) end Q5Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol6 /Bx.PlanUnit6 ,2) end Q6Cover
       
from ( Select    
         Wx.brand,
         Wx.prdproduction_id prd_id,  
         Wx.category1,
         pdtfinished_code fscode, 
         sum(Case when (Wx.year_campaign = '201221' ) Then bal_pcs End) QtyCol1,
         sum(Case when (Wx.year_campaign = '201222' ) Then bal_pcs End) QtyCol2,
         sum(Case when (Wx.year_campaign = '201223' ) Then bal_pcs End) QtyCol3,
         sum(Case when (Wx.year_campaign = '201224' ) Then bal_pcs End) QtyCol4,
         sum(Case when (Wx.year_campaign = '201225' ) Then bal_pcs End) QtyCol5,
         sum(Case when (Wx.year_campaign = '201226' ) Then bal_pcs End) QtyCol6,

         sum(Case when (Wx.year_campaign = '201221' ) Then bal_Amt End) InvCol1,
         sum(Case when (Wx.year_campaign = '201222' ) Then bal_Amt End) InvCol2,
         sum(Case when (Wx.year_campaign = '201223' ) Then bal_Amt End) InvCol3,
         sum(Case when (Wx.year_campaign = '201224' ) Then bal_Amt End) InvCol4,
         sum(Case when (Wx.year_campaign = '201225' ) Then bal_Amt End) InvCol5,
         sum(Case when (Wx.year_campaign = '201226' ) Then bal_Amt End) InvCol6 
  FROM bev$_pckpi_camp Wx  
  where Wx.brand   = '1' 
    and year_campaign  between '201221'  and '201226'
  group by Wx.brand, Wx.prdproduction_id, Wx.category1, pdtfinished_code  ) Ax,
  
( SELECT prdbrand, prod_id, category1,fscode ,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201221' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt1,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201222' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt2,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201223' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt3,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201224' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt4,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201225' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt5,
         sum(Case when pkgbw_misc.GetKpi_PCCamp('201226' , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt6,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201221' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201222' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit1,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201222' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201223' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit2,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201223' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201224' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit3,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201224' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201225' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit4,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201225' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201226' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit5,
         sum((nvl(Case when pkgbw_misc.GetKpi_PCCamp('201226' , Mx.year_camp) ='TRUE' Then plan_unit End,0) + 
              nvl(Case when pkgbw_misc.GetKpi_PCCamp('201301' , Mx.year_camp) ='TRUE' Then adv_plan_unit End,0)))/4 PlanUnit6 
FROM bev$_pckpi_mktcamp Mx
where mx.prdbrand    = '1'
    and Mx.year_camp  between   '201221' and  '201305'
    group by prod_id, prdbrand, category1 , fscode  ) Bx
Where  Ax.brand    = Bx.prdBrand
  and Ax.prd_id    = Bx.prod_id
  and Ax.category1 = Bx.category1
  and Ax.fscode    = Bx.fscode
  and Ax.prd_id between  nvl('103',chr(20))  and nvl('103',chr(250))
  and Ax.fscode between  nvl('14240',chr(20))  and nvl('14240',chr(250))
Order by Ax.brand, ax.prd_id, ax.category1, fscode




/*
Select 
        '000' ou_code, Ax.brand, ax.prd_id, ax.category1, ax.fscode,
        Ax.QtyCol1, Ax.QtyCol2, Ax.QtyCol3, Ax.QtyCol4, Ax.QtyCol5, Ax.QtyCol6,
       Ax.InvCol1, Ax.InvCol2, Ax.InvCol3, Ax.InvCol4, Ax.InvCol5, Ax.InvCol6,
       Bx.PlanAmt1,  Bx.PlanAmt2, Bx.PlanAmt3, Bx.PlanAmt4, Bx.PlanAmt5, Bx.PlanAmt6,
       Bx.PlanUnit1, Bx.PlanUnit2, Bx.PlanUnit3, Bx.PlanUnit4, Bx.PlanUnit5, Bx.PlanUnit6,
       case when Bx.PlanAmt1 <>0 Then round(Ax.InvCol1 /Bx.PlanAmt1 ,2) end M1Cover,
       case when Bx.PlanAmt2 <>0 Then round(Ax.InvCol2 /Bx.PlanAmt2 ,2) end M2Cover,
       case when Bx.PlanAmt3 <>0 Then round(Ax.InvCol3 /Bx.PlanAmt3 ,2) end M3Cover,
       case when Bx.PlanAmt4 <>0 Then round(Ax.InvCol4 /Bx.PlanAmt4 ,2) end M4Cover, 
       case when Bx.PlanAmt5 <>0 Then round(Ax.InvCol5 /Bx.PlanAmt5 ,2) end M5Cover,
       case when Bx.PlanAmt6 <>0 Then round(Ax.InvCol6 /Bx.PlanAmt6 ,2) end M6Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol1 /Bx.PlanUnit1 ,2) end Q1Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol2 /Bx.PlanUnit2 ,2) end Q2Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol3 /Bx.PlanUnit3 ,2) end Q3Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol4 /Bx.PlanUnit4 ,2) end Q4Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol5 /Bx.PlanUnit5 ,2) end Q5Cover,
       case when Bx.PlanUnit1 <>0 Then round(Ax.QtyCol6 /Bx.PlanUnit6 ,2) end Q6Cover
       
from ( Select    
         Wx.brand,
         Wx.prdproduction_id prd_id,  
         Wx.category1,
         pdtfinished_code fscode, 
        sum(Case when (Wx.year_campaign = :cp_YeaCampcol1 ) Then bal_pcs End) QtyCol1,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol2 ) Then bal_pcs End) QtyCol2,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol3 ) Then bal_pcs End) QtyCol3,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol4 ) Then bal_pcs End) QtyCol4,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol5 ) Then bal_pcs End) QtyCol5,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol6 ) Then bal_pcs End) QtyCol6,

         sum(Case when (Wx.year_campaign = :cp_YeaCampcol1 ) Then bal_Amt End) InvCol1,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol2 ) Then bal_Amt End) InvCol2,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol3 ) Then bal_Amt End) InvCol3,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol4 ) Then bal_Amt End) InvCol4,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol5 ) Then bal_Amt End) InvCol5,
         sum(Case when (Wx.year_campaign = :cp_YeaCampcol6 ) Then bal_Amt End) InvCol6 
    FROM bev$_pckpi_camp Wx  
  where Wx.brand   = '1' 
    and year_campaign  between :cp_YeaCampcol1  and :cp_YeaCampcol6
  group by Wx.brand, Wx.prdproduction_id, Wx.category1, pdtfinished_code  ) Ax,
  
 ( SELECT prdbrand, prod_id, category1,fscode ,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol1 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt1,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol2 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt2,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol3 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt3,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol4 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt4,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol5 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt5,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol6 , Mx.year_camp) ='TRUE' Then plan_amt End)/4 PlanAmt6,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol1 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit1,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol2 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit2,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol3 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit3,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol4 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit4,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol5 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit5,
         sum(Case when pkgbw_misc.GetKpi_PCCamp(:cp_YeaCampcol6 , Mx.year_camp) ='TRUE' Then plan_unit End)/4 PlanUnit6 
  FROM bev$_pckpi_mktcamp Mx
where  mx.prdbrand    = '1'
    and Mx.year_camp    between  :cp_YeaCampcol1 and  :cp_YeaCampcol7
    group by prod_id, prdbrand, category1 , fscode  ) Bx
 Where  Ax.brand   = Bx.prdBrand
  and Ax.prd_id       = Bx.prod_id
  and Ax.category1 = Bx.category1
  and Ax.fscode      = Bx.fscode
  and Ax.prd_id  between  nvl(:p_prod1,chr(20))  and nvl(:p_prod2,chr(250))
  and Ax.fscode between  nvl(:p_fscode1,chr(20))  and nvl(:p_fscode2,chr(250))
Order  by  Ax.brand, ax.prd_id,ax.category1 , fscode
*/
