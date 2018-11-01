CREATE TABLE `billcode2` (
  `CAMP` decimal(6,0) NOT NULL,
  `BILLCODE` varchar(5) NOT NULL default '',
  `BILLDESC` varchar(250) NOT NULL default '',
  `BILLTYPE` varchar(5) NOT NULL default '',
  `GCONLY` varchar(1) NOT NULL default '',
  `EFFDTE` decimal(8,0) NOT NULL default '0',
  `EXPDTE` decimal(8,0) NOT NULL default '0',
  `BILLGRP` varchar(5) NOT NULL default '',
  `DUMYCODE` varchar(10) NOT NULL default '',
  `PRICE` decimal(8,2) default '0.00',
  `SPCFLG` varchar(1) NOT NULL default '',
  `DISCFLG` varchar(1) NOT NULL default '',
  `INCTFLG` varchar(1) NOT NULL default '',
  `FREEFLG` varchar(1) NOT NULL default '',
  `SUBFLG` varchar(1) NOT NULL default '',
  `BACKFLG` varchar(1) NOT NULL default '',
  `UPDFLG` varchar(1) NOT NULL default '',
  `PINVFLG` varchar(1) NOT NULL default '',
  `FREEBASE` varchar(1) NOT NULL default '',
  `SPCBASE` varchar(1) NOT NULL default '',
  `SPCDSCBASE` int(4) default '0',
  `SHORTLMT` decimal(6,0) NOT NULL default '0',
  `SHORTEFF` decimal(8,0) NOT NULL default '0',
  `SHORTEXP` decimal(8,0) NOT NULL default '0',
  `MAXSLSUNIT` decimal(6,0) NOT NULL default '0',
  `BRAND` varchar(10) default NULL,
  `MEDIA_GROUP` varchar(50) default NULL,
  `PAGENO` int(5) default '0',
  `VMFLAG` varchar(1) NOT NULL default '0',
  PRIMARY KEY  (`CAMP`,`BILLCODE`),
  KEY `idx_CAMP` (`CAMP`,`BILLCODE`),
  KEY `idx_BILLCODE` (`BILLCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE `billcode_mispro2` (
  `ROW_ID` bigint(20) NOT NULL auto_increment,
  `CAMP` decimal(6,0) NOT NULL,
  `BILLCODE` char(5) NOT NULL,
  `BILLTYPE` char(1) NOT NULL,
  `GCONLY` char(1) NOT NULL,
  `EFFDTE` decimal(8,0) default NULL,
  `EXPDTE` decimal(8,0) default NULL,
  `BILLDESC` varchar(250) NOT NULL default '',
  `BILLGRP` char(5) default NULL,
  `DUMYCODE` char(5) default NULL,
  `PRICE` decimal(8,2) NOT NULL,
  `SPCFLG` char(1) default NULL,
  `DISCFLG` char(1) default NULL,
  `INCTFLG` char(1) default NULL,
  `FREEFLG` char(1) default NULL,
  `SUBFLG` char(1) default NULL,
  `BACKFLG` char(1) default NULL,
  `UPDFLG` char(1) default NULL,
  `PINVFLG` char(1) default NULL,
  `FREEBASE` char(1) default NULL,
  `SPCBASE` char(1) default NULL,
  `SPCDSCBASE` int(4) NOT NULL default '0',
  `SHORTLMT` decimal(6,0) default NULL,
  `SHORTEFF` decimal(8,0) default NULL,
  `SHORTEXP` decimal(8,0) default NULL,
  `MAXSLSUNIT` decimal(6,0) default NULL,
  PRIMARY KEY  (`ROW_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=1636 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE `billcode_msg2` (
  `CAMP` int(6) NOT NULL default '0',
  `BILLCODE` varchar(5) NOT NULL default '',
  `BILLDESC` varchar(125) default NULL,
  `MSGTYP` varchar(10) default NULL,
  `MSG_DESC` varchar(255) default NULL,
  PRIMARY KEY  (`CAMP`,`BILLCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `billcode_short2` (
  `CAMP` int(6) NOT NULL default '0',
  `BILLCODE` varchar(5) NOT NULL default '',
  `BILLDESC` varchar(200) default '',
  `SHTCODE` varchar(2) default '',
  `SHORTLMT` int(11) default '0',
  `SHORTEFF` int(8) default '0',
  `SHORTEXP` int(11) default '0',
  `SUBCODE` varchar(5) default '',
  `SUBDESC` varchar(200) default '',
  `SUBUNIT` int(11) default '0',
  `LASTUPDATE` datetime default NULL,
  `SHORT_MSG` text,
  PRIMARY KEY  (`CAMP`,`BILLCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `billcodehbd2` (
  `CAMP` decimal(6,0) NOT NULL,
  `BILLCODE` varchar(5) NOT NULL default '',
  `BILLDESC` varchar(250) NOT NULL default '',
  `BILLTYPE` varchar(5) default '',
  `GCONLY` varchar(1) default '',
  `EFFDTE` decimal(8,0) default NULL,
  `EXPDTE` decimal(8,0) default NULL,
  `BILLGRP` varchar(5) default '',
  `DUMYCODE` varchar(10) default '',
  `PRICE` decimal(8,2) default NULL,
  `SPCFLG` varchar(1) default '',
  `DISCFLG` varchar(1) default '',
  `INCTFLG` varchar(1) default '',
  `FREEFLG` varchar(1) default '',
  `SUBFLG` varchar(1) default '',
  `BACKFLG` varchar(1) default '',
  `UPDFLG` varchar(1) default '',
  `PINVFLG` varchar(1) default '',
  `FREEBASE` varchar(1) default '',
  `SPCBASE` varchar(1) default '',
  `SPCDSCBASE` int(4) default '0',
  `SHORTLMT` decimal(6,0) default NULL,
  `SHORTEFF` decimal(8,0) default NULL,
  `SHORTEXP` decimal(8,0) default NULL,
  `MAXSLSUNIT` decimal(6,0) default NULL,
  `BRAND` varchar(10) default NULL,
  `MEDIA_GROUP` varchar(50) default NULL,
  `PAGENO` int(5) default NULL,
  PRIMARY KEY  (`CAMP`,`BILLCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE `catalogue2` (
  `ID` int(11) NOT NULL auto_increment,
  `BRAND` varchar(50) NOT NULL default '',
  `MEDIA` varchar(100) default NULL,
  `CAMP` int(11) NOT NULL default '0',
  `TYPE` varchar(200) NOT NULL default '',
  `TITLE` varchar(255) default NULL,
  `URL` varchar(255) default NULL,
  `STATUS` varchar(12) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `INDEX_CATE` (`BRAND`,`TYPE`,`CAMP`)
) ENGINE=MyISAM AUTO_INCREMENT=844 DEFAULT CHARSET=utf8;

CREATE TABLE `catalogue_data2` (
  `ID` int(11) default NULL,
  `BRAND` varchar(5) default NULL,
  `MEDIA` varchar(2) default NULL,
  `CAMP` double(6,0) default NULL,
  `YEAR` double(4,0) default NULL,
  `SEQNO` int(4) default NULL,
  `SPAGE_FROM` varchar(10) default NULL,
  `SPAGE_TO` varchar(10) default NULL,
  `CPAGE_FROM` varchar(10) default NULL,
  `CPAGE_TO` varchar(10) default NULL,
  `BILLCODE` varchar(6) default NULL,
  `BILL_DESC` varchar(255) default NULL,
  `PRICE` double(6,0) default NULL,
  `COND` varchar(500) default NULL,
  `REMARK` varchar(500) default NULL,
  KEY `ID_IDX` (`ID`,`BRAND`,`MEDIA`,`CAMP`,`YEAR`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `msl_register2` (
  `REF_SEQ` int(11) NOT NULL auto_increment,
  `TRANDATE` int(11) default NULL,
  `TRANTIME` varchar(25) default NULL,
  `NAME` varchar(125) default NULL,
  `ADDRESS` varchar(200) default NULL,
  `TUMBOL` varchar(100) default NULL,
  `AMPHUR` varchar(100) default NULL,
  `PROVINCE` varchar(100) default NULL,
  `POSTCODE` varchar(5) default NULL,
  `EMAIL` varchar(75) default NULL,
  `PHONE` varchar(50) default NULL,
  `FAX` varchar(25) default NULL,
  `CONTACT_PLACE` varchar(200) default NULL,
  `CONTACT_TIME` varchar(200) default NULL,
  `DWNFLAG` varchar(1) default NULL,
  `DWN_DATE` varchar(25) default NULL,
  `FLAG1` varchar(25) default NULL,
  `FLAG2` varchar(25) default NULL,
  `WEBSITE_ID` int(4) default '0',
  `EXPORT_EMAIL` varchar(255) default 'N',
  PRIMARY KEY  (`REF_SEQ`),
  KEY `REF_SEQ` (`REF_SEQ`)
) ENGINE=MyISAM AUTO_INCREMENT=221317 DEFAULT CHARSET=utf8;

CREATE TABLE `mslmst2` (
  `DIST` varchar(5) NOT NULL,
  `MSLNO` int(5) NOT NULL,
  `CHKDGT` int(1) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `PWD` varchar(15) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PHONE` varchar(25) NOT NULL,
  `BIRTHDATE` int(8) NOT NULL,
  `STATUS` varchar(15) NOT NULL,
  `ARBALANCE` double(6,2) default '0.00',
  `BPRBALANCE` double(6,2) NOT NULL default '0.00',
  `REG_DATE` int(8) NOT NULL,
  `REG_TIME` varchar(15) NOT NULL,
  `QUESTION` varchar(255) NOT NULL,
  `ANSWER` varchar(100) NOT NULL,
  `WEBSITE_ID` int(4) NOT NULL default '0',
  `LAST_UPDATE` int(8) default NULL,
  `LAST_LOGIN` datetime default NULL,
  `FLAG1` varchar(25) default NULL,
  `EXPORT_EMAIL` varchar(1) default 'N',
  `FLAG` varchar(2) default NULL,
  `STATUSTEMP` varchar(15) default NULL,
  `BIRTHDATETEMP` int(8) default NULL,
  `SHOWPOP` int(1) default NULL,
  `SendMail` int(1) default NULL,
  PRIMARY KEY  (`DIST`,`MSLNO`,`CHKDGT`),
  KEY `MSL` (`DIST`,`MSLNO`,`CHKDGT`,`NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `order_header2` (
  `ORDER_NO` int(11) NOT NULL default '0',
  `ORDCAMP` int(11) NOT NULL default '0',
  `ORDDATE` int(11) NOT NULL default '0',
  `ORDTIME` varchar(8) NOT NULL default ' ',
  `CURCAMP` int(11) NOT NULL default '0',
  `DIST` varchar(5) NOT NULL default ' ',
  `MSLNO` int(5) NOT NULL default '0',
  `CHKDGT` int(1) NOT NULL default '0',
  `NAME` varchar(200) default NULL,
  `ITEMS` int(4) default NULL,
  `TOTAL_AMOUNT` double(8,2) default '0.00',
  `AMOUNT_1` int(8) default '0',
  `AMOUNT_2` int(8) default '0',
  `AMOUNT_3` int(11) default '0',
  `DISCOUNT_1` int(4) default '0',
  `DISCOUNT_2` int(4) default '0',
  `DISCOUNT_3` int(4) default '0',
  `BILLDATE` int(11) default NULL,
  `SHIPDATE` int(11) default NULL,
  `DLVDATE` int(11) default NULL,
  `DWNDATE` int(11) default NULL,
  `DWNFLAG` varchar(1) default NULL,
  `EXPFLAG` varchar(1) default NULL,
  `MAIL_CONFIRM` varchar(1) default NULL,
  `UPDDATE` int(11) default NULL,
  `UPDTIME` varchar(11) default NULL,
  `DP_DOWNLOAD` varchar(25) default NULL,
  `WEBSITE_ID` int(4) default NULL,
  `DELFLAG` varchar(1) default 'N',
  `BROWSER` varchar(50) default NULL,
  `GOLDCLUB` varchar(5) default NULL,
  PRIMARY KEY  (`ORDER_NO`,`ORDCAMP`,`ORDDATE`,`ORDTIME`,`DIST`,`MSLNO`,`CHKDGT`),
  KEY `First` (`ORDER_NO`,`ORDDATE`,`ORDCAMP`,`DIST`,`MSLNO`,`CHKDGT`),
  KEY `idx_OrderHDR` (`ORDER_NO`,`ORDCAMP`,`DIST`,`MSLNO`,`CHKDGT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `order_detail2` (
  `ORDER_NO` int(11) NOT NULL default '0',
  `ORDCAMP` int(6) NOT NULL default '0',
  `ORDDATE` int(8) NOT NULL default '0',
  `ORDTIME` varchar(8) NOT NULL default ' ',
  `CURCAMP` int(6) NOT NULL default '0',
  `DIST` varchar(5) NOT NULL default ' ',
  `MSLNO` int(5) NOT NULL default '0',
  `CHKDGT` int(1) NOT NULL default '0',
  `LISTNO` int(4) NOT NULL default '0',
  `BILLCODE` varchar(6) NOT NULL default ' ',
  `BILLDESC` varchar(120) NOT NULL default ' ',
  `QTY` int(1) NOT NULL default '0',
  `PRICE` decimal(8,2) NOT NULL default '0.00',
  `AMOUNT` decimal(8,2) NOT NULL default '0.00',
  `REMARK` varchar(200) NOT NULL default ' ',
  `BRAND` varchar(1) default ' ',
  `DISCOUNT` int(4) default '0',
  `SPCFLG` varchar(1) default 'N',
  `DISCFLG` varchar(1) default 'N',
  `INCTFLG` varchar(1) default 'N',
  `FREEFLG` varchar(1) default 'N',
  `BILLFLAG` varchar(1) NOT NULL default '0',
  `DWNFLAG` varchar(1) NOT NULL default 'N',
  `EXPFLAG` varchar(1) NOT NULL default 'N',
  `FLAG1` varchar(50) NOT NULL default ' ',
  `DELFLAG` varchar(1) NOT NULL default 'N',
  `ORDERQTY` int(1) default '0',
  `VMFLAG` varchar(1) default '2',
  PRIMARY KEY  (`ORDER_NO`,`ORDCAMP`,`ORDDATE`,`ORDTIME`,`DIST`,`MSLNO`,`CHKDGT`,`LISTNO`),
  KEY `ORDER_NO` (`ORDER_NO`,`ORDCAMP`,`ORDDATE`,`DIST`,`MSLNO`,`CHKDGT`,`BILLCODE`,`LISTNO`),
  KEY `idx_CAMP_REP` (`ORDER_NO`,`ORDCAMP`,`DIST`,`MSLNO`,`CHKDGT`),
  KEY `idx_SUM_REPORT` (`DELFLAG`,`ORDDATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `promotionheader2` (
  `ROW_ID` int(11) NOT NULL auto_increment,
  `CAMP` decimal(6,0) default '0',
  `STATUS` varchar(50) default NULL,
  `JPGFILE` varchar(255) default NULL,
  `Ext_File` varchar(10) default NULL,
  PRIMARY KEY  (`ROW_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;

CREATE TABLE `tbl0082` (
  `CAMP` int(6) NOT NULL,
  `YEAR` int(4) NOT NULL,
  `EFFDTE` int(8) NOT NULL,
  `EXPDTE` int(8) NOT NULL,
  `STATUS` varchar(15) NOT NULL,
  PRIMARY KEY  (`CAMP`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `tbl0152` (
  `CAMP` int(6) NOT NULL,
  `DIST` varchar(5) NOT NULL,
  `EFFDTE` int(8) NOT NULL,
  `EXPDTE` int(8) NOT NULL,
  `MAILGROUP` varchar(2) NOT NULL default '',
  `MAILDATE` int(8) default '0',
  `BILLDATE` int(8) NOT NULL,
  `SHIPDATE` int(8) NOT NULL,
  `DLVDATE` int(8) NOT NULL,
  PRIMARY KEY  (`CAMP`,`DIST`),
  KEY `idx` (`DIST`,`SHIPDATE`),
  KEY `idxa` (`CAMP`,`DIST`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

