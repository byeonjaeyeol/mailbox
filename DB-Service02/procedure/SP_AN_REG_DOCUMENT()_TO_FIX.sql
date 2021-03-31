/******************************************************************************
**		Name: PROCEDURE SP_AN_REG_DOCUMENT
**		Desc: nosql의 문서 분석 후 문서 저장
*******************************************************************************/
DELIMITER ;;
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_REG_DOCUMENT`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_REG_DOCUMENT`(
   IN `$PARAM_PCODE`           VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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

   INSERT IGNORE INTO TBL_DOCUMENTS(nosql_index,
                                    doc_id,
                                    reg_dt,
                                    agency_id,
                                    p_code,
                                    p_code_idx,
                                    doc_title,
                                    doc_content,
                                    disp_class,
                                    disp_status,
                                    disp_dt,
                                    read_dt,
                                    doc_download_YN,
                                    group_by,
                                    request_id,
                                    deleted_YN,
                                    template_code,
                                    dn_yn)
               VALUES ($PARAM_DOC_INDEX,
                       $PARAM_DOC_ID,
                       $PARAM_REG_DT,
                       $PARAM_AGENCY_ID,
                       $PARAM_PCODE,
                       $PARAM_PCODE_IDX,
                       $PARAM_TITLE,
                       $PARAM_CONTENT,
                       $PARAM_DISP_CLASS,
                       '1',
                       @now_dt,
                       NULL,
                       'N',
                       $PARAM_GROUP_BY,
                       $PARAM_REQUEST_ID,
                       'N',
                       $PARAM_TEMPLATE_CODE,
                       $PARAM_TEMPLATE_DNYN);

   SELECT LAST_INSERT_ID()
     INTO @LastIDX;

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

   SELECT @LastIDX;
END;;
DELIMITER ;