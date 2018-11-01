    SELECT  /*+index(bih, idx11_om_order_hdr) index(pnt, pkom_chkpoint_main)*/ 
             dstloc_code STIDISTRICT_CODE , dstloc_name STIDISTRICT_NAME , 
                        SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NULL AND pnt.pntinvoice_date IS NULL 
                                            AND bihorder_status in ('00','01','11')  
                      THEN 1 ELSE 0 END) STIKEY_IN ,
            SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NOT NULL AND pnt.pntinvoice_date IS NULL 
                                AND bihorder_status in ('04','77')
                      THEN 1 ELSE 0 END) STIHOLD ,
                      
            SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NOT NULL AND pnt.pntinvoice_date IS NOT NULL 
                                AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0   
                      THEN 1 ELSE 0 END)+ 
            SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NULL AND pnt.pntinvoice_date IS NOT NULL
                                AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 
                      THEN 1 ELSE 0 END) STIINVOICED,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIWAIT ,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIPICKED ,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STICHECKED,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STISHIPPED ,
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIDELIVER ,
                      
            --Perapong 02/10/2013 : ALL DC Print at BL [( stf_blinvoice_prn (bih.bihou_code, bih.bihref_trans_year , bih.bihref_trans_group , bih.bihref_trans_no)) prn_Place]
            'BL' prn_Place         
                      
    FROM    om_chkpoint_main pnt, om_order_hdr bih, db_sales_location 
    WHERE   bih.bihou_code                          = '000'
    --and pnttrans_no = '1106495047'
    --AND   bih.bihsales_campaign       = :parameter.p_mpscampaign
    --Perapong 02/10/2013 : Change Shipdate condition [AND          bih.bihship_date                        = :criteria.ctrship_date]
    AND     case when nvl(bihref_trans_date,bihorder_date) > bihship_date then pkgbw_misc.getxDistrictShipDate (bihou_code, pkgdb_desc.getnext_campaign(bihou_code,bihsales_campaign,1), bihloc_code) else bihship_date end 
            = to_date('29/11/2013','dd/mm/rrrr')
    AND     dstloc_type                     = 'S' 
    AND     (dstinactive_status = '0' or dstinactive_status is null)
    AND     pnt.pntou_code                  = bih.bihou_code         
    AND     pnt.pntsales_campaign           = bih.bihsales_campaign
    AND     pnt.pntrep_seq                          = bih.bihrep_seq          
    AND     pnt.pntsales_seq                        = bih.bihbill_seq
    AND         dstou_code                                  = bih.bihou_code
    AND     dstloc_code                                 = bih.bihloc_code
    AND         (bih.bihorder_status not in ('98','99') AND nvl(dstspecial_status,'0') <> '1')
    AND         exists (select  *
                                        from        db_mailplan_sales
                                        where       mpsou_code      = '000'
                                        and         mpsyear         = 2013
                                        and         mpscampaign     = '242013'
                                        and         mpsmailgroup    = '07'
                                        and         mpsloc_code     = bih.bihloc_code)
    group by dstloc_code, dstloc_name, ( stf_blinvoice_prn (bih.bihou_code, bih.bihref_trans_year , bih.bihref_trans_group , bih.bihref_trans_no))  ;

--select * from om_chkpoint_main pnt
--------------------------------------------------------------------------------------------

    SELECT  /*+index(bih, idx11_om_order_hdr) index(pnt, pkom_chkpoint_main)*/ 
             dstloc_code STIDISTRICT_CODE , dstloc_name STIDISTRICT_NAME , pnt.*
             
             ,(CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NULL AND pnt.pntinvoice_date IS NULL 
                                            AND bihorder_status in ('00','01','11')  
                      THEN 1 ELSE 0 END) STIKEY_IN 
           /* SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NOT NULL AND pnt.pntinvoice_date IS NULL 
                                AND bihorder_status in ('04','77')
                      THEN 1 ELSE 0 END) STIHOLD ,
                      
            SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NOT NULL AND pnt.pntinvoice_date IS NOT NULL 
                                AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0   
                      THEN 1 ELSE 0 END)+ 
            SUM (CASE WHEN pnt.pntorder_keyin_date IS NOT NULL AND pnt.pntorder_hold_date IS NULL AND pnt.pntinvoice_date IS NOT NULL
                                AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 
                      THEN 1 ELSE 0 END) STIINVOICED,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND pnt.pnttrans_group = '11' AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIWAIT ,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIPICKED ,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STICHECKED,
                      
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STISHIPPED ,
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NOT NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NOT NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END)+
            SUM (CASE WHEN pnt.pntinvoice_date IS NOT NULL AND pnt.pntpicked_date IS NULL AND pnt.pntchecked_date IS NOT NULL 
                      AND pnt.pntfirstshipped_date IS NULL AND pnt.pntdelivery_date IS NOT NULL AND NVL(PNT.PNTPICK_TTLUNIT,0) > 0 THEN 1 ELSE 0 END) STIDELIVER ,
                      
            --Perapong 02/10/2013 : ALL DC Print at BL [( stf_blinvoice_prn (bih.bihou_code, bih.bihref_trans_year , bih.bihref_trans_group , bih.bihref_trans_no)) prn_Place]
            'BL' prn_Place         
            */          
    FROM    om_chkpoint_main pnt, om_order_hdr bih, db_sales_location 
    WHERE   bih.bihou_code                          = '000'
      and pntrep_code like '0275%'
    --and pnttrans_no = '1106495047'
    --AND   bih.bihsales_campaign       = :parameter.p_mpscampaign
    --Perapong 02/10/2013 : Change Shipdate condition [AND          bih.bihship_date                        = :criteria.ctrship_date]
    AND     case when nvl(bihref_trans_date,bihorder_date) > bihship_date then pkgbw_misc.getxDistrictShipDate (bihou_code, pkgdb_desc.getnext_campaign(bihou_code,bihsales_campaign,1), bihloc_code) else bihship_date end 
            = to_date('29/11/2013','dd/mm/rrrr')
    AND     dstloc_type                     = 'S' 
    AND     (dstinactive_status = '0' or dstinactive_status is null)
    AND     pnt.pntou_code                  = bih.bihou_code         
    AND     pnt.pntsales_campaign           = bih.bihsales_campaign
    AND     pnt.pntrep_seq                          = bih.bihrep_seq          
    AND     pnt.pntsales_seq                        = bih.bihbill_seq
    AND         dstou_code                                  = bih.bihou_code
    AND     dstloc_code                                 = bih.bihloc_code
    AND         (bih.bihorder_status not in ('98','99') AND nvl(dstspecial_status,'0') <> '1')
    AND         exists (select  *
                                        from        db_mailplan_sales
                                        where       mpsou_code      = '000'
                                        and         mpsyear         = 2013
                                        and         mpscampaign     = '242013'
                                        and         mpsmailgroup    = '07'
                                        and         mpsloc_code     = bih.bihloc_code)





