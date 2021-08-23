/******************************************************************************
			POSTOK
			version : 1.2.7

			Last Update Date : 2020-07-01
*******************************************************************************/

/******************************************************************************
**		Name: TABLE TBL_EPOSTMEMBER_CO
**		Desc: 모바일 우편함 연동회원
**
**		Date: 2021-02-09
*******************************************************************************/
CREATE TABLE `TBL_EPOSTMEMBER_CO`
(
   p_code_idx          BIGINT(20) NULL DEFAULT NULL,
   p_code              VARCHAR(67)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   type                CHAR(1)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   entry_dt            DATETIME(0) NULL DEFAULT NULL,
   withdr_dt           DATETIME(0) NULL DEFAULT NULL,
   modify_dt           DATETIME(0) NULL DEFAULT NULL,
   use_yn              VARCHAR(1)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   hp                  VARCHAR(11)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   name                VARCHAR(50)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   ci                  VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   password            VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   pincode             VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   pub_key             VARCHAR(4096)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   uuid                VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   birth               VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   email               VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   login_fail_count    INT(11) NOT NULL,
   last_login_dt       DATETIME(0) NULL DEFAULT NULL,
   gender              VARCHAR(2)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '2: female, 1: male',
   marketing_ok        DATETIME(0)
                         NULL
                         DEFAULT NULL
                         COMMENT '마케팅 수신 동의 (null : 미동의, time : 동의)',
   COSERVICE           VARCHAR(5)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT 'POST(인터넷우체국)/KOTI(한국교통연구원)/?',
   ID                  VARCHAR(30)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT 'CO SERVICE 회원 ID : EPOST회원ID',
   MI                  VARCHAR(67)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT 'EPOST회원ID',
   FRGNRYN             VARCHAR(2)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '(Y:외국인, N:내국인)',
   PRIMARY KEY(p_code),
   UNIQUE KEY `TBL_EPOSTMEMBER_CO_ci_uindex`(ci)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

/******************************************************************************
**		Name: TABLE TBL_MEMBERADDRESS_CO
**		Desc: 공동 회원 주소
**
**		Date: 2021-02-09
*******************************************************************************/
CREATE TABLE `TBL_MEMBERADDRESS_CO`
(
   idx            BIGINT(20) NOT NULL AUTO_INCREMENT,
   p_code_idx     BIGINT(20) NULL DEFAULT NULL,
   p_code         TINYTEXT
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   type           CHAR(3)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   recv_yn        CHAR(3)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   zipcode        TINYTEXT
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   addr1          VARCHAR(384)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   addr2          VARCHAR(384)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   description    VARCHAR(300)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


/******************************************************************************
**		Name: TABLE TBL_PCODE_CO
**		Desc: 공동 회원 주소
**
**		Date: 2021-02-09
*******************************************************************************/
CREATE TABLE `TBL_PCODE_CO`
(
   idx                  BIGINT(20) NOT NULL AUTO_INCREMENT,
   reg_dt               DATETIME(0) NULL DEFAULT NULL COMMENT '생성일',
   p_code               VARCHAR(67) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   ci                   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   mi                   VARCHAR(128)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL,
   member_yn            VARCHAR(1)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL,
   disp_class           VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT '1'
                          COMMENT '우편 수령 방법 선택(1: APP, 4: DM, 0: 차단)',
   push_token           VARCHAR(4096)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL,
   push_permit_class    INT(11)
                          NULL
                          DEFAULT 15
                          COMMENT '푸쉬 수신 허용 종류  (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트) - 전체 거부:0, 전체 허용: 15,  기본  허용: 2 ',
   birth               VARCHAR(128)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL,
   UNIQUE KEY `TBL_PCODE_CO_p_code_uindex`(p_code),
   UNIQUE KEY `TBL_PCODE_CO_ci_uindex`(ci),
   PRIMARY KEY(idx, p_code)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

/******************************************************************************
**		Name: p_code(37) -> (67)
**		Desc: p_code 사이즈 변경
**
**		Date: 2021-02-09
*******************************************************************************/

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%p_code%';

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'p_code';

/*
+--------------+------------------------------+-------------+
| TABLE_SCHEMA | TABLE_NAME                   | COLUMN_NAME |
+--------------+------------------------------+-------------+
| EMAILBOX     | TBL_MEMBERCAR                | p_code      |
| EMAILBOX     | TBL_DOCUMENTS                | p_code      |
| EMAILBOX     | TBL_PAYMENT                  | p_code      |
| EMAILBOX     | TBL_DOCUMENTS_SUPPLEMENT     | p_code      |
| EMAILBOX     | TBL_EPOSTMEMBER              | p_code      |
| EMAILBOX     | TBL_PCODE                    | p_code      |
| EMAILBOX     | TBL_MYAGENCY                 | p_code      |
| EMAILBOX     | TBL_MEMBERADDRESS_RENEWAL    | p_code      |
| EMAILBOX     | TBL_DOCUMENTS_NOSQL_POSTITEM | p_code      |
| EMAILBOX     | TBL_MEMBERADDRESS            | p_code      |
+--------------+------------------------------+-------------+
*/

ALTER TABLE TBL_PAYMENT MODIFY p_code varchar(67);
ALTER TABLE TBL_EPOSTMEMBER MODIFY p_code varchar(67);
ALTER TABLE TBL_PCODE MODIFY p_code varchar(67);
ALTER TABLE TBL_MYAGENCY MODIFY p_code varchar(67);
ALTER TABLE TBL_PCODE MODIFY p_code varchar(67);

ALTER TABLE TBL_PCODE ADD COLUMN birth VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;


































