/******************************************************************************
**		Name: TABLE TBL_TEMPLATE UPDATE
**		Desc: 기존 TBL_TEMPLATE 테이블 업데이트 
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2021-12-30
*******************************************************************************/
ALTER TABLE TBL_TEMPLATE ADD registration_num BIGINT(20) NULL DEFAULT NULL;

/******************************************************************************
**		Name: TABLE TBL_TEMPLATE
**		Desc: 발송 문서 양식 
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2021-12-30
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
   registration_num BIGINT(20) NULL DEFAULT NULL,
   PRIMARY KEY(idx),
   UNIQUE KEY template_code(template_code)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;








