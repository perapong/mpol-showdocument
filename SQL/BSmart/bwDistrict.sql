SELECT   dst.dstou_code,
            DECODE (loc.padnum1, '0', 'DIRECT', '1', 'HIGH', 'NONE')
               loc_group,
            dst.dstloc_code,
            loc.padflag2 creditsales,
            loc.padnum1 distgroup,
            dst.dstdefault_shipwh,
            reg.padnum1 regtype --- 0 direct selling, 1 inter billing, 2 wholesales
     FROM   su_param_dtl loc, db_sales_location dst, su_param_dtl reg
    WHERE       dst.dstou_code = '000'
            --### Bypass: dstloc_type S, dstspecial_status 0
            AND dst.dstloc_type = 'S'
            AND NVL (dst.dstspecial_status, '0') = '0'
            --### Bypass: padflag1
            AND loc.padparam_id(+) = 25
            AND loc.padflag1(+) = 1
            AND loc.padentry_code(+) = dst.dstdistrict_type
            --### join to param
            AND reg.padparam_id(+) = 302
            AND reg.padentry_code(+) = NVL (dst.dstregion_code, '$')

