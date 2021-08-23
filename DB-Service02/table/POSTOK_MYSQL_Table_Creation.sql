/******************************************************************************
			POSTOK 
			version : 1.2.7
			
			Auth : HAEIN LEE
			Last Update Date : 2020-07-01
*******************************************************************************/
USE EMAILBOX;
/******************************************************************************
**		Name: TABLE TBL_AGENCY
**		Desc: 발송 기관 목록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_AGENCY`
(
   idx                BIGINT(20) NOT NULL AUTO_INCREMENT,
   org_code           VARCHAR(10)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   org_name           VARCHAR(64)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   dept_code          VARCHAR(10)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL
                        COMMENT 'KT의 기관코드에 해당 됨  ',
   dept_name          VARCHAR(64)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   manager            VARCHAR(32)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   contact            VARCHAR(20)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   email              VARCHAR(128)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   icon_link          VARCHAR(260)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   validity_dt        DATETIME(0) NULL DEFAULT NULL,
   channel            VARCHAR(20)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   org                VARCHAR(20)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   multiplexing_fg    INT(11)
                        NULL
                        DEFAULT 0
                        COMMENT '멀티 threading 작업을 위한 플래',
   stat_trace         SMALLINT(6)
                        NULL
                        DEFAULT 2
                        COMMENT '통계 자료 추출 범위( 현재 날짜로 부터 설정된 숫자 이전 까지)',
   rollover_maxage    VARCHAR(4)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT '30d',
   rollover_maxdoc    INT(11) NULL DEFAULT 0,
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_AGENCY_USER
**		Desc: 웹포탈 가입한 기관 목록(외주업체가 생성함)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_AGENCY_USER`
(
   id           INT(11) NOT NULL AUTO_INCREMENT,
   org_name     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   dept_name    TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   user         TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   password     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   salt         TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   manager      TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   contact      TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   email        TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   authority    TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_BCCHANNEL
**		Desc: 블록체인 채널
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_BCCHANNEL`
(
   idx             BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   channel_name    VARCHAR(32)
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
**		Name: TABLE TBL_BCORG
**		Desc: 블록체인 기관
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_BCORG`
(
   idx         BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   org_name    VARCHAR(32)
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
**		Name: TABLE TBL_CALL
**		Desc: 웹포탈 콜상담을 위한 테이블(외주업체가 생성함)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_CALL`
(
   id          INT(11) NOT NULL AUTO_INCREMENT,
   class       INT(11) NOT NULL,
   subject     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   content     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   reg_dt      TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(),
   reg_name    TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_CH_MYAGENCYDISP_HISTORY
**		Desc: myagency disp_class 변경 히스토리 저장 테이블
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_CH_MYAGENCYDISP_HISTORY`
(
   p_code_idx    BIGINT(20) UNSIGNED NOT NULL,
   agency_id     BIGINT(20) NOT NULL,
   edit_dt       DATETIME(0) NOT NULL,
   acttion_fg    VARCHAR(3)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NOT NULL
                   DEFAULT '-1'
                   COMMENT 'cr:insert,deny,online,dm'
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE(year(`edit_dt`))(PARTITION p2019 VALUES LESS THAN (2020),
 PARTITION p2020 VALUES LESS THAN (2021),
 PARTITION p2021 VALUES LESS THAN (2022),
 PARTITION p2022 VALUES LESS THAN (2023),
 PARTITION p2023 VALUES LESS THAN (2024),
 PARTITION p2024 VALUES LESS THAN (2025),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_CONNECTION
**		Desc: (외주업체가 생성함) ?
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_CONNECTION`
(
   id            INT(11) NOT NULL AUTO_INCREMENT,
   user_id       TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   user_type     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   `datetime`    TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(),
   ip            TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_DOCUMENTS
**		Desc: 발송 상태/우편 목록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
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
   p_code               VARCHAR(100)
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
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_EPOSTMEMBER`
(
   p_code_idx          BIGINT(20) NULL DEFAULT NULL,
   p_code              VARCHAR(37)
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
**		Name: TABLE TBL_FAILED_DISPATCH
**		Desc: sp_an_get_memberfrommi에서 멤버검색 에러 추적용 테이블.
**				현재 사용하지 않음. 지우면 문제될 수 있어 유지함.		
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_FAILED_DISPATCH`
(
   ci              VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   agency_id       BIGINT(20) NOT NULL,
   nosql_index     VARCHAR(64)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NULL
                     DEFAULT NULL,
   doc_id          VARCHAR(64)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NOT NULL,
   disp_class      VARCHAR(2)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NOT NULL,
   doc_title       VARCHAR(128)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NULL
                     DEFAULT NULL,
   reg_dt          DATETIME(0) NOT NULL,
   error_code      VARCHAR(6)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NOT NULL,
   error_reason    VARCHAR(260)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NULL
                     DEFAULT NULL
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_FILES
**		Desc: (외주업체가 생성함)?
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_FILES`
(
   id                 INT(11) NOT NULL AUTO_INCREMENT,
   filename           TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   origin_filename    TEXT
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_LOGIN_HISTORY
**		Desc: 포스톡 회원 로그인 히스토리
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_LOGIN_HISTORY`
(
   idx              BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   p_code_index     BIGINT(20) UNSIGNED NULL DEFAULT NULL,
   login_dt         DATETIME(0) NOT NULL COMMENT '문서번호 ',
   error_code       INT(11) NOT NULL,
   error_msg        VARCHAR(50)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   login_hp_uuid    VARCHAR(128)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL
                      COMMENT '핸드폰 UUID',
   login_hp_desc    VARCHAR(64)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL
                      COMMENT '핸드폰 기기',
   user_agent       VARCHAR(1024)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL
                      COMMENT 'http header agent: 접속시 사용한 user agent ',
   PRIMARY KEY(idx, login_dt)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE(year(`login_dt`))(PARTITION p2019 VALUES LESS THAN (2020),
 PARTITION p2020 VALUES LESS THAN (2021),
 PARTITION p2021 VALUES LESS THAN (2022),
 PARTITION p2022 VALUES LESS THAN (2023),
 PARTITION p2023 VALUES LESS THAN (2024),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_MEMBERADDRESS
**		Desc: 회원 주소
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_MEMBERADDRESS`
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
**		Name: TABLE TBL_MEMBERCAR
**		Desc: 회원 차량
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_MEMBERCAR`
(
   idx            BIGINT(20) NOT NULL AUTO_INCREMENT,
   p_code_idx     BIGINT(20) NULL DEFAULT NULL,
   p_code         TINYTEXT
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   car_num        TINYTEXT
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   description    VARCHAR(300)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NULL
                    DEFAULT NULL,
   column_6       INT(11) NULL DEFAULT NULL,
   column_7       INT(11) NULL DEFAULT NULL,
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_MYAGENCY
**		Desc: 회원이 등록한 내 기관
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_MYAGENCY`
(
   idx           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   p_code_idx    BIGINT(20) NULL DEFAULT NULL,
   p_code        VARCHAR(37)
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
**		Name: TABLE TBL_NOTICE
**		Desc: (외주업체가 생성함)?
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_NOTICE`
(
   id          INT(11) NOT NULL AUTO_INCREMENT,
   subject     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   content     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   reg_dt      TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(),
   reg_name    TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   file        TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_PAYMENT
**		Desc: 고지서 결제 목록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
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
   p_code            VARCHAR(37)
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
**		Name: TABLE TBL_PAYMENT_HISTORY
**		Desc: 고지서 결제 히스토리 저장
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_PAYMENT_HISTORY`
(
   idx           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   pay_idx       BIGINT(20) UNSIGNED NOT NULL,
   p_code_idx    BIGINT(20) UNSIGNED NOT NULL,
   done_dt       DATETIME(0) NOT NULL COMMENT '결제 처리 날짜 ',
   error_code    INT(11) NOT NULL COMMENT '결제 결과 코드',
   error_msg     VARCHAR(50)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NOT NULL
                   COMMENT '결제 결과 메세지',
   pay_info      VARCHAR(1024)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NOT NULL
                   COMMENT '결제 처리 상세정보(json)',
   PRIMARY KEY(idx, done_dt)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE(year(`done_dt`))(PARTITION p2019 VALUES LESS THAN (2020),
 PARTITION p2020 VALUES LESS THAN (2021),
 PARTITION p2021 VALUES LESS THAN (2022),
 PARTITION p2022 VALUES LESS THAN (2023),
 PARTITION p2023 VALUES LESS THAN (2024),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_PCODE
**		Desc: 회원 pi, mi, ci 정보 저장
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_PCODE`
(
   idx                  BIGINT(20) NOT NULL AUTO_INCREMENT,
   reg_dt               DATETIME(0) NULL DEFAULT NULL COMMENT '생성일',
   p_code               VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
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
**		Name: TABLE TBL_PUSHMSG
**		Desc: 푸쉬 알림 목록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_PUSHMSG`
(
   idx                BIGINT(20) NOT NULL AUTO_INCREMENT,
   push_token         VARCHAR(4096)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   agency_id          BIGINT(20) NULL DEFAULT NULL,
   org_code           VARCHAR(10)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   dept_code          VARCHAR(10)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   p_code_idx         BIGINT(20) NULL DEFAULT NULL,
   doc_idx            BIGINT(20) NULL DEFAULT NULL,
   nosql_index        VARCHAR(64)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   doc_id             VARCHAR(64)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
   title              VARCHAR(128)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL
                        COMMENT 'push message 제목 ',
   content            VARCHAR(1024)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL
                        COMMENT 'push message 내용 ',
   `push_YN`          VARCHAR(2)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT 'N'
                        COMMENT 'push 여부(N/Y)',
   reg_dt             DATETIME(0) NOT NULL COMMENT '등록 시간 ',
   push_dt            DATETIME(0)
                        NULL
                        DEFAULT NULL
                        COMMENT '구글에 푸시 발송 요청한 시간',
   msg_class          INT(11)
                        NULL
                        DEFAULT 2
                        COMMENT '푸쉬 종류 (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트) ',
   multiplexing_fg    INT(11)
                        NULL
                        DEFAULT NULL
                        COMMENT '멀티 쓰레딩을 위한 작업 index ',
   result             INT(11)
                        NULL
                        DEFAULT 0
                        COMMENT '구글로 부터 push 발송결과 값( 0: 성공 0외: 실패) ',
   error_string       VARCHAR(256)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL
                        COMMENT '실패인경우 실패 원인 ',
   PRIMARY KEY(idx, reg_dt)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT
PARTITION BY RANGE COLUMNS(`reg_dt`)(PARTITION p202003 VALUES LESS THAN ('2020-04-01 00:00:00'),
 PARTITION p202004 VALUES LESS THAN ('2020-05-01 00:00:00'),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_REGISTRATION_NUM
**		Desc: 등기번호 관리 테이블, 일자리에이전트 dm 중 등기우편 발송시에만 저장됨
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_REGISTRATION_NUM`
(
   idx            BIGINT(20) NOT NULL AUTO_INCREMENT,
   agency_idx     BIGINT(20) NOT NULL,
   start_num      BIGINT(20) NOT NULL,
   end_num        BIGINT(20) NOT NULL,
   current_num    BIGINT(20) NOT NULL,
   use_status     INT(2) NULL DEFAULT 0,
   reg_dt         DATETIME(0) NOT NULL COMMENT '등록 시간',
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_STAT_DISPRESULT
**		Desc: nosql 발송 문서 분석 테이블
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_STAT_DISPRESULT`
(
   update_dt              DATETIME(0)
                            NULL
                            DEFAULT NULL
                            COMMENT '업데이트 또 추가된 시간',
   reg_dt                 DATE NOT NULL COMMENT '접수된 날',
   org_code               VARCHAR(10)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL,
   dept_code              VARCHAR(10)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL,
   group_by               VARCHAR(32)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL,
   template               VARCHAR(64)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '서식 파일 이름(확장자 제외)',
   reg_cnt                INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '우편물 접수(등록) 수 ',
   read_cnt               INT(11) NULL DEFAULT NULL COMMENT '열람된 갯',
   wait_cnt               INT(11) NULL DEFAULT NULL COMMENT '발송 대기 ',
   ing_mms_cnt            INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '발송처리(요청한) MMS 수 ',
   ing_dm_cnt             INT(11) NULL DEFAULT NULL COMMENT 'DM 발송 요청 ',
   ing_deny_cnt           INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'Deny 되어 발송기관의 정보로 DM 발송 처리',
   disp_mms_cnt           INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'mms 발송 요청 완료 ',
   disp_dm_cnt            INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'DM 발송 요청 처리된 수',
   disp_deny_cnt          INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'Deny 되어 발송기관의 정보로 DM 발송요청 처리된 수',
   done_app_cnt           INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '발송 완료한 APP 수 ',
   done_mms_cnt           INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '발송 완료 mms 수 ',
   done_dm_cnt            INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '발송 요청을 완료한 DM 수 ',
   done_deny_cnt          INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'Deny 되어 발송기관의 정보로 DM 발송 처리 완료',
   retry_mms_dm_cnt       INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'mms 발송 실패로 DM으로 재처리 한 갯수 ',
   failed_deny_cnt        INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'Deny 되어 발송기관의 정보로 DM 발송용 정보가 없어 발송 차단 된 경우',
   failed_retry_cnt       INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'MMS 발송 실패로 DM  발송 요청 작업중 수신자 정보가 없어 발송 요청을 하지 못한 갯수 ',
   failed_cnt             INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT '등록된 CI 정보가 없음',
   result_mms_suc_cnt     INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'mms 발송 처리 결과 성공한 수 ',
   result_mms_fail_cnt    INT(11)
                            NULL
                            DEFAULT NULL
                            COMMENT 'mms 발송 처리 결과가 실패한 ',
   PRIMARY KEY
      (reg_dt,
       org_code,
       dept_code,
       group_by,
       template)
)
COMMENT '발송결과 통계 '
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_STAT_RECVFILE_RESULT
**		Desc: 일자리에이전트 데이터 처리결과 모니터링 테이블
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_STAT_RECVFILE_RESULT`
(
   idx              BIGINT(20) NOT NULL AUTO_INCREMENT,
   reg_dt           DATETIME(0) NOT NULL COMMENT '분석 시간',
   file_name        VARCHAR(100)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   records_num      INT(20) NOT NULL,
   documents_num    INT(20) NOT NULL,
   `error_YN`       VARCHAR(2)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   error_string     VARCHAR(100)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL,
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
 PARTITION p2024 VALUES LESS THAN (2025),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_STAT_SENDFILE_RESULT
**		Desc: 분석서버에서 외부업체에 메일 전송 결과 저장
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_STAT_SENDFILE_RESULT`
(
   idx              BIGINT(20) NOT NULL AUTO_INCREMENT,
   reg_dt           DATETIME(0) NOT NULL COMMENT '전송 시간',
   file_name        VARCHAR(100)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   target_ip        VARCHAR(20)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   disp_class       VARCHAR(2)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NOT NULL,
   documents_num    INT(20) NOT NULL,
   success_num      INT(20) NOT NULL,
   failed_num       INT(20) NOT NULL,
   reproc_num       INT(20) NOT NULL,
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
 PARTITION p2024 VALUES LESS THAN (2025),
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE);
/******************************************************************************
**		Name: TABLE TBL_SYSTEM_USER
**		Desc: (외주업체가 생성함)?
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_SYSTEM_USER`
(
   id           INT(11) NOT NULL AUTO_INCREMENT,
   user         TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   password     TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   salt         TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   manager      TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   contact      TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   email        TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   authority    TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
   PRIMARY KEY(id)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;
/******************************************************************************
**		Name: TABLE TBL_TEMPLATE
**		Desc: 발송 문서 양식
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
CREATE TABLE `TBL_TEMPLATE`
(
   idx              BIGINT(20) NOT NULL AUTO_INCREMENT,
   agency_id        BIGINT(20) NULL DEFAULT NULL COMMENT '기관+부서 ID ',
   template_name    VARCHAR(260)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL
                      COMMENT '템플릿 이름 ',
   template_code    VARCHAR(10)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL
                      COMMENT '서식 코드 ',
   file_name        VARCHAR(260)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT NULL
                      COMMENT '파일 이름 ( 통계 검색 조건 이므로 발송 Data의 템플릿 파일이름과 동일하게 해야 함) ',
   reg_dt           DATETIME(0) NULL DEFAULT NULL COMMENT '등록 일자 ',
   dn_yn            VARCHAR(2)
                      CHARACTER SET utf8
                      COLLATE utf8_general_ci
                      NULL
                      DEFAULT 'Y',
   PRIMARY KEY(idx),
   UNIQUE KEY template_code(template_code)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;












































