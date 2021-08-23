/******************************************************************************
**		Name: TABLE TBL_EPOSTMEMBER_SERVICE
**		Desc: 포스톡 회원 연동 서비스 
**
**		Author: KYEHYUK AHN
**		Date: 2021-03-10
*******************************************************************************/
CREATE TABLE TBL_EPOSTMEMBER_SERVICE
(
   p_code_idx          BIGINT(20) NULL DEFAULT NULL,
   p_code              VARCHAR(37)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL,
   service             VARCHAR(20)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT 'EASYADDRESS/POST/...',
   subscr_dt           DATETIME(0) NULL DEFAULT NULL,
   withdr_dt           DATETIME(0) NULL DEFAULT NULL,
   avail_yn              VARCHAR(1)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NULL
                         DEFAULT NULL
                         COMMENT 'Y : available, N: not available',
   PRIMARY KEY(p_code, service)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


/******************************************************************************
**		Name: TABLE TBL_MEMBERADDRESS_RENEWAL
**		Desc: 최신 회원 주소 연동 
**
**		Author: KYEHYUK AHN
**		Date: 2020-11-23
*******************************************************************************/
CREATE TABLE TBL_MEMBERADDRESS_RENEWAL
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
   subscr_dt      DATETIME(0) NULL DEFAULT NULL,
   withdr_dt      DATETIME(0) NULL DEFAULT NULL,
   seq            BIGINT(10) NULL DEFAULT NULL,
   status         CHAR(4)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT 'IDLE'
                    COMMENT 'IDLE/PUSH/OKAY/DENY',
   push_idx       BIGINT(20) NULL DEFAULT NULL,
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE utf8_general_ci
ROW_FORMAT DEFAULT;


ALTER TABLE TBL_MEMBERADDRESS_RENEWAL AUTO_INCREMENT = 5000000000000000;
/* 없어도 될듯 */