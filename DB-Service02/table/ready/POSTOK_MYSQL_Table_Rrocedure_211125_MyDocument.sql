/******************************************************************************
**		Name: TABLE TBL_DOCUMENTS
**		Desc: 발송 상태/우편 목록
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2021-11-25
*******************************************************************************/
DROP TABLE TBL_DOCUMENTS;

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
                          COMMENT '다운로드 가능 여부 확인',
   edoc_no              VARCHAR(33)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NULL
                          DEFAULT NULL
                          COMMENT '공인전자문서중계자 전자문서번호 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13)',
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

ALTER TABLE TBL_DOCUMENTS ADD edoc_no VARCHAR(33) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '공인전자문서중계자 전자문서번호 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13)';



/******************************************************************************
**		Name: TABLE TBL_EDOCUMENTS_SERIAL_NO
**		Desc: 공인전자문서 중계자에서 사용되는 일련번호 테이블
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2020-11-25
*******************************************************************************/
DROP TABLE `TBL_EDOCUMENTS_SERIAL_NO`;

CREATE TABLE `TBL_EDOCUMENTS_SERIAL_NO`
(
   idx            BIGINT(20) NOT NULL AUTO_INCREMENT,
   group_by       VARCHAR(32)
                     CHARACTER SET utf8
                     COLLATE utf8_general_ci
                     NOT NULL
                     DEFAULT ""
                     COMMENT '그룹으로 검색을 하기 위한 기관에서 관리하는 keyword ',
   start_num      BIGINT(20) NOT NULL DEFAULT 0,
   end_num        BIGINT(20) NOT NULL DEFAULT 9999999999999,
   current_num    BIGINT(20) NOT NULL DEFAULT 0,
   use_status     INT(2) NULL DEFAULT 1,
   reg_dt         DATETIME(0) NOT NULL COMMENT '등록 시간',
   UNIQUE KEY(group_by),
   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

/******************************************************************************
**		Name: PROCEDURE SP_AN_REG_DOCUMENT_V2
**		Desc: nosql의 문서 분석 후 공인전자문서 저장
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2021-11-25
*******************************************************************************/

DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_REG_DOCUMENT_V2`;

DELIMITER ;;
CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_REG_DOCUMENT_V2`(
   IN `$PARAM_PCODE`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`       BIGINT(20),
   IN `$PARAM_DISP_CLASS`      VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`          VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`       VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TITLE`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CONTENT`         VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_GROUP_BY`        VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REG_DT`          DATETIME,
   IN `$PARAM_PAYAMOUNT`       BIGINT(20),
   IN `$PARAM_PAYPUB_DT`       DATE,
   IN `$PARAM_PAYDUE_DT`       DATE,
   IN `$PARAM_TEMPLATE_CODE`   VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TEMPLATE_DNYN`   VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @now_dt := now();
   SET @LastIDX := -1;
   SET @eDocNo := '';
   SET @error := '0';
   SET @idx := 0;
   SET @end_num := 0;
   SET @current_num := 0;
   SET @use_status := 0;

   SELECT idx, end_num, current_num, use_status INTO @idx, @end_num, @current_num, @use_status 
                                                FROM TBL_EDOCUMENTS_SERIAL_NO WHERE group_by = $PARAM_GROUP_BY;

   IF @use_status = 2 THEN 
      SET @error := '-1';
   ELSE
      IF @current_num = 0 THEN
         INSERT INTO TBL_EDOCUMENTS_SERIAL_NO (group_by, reg_dt) VALUES ($PARAM_GROUP_BY, @now_dt);
         SELECT idx, end_num, current_num INTO @idx, @end_num, @current_num FROM TBL_EDOCUMENTS_SERIAL_NO WHERE group_by = $PARAM_GROUP_BY AND use_status = 1;
      END IF;

      IF @end_num > @current_num THEN
         UPDATE TBL_EDOCUMENTS_SERIAL_NO SET current_num = @current_num + 1 WHERE idx = @idx;
      ELSE
         UPDATE TBL_EDOCUMENTS_SERIAL_NO SET current_num = @end_num, use_status = 2 WHERE idx = @idx;
      END IF;

      SET @eDocNo := CONCAT(REGEXP_REPLACE($PARAM_GROUP_BY, '[^0-9]+',''), '_', 'EPOST', LPAD($PARAM_AGENCY_ID, 5, '0'), '_', LPAD(@current_num+1, 13, 0));

      INSERT IGNORE INTO TBL_DOCUMENTS(nosql_index,
                                       doc_id,
                                       reg_dt,
                                       agency_id,
                                       p_code,
                                       p_code_idx,
                                       doc_title,
                                       doc_content,
                                       doc_version,
                                       disp_class,
                                       disp_status,
                                       disp_dt,
                                       read_dt,
                                       doc_download_YN,
                                       group_by,
                                       request_id,
                                       deleted_YN,
                                       template_code,
                                       dn_yn,
                                       edoc_no)
                  VALUES ($PARAM_DOC_INDEX,
                        $PARAM_DOC_ID,
                        $PARAM_REG_DT,
                        $PARAM_AGENCY_ID,
                        $PARAM_PCODE,
                        $PARAM_PCODE_IDX,
                        $PARAM_TITLE,
                        $PARAM_CONTENT,
                        "R20211111",
                        $PARAM_DISP_CLASS,
                        '1',
                        @now_dt,
                        NULL,
                        'N',
                        $PARAM_GROUP_BY,
                        $PARAM_REQUEST_ID,
                        'N',
                        $PARAM_TEMPLATE_CODE,
                        $PARAM_TEMPLATE_DNYN,
                        @eDocNo);

      SELECT LAST_INSERT_ID() INTO @LastIDX;

      IF $PARAM_PAYAMOUNT > -1 AND @LastIDX > 0
      THEN
         INSERT INTO TBL_PAYMENT(p_code,
                                 p_code_idx,
                                 doc_idx,
                                 reg_dt,
                                 nosql_index,
                                 doc_id,
                                 agency_id,
                                 pay_amount,
                                 pay_pub_dt,
                                 pay_duedate_dt,
                                 pay_dt)
            VALUES ($PARAM_PCODE,
                     $PARAM_PCODE_IDX,
                     @LastIDX,
                     $PARAM_REG_DT,
                     $PARAM_DOC_INDEX,
                     $PARAM_DOC_ID,
                     $PARAM_AGENCY_ID,
                     $PARAM_PAYAMOUNT,
                     $PARAM_PAYPUB_DT,
                     $PARAM_PAYDUE_DT,
                     NULL);
      END IF;

   END IF;

   SELECT @error, @LastIDX, @eDocNo;
END;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_AN_REG_DOCUMENT_V2
**		Desc: 프로시져 검증
**
**		Author: ERIC KYEHYUK AHN
**		Date: 2021-11-25
*******************************************************************************/


CALL SP_AN_REG_DOCUMENT_V2("P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317fb441ce71babcKR",158,"2","11001-00001", "iNQPDn0BxqNTq2i7qRuE", "11","테스트3","테스트3내용", '60002-202111110000012', '2021.11.25', now(), 30000, now(), now(), "00004", 'Y');
