/******************************************************************************
			POSTOK 
			version : 1.3.0
			
			Auth : KYEHYUK AHN
			Last Update Date : 2021-11-17
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
   p_code_idx         BIGINT(20) NULL DEFAULT NULL,
   p_code             VARCHAR(128)
                        CHARACTER SET utf8
                        COLLATE utf8_general_ci
                        NULL
                        DEFAULT NULL,
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
   license_number     VARCHAR(16)
                        DEFAULT '' 
                        COMMENT '사업자등록번호',
   foundation_day     VARCHAR(16)
                        DEFAULT '' 
                        COMMENT '창립일',
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

ALTER TABLE TBL_AGENCY ADD p_code_idx BIGINT(20) NULL DEFAULT NULL;
ALTER TABLE TBL_AGENCY ADD p_code VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
ALTER TABLE TBL_AGENCY ADD foundation_day VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '창립일';
