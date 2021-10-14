/******************************************************************************
			POSTOK 
			version : 1.3.0
			
			Auth : KYEHYUK AHN
			Last Update Date : 2021-10-06
*******************************************************************************/
USE EMAILBOX;

/******************************************************************************
**		Name: TABLE TBL_DOCUMENTS
**		Desc: 발송 상태/우편 목록
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
CREATE TABLE `TBL_DOCUMENTS`
(
   idx                  BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   nosql_index          VARCHAR(64)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL,
   doc_id               VARCHAR(64)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '문서번호 ',
   reg_dt               DATETIME(0) NOT NULL COMMENT '접수 시간 ',
   p_code               VARCHAR(128)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT 'P Code',
   p_code_idx           BIGINT(20) NULL DEFAULT NULL,
   agency_id            BIGINT(20) NULL DEFAULT NULL COMMENT '기관일련번호 ',
   disp_class           VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '발송종류(APP:1, DM:2)',
   disp_status          VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '발송상태(0: 대기, 1: 발송 ....',
   disp_dt              DATETIME(0) NULL DEFAULT NULL COMMENT '발송시간 ',
   read_dt              DATETIME(0) NULL DEFAULT NULL COMMENT '열람시',
   recv_dt              DATETIME(0) NULL DEFAULT NULL,
   doc_title            VARCHAR(128)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '문서 제목 ',
   doc_content          VARCHAR(1024)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '문서 내용 ',
   doc_path             VARCHAR(260)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT 'pdf 파일 경로 ',
   doc_size             BIGINT(20) NULL DEFAULT NULL COMMENT 'pdf 파일 크기 ',
   doc_version          VARCHAR(20)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '문서 버전 ',
   `doc_download_YN`    VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT 'pdf 파일 다운로드 여부 ',
   group_by             VARCHAR(32)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '그룹으로 검색을 하기 위한 기관에서 관리하는 keyword ',
   request_id           VARCHAR(64)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '기관에서 관리 하는 발송요청 id',
   `deleted_YN`         VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '삭제 여부(N: 삭제 안됨,  Y: 삭제 됨)',
   deleted_dt           DATETIME(0)
                          NULL
                          DEFAULT NULL
                          COMMENT '삭제된 날짜 시간 ',
   template_code        VARCHAR(10)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL,
   dn_yn                VARCHAR(2)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT 'Y'
                          COMMENT '다운로드 가능 여부 확',
   UNIQUE KEY nosql_index(reg_dt, nosql_index, doc_id),
   PRIMARY KEY(idx, reg_dt)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE(year(`reg_dt`))(PARTITION p2019 VALUES LESS THAN (2020),
 PARTITION p2020 VALUES LESS THAN (2021),
 PARTITION p2021 VALUES LESS THAN (2022),
 PARTITION p2022 VALUES LESS THAN (2023),
 PARTITION p2023 VALUES LESS THAN (2024),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_EPOSTMEMBER
**		Desc: 포스톡 회원
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
CREATE TABLE `TBL_EPOSTMEMBER`
(
   p_code_idx          BIGINT(20) NULL DEFAULT NULL,
   p_code              VARCHAR(128)
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
   PRIMARY KEY(p_code),
   UNIQUE KEY `TBL_EPOSTMEMBER_ci_uindex`(ci),
   UNIQUE KEY `TBL_EPOSTMEMBER_hp_uindex`(hp)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

/******************************************************************************
**		Name: TABLE TBL_MYAGENCY
**		Desc: 회원이 등록한 내 기관
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
CREATE TABLE `TBL_MYAGENCY`
(
   idx           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   p_code_idx    BIGINT(20) NULL DEFAULT NULL,
   p_code        VARCHAR(128)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT NULL,
   agency_id     BIGINT(20) NULL DEFAULT NULL,
   `use_YN`      VARCHAR(2)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT 'Y',
   disp_class    VARCHAR(3)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT NULL
                   COMMENT '수령 종류(0: 차단, 1: Online, 4: DM)',
   myaddr_idx    BIGINT(20) NULL DEFAULT NULL,
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

/******************************************************************************
**		Name: TABLE TBL_PAYMENT
**		Desc: 고지서 결제 목록
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
CREATE TABLE `TBL_PAYMENT`
(
   idx               BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   doc_idx           BIGINT(20) NULL DEFAULT NULL,
   nosql_index       VARCHAR(64)
                       CHARACTER SET utf8
                       COLLATE utf8_general_ci
                       NULL
                       DEFAULT NULL,
   doc_id            VARCHAR(64)
                       CHARACTER SET utf8
                       COLLATE utf8_general_ci
                       NULL
                       DEFAULT NULL,
   reg_dt            DATETIME(0) NOT NULL COMMENT '접수 시간 ',
   p_code_idx        BIGINT(20) NULL DEFAULT NULL,
   p_code            VARCHAR(128)
                       CHARACTER SET utf8
                       COLLATE utf8_general_ci
                       NULL
                       DEFAULT NULL,
   agency_id         BIGINT(20) NULL DEFAULT NULL,
   pay_amount        BIGINT(20) NULL DEFAULT NULL COMMENT '결제 금액 ',
   pay_pub_dt        DATE NULL DEFAULT NULL COMMENT '고지서 발행날짜 ',
   pay_duedate_dt    DATE NULL DEFAULT NULL COMMENT '납부 기한 ',
   pay_dt            DATETIME(0)
                       NULL
                       DEFAULT NULL
                       COMMENT '납부한 날짜 ',
   pay_kind          VARCHAR(20)
                       CHARACTER SET utf8
                       COLLATE utf8_general_ci
                       NULL
                       DEFAULT NULL
                       COMMENT '결제 구분: 일반결제(N), 간편카드(C), 간편계좌이체(A)',
   pay_inst          VARCHAR(64)
                       CHARACTER SET utf8
                       COLLATE utf8_general_ci
                       NULL
                       DEFAULT NULL
                       COMMENT '결제 기관 ',
   PRIMARY KEY(idx, reg_dt)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE(year(`reg_dt`))(PARTITION p2019 VALUES LESS THAN (2020),
 PARTITION p2020 VALUES LESS THAN (2021),
 PARTITION p2021 VALUES LESS THAN (2022),
 PARTITION p2022 VALUES LESS THAN (2023),
 PARTITION p2023 VALUES LESS THAN (2024),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);

/******************************************************************************
**		Name: TABLE TBL_PCODE
**		Desc: 회원 pi, mi, ci 정보 저장
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
CREATE TABLE `TBL_PCODE`
(
   idx                  BIGINT(20) NOT NULL AUTO_INCREMENT,
   reg_dt               DATETIME(0) NULL DEFAULT NULL COMMENT '생성일',
   p_code               VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
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
   UNIQUE KEY `TBL_PCODE_p_code_uindex`(p_code),
   UNIQUE KEY `TBL_PCODE_ci_uindex`(ci),
   PRIMARY KEY(idx, p_code)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


/******************************************************************************
**		Name: CHANGE THE TABLE on runtime
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2020-10-06
*******************************************************************************/
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'p_code';
/*
+--------------+---------------------------+-------------+
| TABLE_SCHEMA | TABLE_NAME                | COLUMN_NAME |
+--------------+---------------------------+-------------+
| EMAILBOX     | TBL_DOCUMENTS             | p_code      |
| EMAILBOX     | TBL_EPOSTMEMBER           | p_code      |
| EMAILBOX     | TBL_MYAGENCY              | p_code      |
| EMAILBOX     | TBL_PAYMENT               | p_code      |
| EMAILBOX     | TBL_PCODE                 | p_code      |
+--------------+---------------------------+-------------+
*/
ALTER TABLE TBL_DOCUMENTS MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE TBL_EPOSTMEMBER MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE TBL_PCODE MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE TBL_PAYMENT MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE TBL_MYAGENCY MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE TBL_MYDOCUMENT MODIFY p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

