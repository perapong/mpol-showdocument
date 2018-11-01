DROP TABLE AR_DSM_PAYMENT_HDR PURGE;
CREATE TABLE AR_DSM_PAYMENT_HDR
    (ou_code                    CHAR(3 BYTE) NOT NULL,
    TRANS_NO                    VARCHAR2(10 BYTE) NOT NULL, --P140900001
    TRANS_DATE                  DATE NOT NULL,
    LOC_CODE                    VARCHAR2(5 BYTE) NOT NULL,
    TOT_REP                     NUMBER,
    TOT_AMOUNT                  NUMBER(18,2),
    TRANS_STATUS                VARCHAR2(2 BYTE),
    APPROVE_DATE                DATE,
    REJECT_DATE                 DATE,
    REF_TRANS_NO                VARCHAR2(10 BYTE),
    
    cre_by                      VARCHAR2(15 BYTE),
    cre_date                    DATE,
    prog_id                     VARCHAR2(15 BYTE),
    upd_by                      VARCHAR2(15 BYTE),
    upd_date                    DATE);
  CREATE UNIQUE INDEX "BWPROD"."AR_DSM_PAYMENT_HDR_PK" ON "BWPROD"."AR_DSM_PAYMENT_HDR" ("OU_CODE", "TRANS_NO");
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" ADD CONSTRAINT "AR_DSM_PAYMENT_HDR_PK" PRIMARY KEY ("OU_CODE", "TRANS_NO");


DROP TABLE AR_DSM_PAYMENT_DTL PURGE;
CREATE TABLE AR_DSM_PAYMENT_DTL
    (ou_code                    CHAR(3 BYTE) NOT NULL,
    TRANS_NO                    VARCHAR2(10 BYTE) NOT NULL, 
    REP_SEQ                     NUMBER NOT NULL,
    REP_CODE                    VARCHAR2(10 BYTE),
    REP_NAME                    VARCHAR2(100 BYTE),
    PAY_AMOUNT                  NUMBER(18,2),
    RECEIVE_NO                  VARCHAR2(20 BYTE),
    
    cre_by                      VARCHAR2(15 BYTE),
    cre_date                    DATE,
    prog_id                     VARCHAR2(15 BYTE),
    upd_by                      VARCHAR2(15 BYTE),
    upd_date                    DATE);
  CREATE UNIQUE INDEX "BWPROD"."AR_DSM_PAYMENT_DTL_PK" ON "BWPROD"."AR_DSM_PAYMENT_DTL" ("OU_CODE", "TRANS_NO", "REP_SEQ"); 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_DTL" ADD CONSTRAINT "AR_DSM_PAYMENT_DTL_PK" PRIMARY KEY ("OU_CODE", "TRANS_NO", "REP_SEQ");
    

drop table AR_DSMPAYMENT_INFO purge;
CREATE TABLE AR_DSM_PAYMENT_INFO
    (ou_code                    CHAR(3 BYTE) NOT NULL,
    TRANS_NO                    VARCHAR2(10 BYTE) NOT NULL, 
    PAY_SEQ                     NUMBER NOT NULL,
    PAY_TYPE                    VARCHAR2(1 BYTE),
    BW_BANK_CODE                VARCHAR2(10 BYTE),
    BW_BANK_BRANCH              VARCHAR2(10 BYTE),
    BW_BANK_ACCT                VARCHAR2(20 BYTE),
    PAY_REF_NO                  VARCHAR2(20 BYTE),
    PAY_DATE                    DATE,
    PAY_AMOUNT                  NUMBER(18,2),
    
    cre_by                      VARCHAR2(15 BYTE),
    cre_date                    DATE,
    prog_id                     VARCHAR2(15 BYTE),
    upd_by                      VARCHAR2(15 BYTE),
    upd_date                    DATE)

  CREATE UNIQUE INDEX "BWPROD"."AR_DSM_PAYMENT_INFO_PK" ON "BWPROD"."AR_DSM_PAYMENT_INFO" ("OU_CODE", "TRANS_NO", "PAY_SEQ") 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_INFO" ADD CONSTRAINT "AR_DSM_PAYMENT_INFO_PK" PRIMARY KEY ("OU_CODE", "TRANS_NO", "PAY_SEQ")


--------------------------------------------------------
--  DDL for Table AR_DSM_PAYMENT_HDR
--------------------------------------------------------

  CREATE TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" 
   (    "OU_CODE" CHAR(3 BYTE), 
    "TRANS_NO" VARCHAR2(10 BYTE), 
    "TRANS_DATE" DATE, 
    "LOC_CODE" VARCHAR2(100 BYTE), 
    "TRANS_STATUS" NUMBER, 
    "TOT_REP" NUMBER, 
    "TOT_AMOUNT" NUMBER(18,2), 
    "CRE_BY" VARCHAR2(15 BYTE), 
    "CRE_DATE" DATE, 
    "PROG_ID" VARCHAR2(15 BYTE), 
    "UPD_BY" VARCHAR2(15 BYTE), 
    "UPD_DATE" DATE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "BWPROD_TBS1" ;
--------------------------------------------------------
--  DDL for Index AR_DSM_PAYMENT_HDR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "BWPROD"."AR_DSM_PAYMENT_HDR_PK" ON "BWPROD"."AR_DSM_PAYMENT_HDR" ("OU_CODE", "TRANS_NO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "BWPROD_TBS1" ;
--------------------------------------------------------
--  Constraints for Table AR_DSM_PAYMENT_HDR
--------------------------------------------------------

  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" ADD CONSTRAINT "AR_DSM_PAYMENT_HDR_PK" PRIMARY KEY ("OU_CODE", "TRANS_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "BWPROD_TBS1"  ENABLE;
 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" MODIFY ("OU_CODE" NOT NULL ENABLE);
 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" MODIFY ("TRANS_NO" NOT NULL ENABLE);
 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" MODIFY ("TRANS_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "BWPROD"."AR_DSM_PAYMENT_HDR" MODIFY ("LOC_CODE" NOT NULL ENABLE);



CREATE TABLE ar_dsm_payment_info
    (ou_code                        CHAR(3 BYTE) NOT NULL,
    trans_no                       VARCHAR2(10 BYTE) NOT NULL,
    pay_seq                        NUMBER NOT NULL,
    pay_type                       VARCHAR2(10 BYTE),
    bw_bank_code                   VARCHAR2(10 BYTE),
    bw_bank_branch                 VARCHAR2(10 BYTE),
    bw_bank_acct                   VARCHAR2(20 BYTE),
    pay_ref_no                     VARCHAR2(20 BYTE),
    pay_date                       DATE,
    pay_bank_code                  VARCHAR2(10 BYTE),
    pay_bank_branch                VARCHAR2(5 BYTE),
    pay_amount                     NUMBER(18,2),
    cre_by                         VARCHAR2(15 BYTE),
    cre_date                       DATE,
    prog_id                        VARCHAR2(15 BYTE),
    upd_by                         VARCHAR2(15 BYTE),
    upd_date                       DATE)
ALTER TABLE ar_dsm_payment_info
ADD CONSTRAINT ar_dsm_payment_info_pk PRIMARY KEY (ou_code, trans_no, pay_seq)


