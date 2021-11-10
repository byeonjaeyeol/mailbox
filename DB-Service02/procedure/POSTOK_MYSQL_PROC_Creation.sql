/******************************************************************************
			POSTOK Procedure creation
			version : 1.2.7
			
			Auth : HAEIN LEE
			Last Update Date : 2020-07-01
*******************************************************************************/
USE EMAILBOX;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBERFROMCI
**		Desc: 멤버 유무 검색 (bulk.go)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMCI`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_MEMBERFROMCI`(
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @error_code := '0';
   SET @error_string := '';
   SET @error := '0';
   SET @p_code_idx := 0;
   SET @p_code := '';
   SET @disp_class := '';
   SET @zip_code := '';
   SET @addr1 := '';
   SET @addr2 := '';
   SET @member_yn := 'N';                                      #가입 회원 여부 - Y/N
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();

   SELECT idx,
          p_code,
          member_yn,
          disp_class,
          push_token,
          push_permit_class
     INTO @p_code_idx,
          @p_code,
          @member_yn,
          @default_disp_class,
          @push_token,
          @push_permit_class
     FROM TBL_PCODE
    WHERE ci = $PARAM_CI;

   IF @p_code IS NULL OR LENGTH(@p_code) = 0
   THEN
      #p_code 검색 실패
      SET @error := '-1';
      SET @disp_class := '-1';
      SET @error_code := '3101';
      SET @error_string := 'p_code가 등록 되어 있지 않습니다';
   ELSE
      SET @error := '0';

      IF @member_yn = 'Y'
      THEN
         SELECT disp_class
           INTO @disp_class
           FROM TBL_MYAGENCY
          WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            SET @disp_class = @default_disp_class;
         END IF;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            #MEMBER 검색 실패 오류
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member talbe에서 검색 되지 않았습니다';
         END IF;
      ELSE
         SET @disp_class = '2';
      END IF;
   END IF;

   /*
 IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( ci, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, error_code, error_reason )
       VALUES ( $PARAM_CI, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt,  @error_code, @error_string );
   END IF;
   */

   #return
   SELECT @error,
          @now_dt,
          @p_code_idx,
          @p_code,
          @disp_class,
          @zip_code,
          @addr1,
          @addr2,
          @member_yn,
          @push_token,
          @push_permit_class;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBERFROMMI
**		Desc: 멤버 유무 검색 (bulk.go)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBERFROMMI`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_MEMBERFROMMI`(
   IN `$PARAM_MI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @error_code := '0';
   SET @error_string := '';
   SET @error := '0';
   SET @p_code_idx := 0;
   SET @p_code := '';
   SET @disp_class := '';
   SET @zip_code := '';
   SET @addr1 := '';
   SET @addr2 := '';
   SET @member_yn := 'N';                                      #가입 회원 여부 - Y/N
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();

   SELECT idx,
          p_code,
          member_yn,
          disp_class,
          push_token,
          push_permit_class
     INTO @p_code_idx,
          @p_code,
          @member_yn,
          @default_disp_class,
          @push_token,
          @push_permit_class
     FROM TBL_PCODE
    WHERE mi = $PARAM_MI;

   IF @p_code IS NULL OR LENGTH(@p_code) = 0
   THEN
      #p_code 검색 실패
      SET @error := '-1';
      SET @disp_class := '-1';
      SET @error_code := '3101';
      SET @error_string := 'p_code가 등록 되어 있지 않습니다';
   ELSE
      SET @error := '0';

      IF @member_yn = 'Y'
      THEN
         SELECT disp_class
           INTO @disp_class
           FROM TBL_MYAGENCY
          WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            SET @disp_class = @default_disp_class;
         END IF;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            #MEMBER 검색 실패 오류
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member talbe에서 검색 되지 않았습니다';
         END IF;
      ELSE
         SET @disp_class = '2';
      END IF;
   END IF;


   /*
 IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( ci, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, error_code, error_reason )
       VALUES ( $PARAM_CI, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt,  @error_code, @error_string );
   END IF;
   */

   #return
   SELECT @error,
          @now_dt,
          @p_code_idx,
          @p_code,
          @disp_class,
          @zip_code,
          @addr1,
          @addr2,
          @member_yn,
          @push_token,
          @push_permit_class;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBERFROMPI
**		Desc: 멤버 유무 검색 (bulk.go)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBERFROMPI`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_MEMBERFROMPI`(
   IN `$PARAM_PI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @error_code := '0';
   SET @error_string := '';
   SET @error := '0';
   SET @p_code_idx := 0;
   SET @p_code := '';
   SET @disp_class := '';
   SET @zip_code := '';
   SET @addr1 := '';
   SET @addr2 := '';
   SET @member_yn := 'N';                                      #가입 회원 여부 - Y/N
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();

   SELECT idx,
          p_code,
          member_yn,
          disp_class,
          push_token,
          push_permit_class
     INTO @p_code_idx,
          @p_code,
          @member_yn,
          @default_disp_class,
          @push_token,
          @push_permit_class
     FROM TBL_PCODE
    WHERE p_code = $PARAM_PI;

   IF @p_code IS NULL OR LENGTH(@p_code) = 0
   THEN
      #p_code 검색 실패
      SET @error := '-1';
      SET @disp_class := '-1';
      SET @error_code := '3101';
      SET @error_string := 'p_code가 등록 되어 있지 않습니다';
   ELSE
      SET @error := '0';

      IF @member_yn = 'Y'
      THEN
         SELECT disp_class
           INTO @disp_class
           FROM TBL_MYAGENCY
          WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            SET @disp_class = @default_disp_class;
         END IF;

         IF @disp_class IS NULL OR LENGTH(@disp_class) = 0
         THEN
            #MEMBER 검색 실패 오류
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member talbe에서 검색 되지 않았습니다';
         END IF;
      ELSE
         SET @disp_class = '2';
      END IF;
   END IF;

   /*
 IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( ci, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, error_code, error_reason )
       VALUES ( $PARAM_CI, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt,  @error_code, @error_string );
   END IF;
   */

   #return
   SELECT @error,
          @now_dt,
          @p_code_idx,
          @p_code,
          @disp_class,
          @zip_code,
          @addr1,
          @addr2,
          @member_yn,
          @push_token,
          @push_permit_class;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_RECVADDRESS
**		Desc: 회원의 문서 수령 주소 가져오기
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_RECVADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_RECVADDRESS`(
   IN `$PARAM_PCODE_IDX`    BIGINT(20),
   IN `$PARAM_AGENCY_IDX`   BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @myaddr_idx := NULL;
   SET @name := NULL;
   SET @zipcode := NULL;
   SET @addr1 := NULL;
   SET @addr2 := NULL;

   SELECT myaddr_idx
     INTO @myaddr_idx
     FROM TBL_MYAGENCY
    WHERE     p_code_idx = $PARAM_PCODE_IDX
          AND agency_id = $PARAM_AGENCY_IDX
          AND use_YN = 'Y';

   SELECT name
     INTO @name
     FROM TBL_EPOSTMEMBER
    WHERE p_code_idx = $PARAM_PCODE_IDX;

   IF @myaddr_idx IS NULL
   THEN
      SELECT zipcode, addr1, addr2
        INTO @zipcode, @addr1, @addr2
        FROM TBL_MEMBERADDRESS
       WHERE p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';
   ELSE
      SELECT zipcode, addr1, addr2
        INTO @zipcode, @addr1, @addr2
        FROM TBL_MEMBERADDRESS
       WHERE idx = @myaddr_idx;

      IF @zipcode IS NULL
      THEN
         SELECT zipcode, addr1, addr2
           INTO @zipcode, @addr1, @addr2
           FROM TBL_MEMBERADDRESS
          WHERE p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';
      END IF;
   END IF;

   SELECT @name,
          @zipcode,
          @addr1,
          @addr2;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_TEMPLATECODE
**		Desc: 문서 템플릿 가져오기
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_TEMPLATECODE`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_TEMPLATECODE`(
   IN `$PARAM_AGENCYID`   BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT template_code, dn_yn
     FROM TBL_TEMPLATE
    WHERE agency_id = $PARAM_AGENCYID;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_VALIDITYAGENCY
**		Desc: 계약기간이 유효한 기관 가져오기
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_VALIDITYAGENCY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_GET_VALIDITYAGENCY` ()
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT idx,
          org_code,
          dept_code,
          channel,
          org,
          multiplexing_fg,
          stat_trace,
          rollover_maxage,
          rollover_maxdoc
     FROM TBL_AGENCY
    WHERE validity_dt >= now();
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_REG_DOCUMENT
**		Desc: nosql의 문서 분석 후 문서 저장
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
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
END;
/******************************************************************************
**		Name: PROCEDURE SP_AN_SET_STAT
**		Desc: nosql에 있는 발송 문서 분석
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_SET_STAT`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AN_SET_STAT`(
   IN `$PARAM_DATE`               DATE,
   IN `$PARAM_ORG_CODE`           VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DEPT_CODE`          VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_GROUP_BY`           VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_FILENAME`           VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REG_CNT`            INT(11),
   IN `$PARAM_READ_CNT`           INT(11),
   IN `$PARAM_WAIT_CNT`           INT(11),
   IN `$PARAM_ING_MMS_CNT`        INT(11),
   IN `$PARAM_ING_DM_CNT`         INT(11),
   IN `$PARAM_ING_DENY_CNT`       INT(11),
   IN `$PARAM_DISP_MMS_CNT`       INT(11),
   IN `$PARAM_DISP_DM_CNT`        INT(11),
   IN `$PARAM_DISP_DENY_CNT`      INT(11),
   IN `$PARAM_DONE_APP_CNT`       INT(11),
   IN `$PARAM_DONE_MMS_CNT`       INT(11),
   IN `$PARAM_DONE_DM_CNT`        INT(11),
   IN `$PARAM_DONE_DENY_CNT`      INT(11),
   IN `$PARAM_RETRY_CNT`          INT(11),
   IN `$PARAM_FAILED_DENY_CNT`    INT(11),
   IN `$PARAM_FAILED_RETRY_CNT`   INT(11),
   IN `$PARAM_FAILED_CNT`         INT(11),
   IN `$PARAM_RES_MMSSUC_CNT`     INT(11),
   IN `$PARAM_RES_MMSFAIL_CNT`    INT(11))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   #status : waiting, ing, dispathced, done, deny, failed

   INSERT INTO TBL_STAT_DISPRESULT(update_dt,
                                   reg_dt,
                                   org_code,
                                   dept_code,
                                   group_by,
                                   template,
                                   reg_cnt,
                                   read_cnt,
                                   wait_cnt,
                                   ing_mms_cnt,
                                   ing_dm_cnt,
                                   ing_deny_cnt,
                                   disp_mms_cnt,
                                   disp_dm_cnt,
                                   disp_deny_cnt,
                                   done_app_cnt,
                                   done_mms_cnt,
                                   done_dm_cnt,
                                   done_deny_cnt,
                                   retry_mms_dm_cnt,
                                   failed_deny_cnt,
                                   failed_retry_cnt,
                                   failed_cnt,
                                   result_mms_suc_cnt,
                                   result_mms_fail_cnt)
        VALUES (now(),
                $PARAM_DATE,
                $PARAM_ORG_CODE,
                $PARAM_DEPT_CODE,
                $PARAM_GROUP_BY,
                $PARAM_FILENAME,
                $PARAM_REG_CNT,
                $PARAM_READ_CNT,
                $PARAM_WAIT_CNT,
                $PARAM_ING_MMS_CNT,
                $PARAM_ING_DM_CNT,
                $PARAM_ING_DENY_CNT,
                $PARAM_DISP_MMS_CNT,
                $PARAM_DISP_DM_CNT,
                $PARAM_DISP_DENY_CNT,
                $PARAM_DONE_APP_CNT,
                $PARAM_DONE_MMS_CNT,
                $PARAM_DONE_DM_CNT,
                $PARAM_DONE_DENY_CNT,
                $PARAM_RETRY_CNT,
                $PARAM_FAILED_DENY_CNT,
                $PARAM_FAILED_RETRY_CNT,
                $PARAM_FAILED_CNT,
                $PARAM_RES_MMSSUC_CNT,
                $PARAM_RES_MMSFAIL_CNT)
   ON DUPLICATE KEY UPDATE update_dt = now(),
                           reg_cnt = $PARAM_REG_CNT,
                           read_cnt = $PARAM_READ_CNT,
                           wait_cnt = $PARAM_WAIT_CNT,
                           ing_mms_cnt = $PARAM_ING_MMS_CNT,
                           ing_dm_cnt = $PARAM_ING_DM_CNT,
                           ing_deny_cnt = $PARAM_ING_DENY_CNT,
                           disp_mms_cnt = $PARAM_DISP_MMS_CNT,
                           disp_dm_cnt = $PARAM_DISP_DM_CNT,
                           disp_deny_cnt = $PARAM_DISP_DENY_CNT,
                           done_app_cnt = $PARAM_DONE_APP_CNT,
                           done_mms_cnt = $PARAM_DONE_MMS_CNT,
                           done_dm_cnt = $PARAM_DONE_DM_CNT,
                           done_deny_cnt = $PARAM_DONE_DENY_CNT,
                           retry_mms_dm_cnt = $PARAM_RETRY_CNT,
                           failed_deny_cnt = $PARAM_FAILED_DENY_CNT,
                           failed_retry_cnt = $PARAM_FAILED_RETRY_CNT,
                           failed_cnt = $PARAM_FAILED_CNT,
                           result_mms_suc_cnt = $PARAM_RES_MMSSUC_CNT,
                           result_mms_fail_cnt = $PARAM_RES_MMSFAIL_CNT;
END;
/******************************************************************************
**		Name: PROCEDURE SP_AUTH
**		Desc: 본인인증 후 수신한 CI값을 통해 회원 가입 여부 확인.
**				회원인 경우, pcode 와 pcode_idx 리턴.
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AUTH`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_AUTH`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DECLARE pcode       VARCHAR(37);
   DECLARE pcode_idx   BIGINT(20);

   SET pcode = NULL;
   SET pcode_idx = 0;

   SELECT p_code, p_code_idx
     INTO pcode, pcode_idx
     FROM TBL_EPOSTMEMBER
    WHERE ci = $PARAM_CI AND use_yn = 'Y';

   SELECT pcode, pcode_idx;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_DEL_ADDR
**		Desc: 회원이 선택한 주소 삭제
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_DEL_ADDR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_DEL_ADDR`(IN `$PARAM_PCODE_IDX`   BIGINT(20),
                                      IN `$PARAM_IDX`         BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DELETE FROM TBL_MEMBERADDRESS
         WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_DEL_MYAGENCYADDRESS
**		Desc: 내 기관 편지 수령 주소 삭제
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_DEL_MYAGENCYADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_DEL_MYAGENCYADDRESS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_MYAGENCY
      SET myaddr_idx = NULL
    WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_DEL_MYDOCUMENT2
**		Desc: 문서 삭제(2 : 연도별 파티셔닝)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_DEL_MYDOCUMENT2`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_DEL_MYDOCUMENT2`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DOC_IDX`     BIGINT(20),
   IN `$PARAM_YEAR`        VARCHAR(4) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SET @strQuery :=
          concat("UPDATE TBL_DOCUMENTS PARTITION(p",
                 $PARAM_YEAR,
                 ")
                              SET deleted_YN = 'Y', deleted_dt = now()
                              WHERE p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 " AND idx = ",
                 $PARAM_DOC_IDX,
                 ";");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;

   UPDATE TBL_PUSHMSG
      SET push_YN = 'D'
    WHERE p_code_idx = $PARAM_PCODE_IDX AND doc_idx = $PARAM_DOC_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_ADDRESS
**		Desc: pcode에 해당하는 주소 검색
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_ADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_ADDRESS`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT *
     FROM TBL_MEMBERADDRESS
    WHERE p_code = $PARAM_PCODE;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_AGENCY
**		Desc: 현재 등록된 모든 기관 검색
**				$PARAM_OPTION = 'VALIDITY'이면 계약기간이 유효한 기관만 검색
**				$PARAM_OPTION = 'ALL'이면 전체 기관
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_AGENCY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_AGENCY`(
   IN `$PARAM_OPTION`   VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   IF $PARAM_OPTION = 'VALIDITY'
   THEN
      SELECT idx AS agency_id,
             org_code,
             org_name,
             dept_code,
             dept_name,
             icon_link,
             channel,
             org,
             multiplexing_fg
        FROM TBL_AGENCY
       WHERE validity_dt >= now();
   ELSEIF $PARAM_OPTION = 'ALL'
   THEN
      SELECT idx AS agency_id,
             org_code,
             org_name,
             dept_code,
             dept_name,
             icon_link,
             channel,
             org,
             multiplexing_fg
        FROM TBL_AGENCY;
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_CAR
**		Desc: pcode에 해당하는 차량 검색
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_CAR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_CAR`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT *
     FROM TBL_MEMBERCAR
    WHERE p_code = $PARAM_PCODE;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MEMBER
**		Desc: 조건으로 회원 정보 검색
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MEMBER`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_MEMBER`(
   IN `$PARAM_PCODE`       VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   IF $PARAM_PCODE IS NOT NULL
   THEN
      SELECT p_code_idx, password
        FROM TBL_EPOSTMEMBER
       WHERE p_code = $PARAM_PCODE;
   ELSEIF $PARAM_PCODE_IDX IS NOT NULL
   THEN
      SELECT *
        FROM TBL_EPOSTMEMBER
       WHERE p_code_idx = $PARAM_PCODE_IDX;
   ELSEIF $PARAM_CI IS NOT NULL
   THEN
      SELECT p_code_idx, use_yn
        FROM TBL_EPOSTMEMBER
       WHERE ci = $PARAM_CI;
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MYAGENCY
**		Desc: pcodeIdx로 내 기관 검색
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MYAGENCY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_MYAGENCY`(IN `$PARAM_PCODE_IDX` BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT A.idx AS agency_id,
          A.org_code,
          A.org_name,
          A.dept_code,
          A.dept_name,
          A.icon_link,
          M.use_YN,
          M.disp_class,
          M.myaddr_idx
     FROM (SELECT idx,
                  org_code,
                  org_name,
                  dept_code,
                  dept_name,
                  icon_link
             FROM TBL_AGENCY
            WHERE validity_dt >= now()) A
          INNER JOIN (SELECT agency_id,
                             disp_class,
                             myaddr_idx,
                             use_YN
                        FROM TBL_MYAGENCY
                       WHERE p_code_idx = $PARAM_PCODE_IDX) M
             ON A.idx = M.agency_id;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MYDOCUMENT2
**		Desc: pcodeIdx로 내 문서 검색(2 : 연도별 파티셔닝)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MYDOCUMENT2`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_MYDOCUMENT2`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_YEAR`        VARCHAR(4) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   #CALL SP_IF_GET_MYDOCUMENT2( 1, '2020' );
   SET @strQuery :=
          concat("(SELECT D.agency_id,
           D.nosql_index,
           D.idx,
           D.p_code_idx,
           D.doc_id,
           D.doc_title,
           D.doc_path,
           D.reg_dt,
           D.disp_dt,
           D.read_dt,
           D.doc_content,
           D.dn_yn,
           P.idx AS pay_idx,
           P.pay_amount,
           P.pay_pub_dt,
           P.pay_duedate_dt,
           P.pay_dt
      FROM (SELECT idx,
                   p_code,
                   p_code_idx,
                   agency_id,
                   nosql_index,
                   doc_id,
                   doc_title,
                   doc_content,
                   doc_path,
                   reg_dt,
                   disp_dt,
                   read_dt,
                   dn_yn
              FROM TBL_DOCUMENTS PARTITION(p",
                 $PARAM_YEAR,
                 ")
              WHERE p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 "
                   AND deleted_YN = 'N') D
           INNER JOIN (SELECT idx,
           		      doc_idx,
                              p_code,
                              agency_id,
                              doc_id,
                              pay_amount,
                              pay_pub_dt,
                              pay_duedate_dt,
                              pay_dt
                        FROM TBL_PAYMENT PARTITION(p",
                 $PARAM_YEAR,
                 ")
                        WHERE p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 ") P
              ON D.idx = P.doc_idx)
   UNION
   (SELECT agency_id,
           nosql_index,
           idx,
           p_code_idx,
           doc_id,
           doc_title,
           doc_path,
           reg_dt,
           disp_dt,
           read_dt,
           doc_content,
           dn_yn,
           -1,
           NULL,
           NULL,
           NULL,
           NULL
      FROM TBL_DOCUMENTS PARTITION(p",
                 $PARAM_YEAR,
                 ")
      WHERE     p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 "
           AND deleted_YN = 'N'
           AND idx NOT IN (SELECT doc_idx
                            FROM TBL_PAYMENT PARTITION(p",
                 $PARAM_YEAR,
                 ")
                            WHERE p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 "));");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
#SET @i := concat("SELECT p_code_idx FROM ", $PARAM_TABLE,  " ;");
#PREPARE stmt FROM @i;
#execute stmt;


END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MYMESSAGE2
**		Desc: pcodeIdx로 내 푸시메세지 검색(2 : 연도별 파티셔닝)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MYMESSAGE2`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_MYMESSAGE2`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DATETIME`    DATETIME)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   #CALL SP_IF_GET_MYMESSAGE( 1, '2020-01-01' );
   SET @strQuery :=
          concat(
             "SELECT 
                U.idx, 
                U.agency_id, 
                U.nosql_index, 
                U.doc_id, 
                U.title, 
                U.content,
                U.push_dt 
              FROM
                ( SELECT idx, agency_id, p_code_idx, doc_idx, nosql_index, doc_id, title, content, push_dt, msg_class 
                    FROM TBL_PUSHMSG
                    WHERE p_code_idx = ",
             $PARAM_PCODE_IDX,
             " AND push_YN = 'Y' AND push_dt >= '",
             $PARAM_DATETIME,
             "' ) U
                  INNER JOIN
                ( SELECT idx FROM TBL_DOCUMENTS WHERE p_code_idx = ",
             $PARAM_PCODE_IDX,
             " AND read_dt IS NULL ) D
              ON U.doc_idx = D.idx
              ORDER BY U.push_dt DESC
              LIMIT 100;");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MYPAYMENT
**		Desc: pcodeIdx로 내 결제 기록 조회
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MYPAYMENT`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_MYPAYMENT`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_YEAR`        BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # 작년 날짜 구하기 (2019년 이전 파티션 없음)
   DECLARE $last_year   BIGINT(10);
   SET $last_year = $PARAM_YEAR - 1;

   # 납부 목록 가져오기 (작년 1월 내역부터)
   SET @strQuery :=
          concat("(SELECT P.p_code, D.idx AS doc_idx, D.doc_title, P.pay_dt, P.pay_amount
	FROM TBL_PAYMENT PARTITION (p",
                 $PARAM_YEAR,
                 ", p",
                 $last_year,
                 ") P 
	INNER JOIN TBL_DOCUMENTS PARTITION (p",
                 $PARAM_YEAR,
                 ", p",
                 $last_year,
                 ") D
	ON D.idx = P.doc_idx 
	AND P.p_code_idx = ",
                 $PARAM_PCODE_IDX,
                 " AND P.pay_dt IS NOT NULL
	AND D.deleted_YN = 'N');");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_PCODE
**		Desc: CI 로 PCODE 조회
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_PCODE`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_GET_PCODE`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   SELECT p_code, ci
     FROM TBL_PCODE
    WHERE ci = $PARAM_CI;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_LOGIN
**		Desc: hp, password, pcode를 통해 올바른 회원 로그인인지 확인
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_LOGIN`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_LOGIN`(
   IN `$PARAM_HP`           VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE`        VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`     VARCHAR(256) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUSH_UUID`    VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP_UUID`      VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP_DESC`      VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_USER_AGENT`   VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # error code / error msg
   DECLARE errorCode    INT(4);
   DECLARE errorMsg     VARCHAR(64);

   # search count
   DECLARE hp_cnt       INT(4);
   DECLARE pcode_cnt    INT(4);

   # return values
   DECLARE pcode_idx    BIGINT(11);
   DECLARE pcode        VARCHAR(64);
   DECLARE push_class   VARCHAR(64);
   DECLARE pwd          VARCHAR(128);
   DECLARE uname        VARCHAR(16);
   DECLARE fail_cnt     INT(4);

   # inactive account check
   DECLARE last_login   DATETIME;

   IF    $PARAM_HP = 'null'
      OR $PARAM_PCODE = 'null'
      OR $PARAM_PASSWORD = 'null'
      OR $PARAM_PUSH_UUID = 'null'
      OR $PARAM_HP_UUID = 'null'
      OR $PARAM_HP_DESC = 'null'
      OR $PARAM_USER_AGENT = 'null'
   THEN
      SET errorCode = 10004;
      SET errorMsg = 'request param cannot be null.';

      SELECT errorCode, errorMsg;
   ELSE
      SET errorMsg = NULL;

      SET hp_cnt =
             (SELECT COUNT(*)
                FROM TBL_EPOSTMEMBER
               WHERE hp = $PARAM_HP AND use_yn = 'Y');
      SET pcode_cnt =
             (SELECT COUNT(*)
                FROM TBL_EPOSTMEMBER
               WHERE p_code = $PARAM_PCODE AND use_yn = 'Y');

      SELECT p_code,
             password,
             name,
             login_fail_count,
             last_login_dt
        INTO pcode,
             pwd,
             uname,
             fail_cnt,
             last_login
        FROM TBL_EPOSTMEMBER
       WHERE hp = $PARAM_HP AND use_yn = 'Y';

      SELECT idx, push_permit_class
        INTO pcode_idx, push_class
        FROM TBL_PCODE
       WHERE p_code = pcode;

      # if, cannot find phone number, return error
      IF hp_cnt <= 0
      THEN
         # if !hp, but pcode, need identify
         IF pcode_cnt <= 0
         THEN
            SET errorCode = 10009;
            SET errorMsg = 'Not found hp';

            SELECT errorCode, errorMsg;
         ELSE
            SET errorCode = 10010;
            SET errorMsg = 'hp incorrect. identify.';

            SELECT errorCode, errorMsg;
         END IF;
      # if, find more than 2 phone numbers, return error
      ELSEIF hp_cnt >= 2
      THEN
         SET errorCode = 10011;
         SET errorMsg = 'Hp is duplicated. identify';

         SELECT errorCode, errorMsg;
      # if, null pcode or different pcode, return error
      ELSEIF pcode = NULL
      THEN
         SET errorCode = 10012;
         SET errorMsg = 'Pcode is null. identify';
         SET fail_cnt = fail_cnt + 1;

         # update error count. +1
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      # 2020.04.07 if, inactive account, return error
      ELSEIF (SELECT TIMESTAMPDIFF(MONTH, last_login, now()) > 2)
      THEN
         SET errorCode = 10016;
         SET errorMsg = 'Inactive account. Identify';
         SET fail_cnt = fail_cnt + 1;

         # update error count. +1
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      # if, locked id(fail_cnt >= 5), return error
      ELSEIF fail_cnt >= 5
      THEN
         SET errorCode = 10013;
         SET errorMsg = 'Locked ID. identify';

         SELECT errorCode, errorMsg, fail_cnt;
      # if, null pcode or different pcode, return error
      ELSEIF pcode <> $PARAM_PCODE
      THEN
         SET errorCode = 10014;
         SET errorMsg = 'Pcode not matched. Identify';
         SET fail_cnt = fail_cnt + 1;

         # update error count. +1
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      # if, different password, return error
      ELSEIF pwd <> $PARAM_PASSWORD
      THEN
         SET errorCode = 10015;
         SET errorMsg = 'Wrong password';
         SET fail_cnt = fail_cnt + 1;

         # update error count. +1
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         # insert login history.

         SELECT errorCode, errorMsg, fail_cnt;
      # if success, save
      ELSE
         SET errorCode = 200;
         SET errorMsg = 'OK';
         SET fail_cnt = 0;

         # update error count. 0
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = 0, last_login_dt = now()
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         # update push token
         UPDATE TBL_PCODE
            SET push_token = $PARAM_PUSH_UUID
          WHERE idx = pcode_idx;

         SELECT errorCode,
                errorMsg,
                pcode_idx,
                pcode,
                push_class,
                uname,
                fail_cnt;
      END IF;
   END IF;

   INSERT INTO TBL_LOGIN_HISTORY(p_code_index,
                                 login_dt,
                                 error_code,
                                 error_msg,
                                 login_hp_uuid,
                                 login_hp_desc,
                                 user_agent)
        VALUES (pcode_idx,
                now(),
                errorCode,
                errorMsg,
                $PARAM_HP_UUID,
                $PARAM_HP_DESC,
                $PARAM_USER_AGENT);
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_ADDRESS
**		Desc: 새로운 주소 등록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_ADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_ADDRESS`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_PCODE`         TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_RECVYN`        CHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ZIPCODE`       TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR1`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR2`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # DM 오발송 방지를 위한 ADDR2값 설정
   IF CHAR_LENGTH($PARAM_ADDR2) = 0
   THEN
      SET $PARAM_ADDR2 = '    ';
   END IF;

   IF $PARAM_RECVYN = 'Y'
   THEN
      # 기본 수령지 N 설정
      UPDATE TBL_MEMBERADDRESS
         SET recv_yn = 'N'
       WHERE recv_yn = 'Y' AND p_code_idx = $PARAM_PCODE_IDX;
   END IF;

   # 새로운 주소 등록
   INSERT INTO TBL_MEMBERADDRESS(p_code_idx,
                                 p_code,
                                 type,
                                 recv_yn,
                                 zipcode,
                                 addr1,
                                 addr2,
                                 description)
        VALUES ($PARAM_PCODE_IDX,
                $PARAM_PCODE,
                "P",
                $PARAM_RECVYN,
                $PARAM_ZIPCODE,
                $PARAM_ADDR1,
                $PARAM_ADDR2,
                $PARAM_DESCRIPTION);
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_ADDRPICKUP
**		Desc: 새로운 기본주소지 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_ADDRPICKUP`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_ADDRPICKUP`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_IDX`         BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # 기본 수령지 N 설정
   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = 'N'
    WHERE recv_yn = 'Y' AND p_code_idx = $PARAM_PCODE_IDX;

   # 기본 수령지 변경
   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = 'Y'
    WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_AFTER_AUTH
**		Desc: 로그인 실패 후 본인인증에 성공하여, 로그인 실패 횟수 0으로 초기화하고 마지막 로그인 날짜 현재로 업데이트 함
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_AFTER_AUTH`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_AFTER_AUTH`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # error code / error msg
   DECLARE errorCode   INT(4);
   DECLARE errorMsg    VARCHAR(64);
   DECLARE cnt         INT(4);

   SELECT COUNT(*)
     INTO cnt
     FROM TBL_EPOSTMEMBER
    WHERE p_code = $PARAM_PCODE AND ci = $PARAM_CI;

   IF cnt = 0
   THEN
      SET errorCode = '10022';
      SET errorMsg = 'pcode / ci not matched. identify again.';
   ELSE
      UPDATE TBL_EPOSTMEMBER
         SET login_fail_count = 0, last_login_dt = now()
       WHERE p_code = $PARAM_PCODE AND ci = $PARAM_CI;

      SET errorCode = '200';
      SET errorMsg = 'SUCCESS';
   END IF;

   SELECT errorCode, errorMsg;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CAR
**		Desc: 새로운 차량 등록
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CAR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CAR`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_PCODE`         VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CARNUM`        TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   INSERT INTO TBL_MEMBERCAR(p_code_idx,
                             p_code,
                             car_num,
                             description,
                             column_6,
                             column_7)
        VALUES ($PARAM_PCODE_IDX,
                $PARAM_PCODE,
                $PARAM_CARNUM,
                $PARAM_DESCRIPTION,
                NULL,
                NULL);
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGEADDRESS
**		Desc: 주소 정보 수정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGEADDRESS`(
   IN `$PARAM_IDX`           BIGINT(20),
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_ZIPCODE`       TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_RECVYN`        CHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR1`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR2`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # DM 오발송 방지를 위한 ADDR2값 설정
   IF CHAR_LENGTH($PARAM_ADDR2) = 0
   THEN
      SET $PARAM_ADDR2 = '    ';
   END IF;

   # 기본주소지 설정
   IF $PARAM_RECVYN = 'y'
   THEN
      UPDATE TBL_MEMBERADDRESS
         SET recv_yn = 'n'
       WHERE     recv_yn = 'y'
             AND p_code_idx = $PARAM_PCODE_IDX
             AND idx != $PARAM_IDX;
   END IF;

   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = $PARAM_RECVYN,
          zipcode = $PARAM_ZIPCODE,
          addr1 = $PARAM_ADDR1,
          addr2 = $PARAM_ADDR2,
          description = $PARAM_DESCRIPTION
    WHERE idx = $PARAM_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGECAR
**		Desc: 차량 정보 수정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGECAR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGECAR`(
   IN `$PARAM_IDX`           BIGINT(20),
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_CARNUM`        TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_MEMBERCAR
      SET car_num = $PARAM_CARNUM, description = $PARAM_DESCRIPTION
    WHERE idx = $PARAM_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGEMYAGENCY
**		Desc: 내 기관 삭제/추가(데이터를 완전히 삭제하진 않음, 플래그 변경)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEMYAGENCY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGEMYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_USEYN`       VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_MYAGENCY
      SET use_YN = $PARAM_USEYN
    WHERE p_code_idx = $PARAM_PCODE_IDX AND agency_id = $PARAM_AGENCY_ID;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGEMYAGENCYRECVCLASS
**		Desc: 내 기관 문서 수령 방법 변경
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEMYAGENCYRECVCLASS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGEMYAGENCYRECVCLASS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_CLASS`       VARCHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   IF $PARAM_CLASS = '0' OR $PARAM_CLASS = '1' OR $PARAM_CLASS = '4'
   THEN
      UPDATE TBL_MYAGENCY
         SET disp_class = $PARAM_CLASS
       WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;

      INSERT INTO TBL_CH_MYAGENCYDISP_HISTORY(p_code_idx,
                                              agency_id,
                                              edit_dt,
                                              acttion_fg)
           VALUES ($PARAM_PCODE_IDX,
                   $PARAM_AGENCY_ID,
                   now(),
                   $PARAM_CLASS);
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGEPASS
**		Desc: 비밀번호 변경
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEPASS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGEPASS`(
   IN `$PARAM_PASSWORD`    VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_EPOSTMEMBER
      SET password = $PARAM_PASSWORD, modify_dt = now(), login_fail_count = 0
    WHERE p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGEPHONE
**		Desc: 휴대폰 번호 변경
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEPHONE`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGEPHONE`(
   IN `$PARAM_HP`          VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DECLARE other_pcodeIdx   BIGINT(20);
   DECLARE other_userHp     VARCHAR(128);

   # variables for other user.
   SET other_pcodeIdx = NULL;
   SET other_userHp = NULL;

   # Check already have same phone number or not.
   SELECT p_code_idx, hp
     INTO other_pcodeIdx, other_userHp
     FROM TBL_EPOSTMEMBER
    WHERE hp = $PARAM_HP AND p_code_idx <> $PARAM_PCODE_IDX;

   # if there is same number, change it to null.
   IF other_userHp IS NOT NULL
   THEN
      UPDATE TBL_EPOSTMEMBER
         SET hp = NULL
       WHERE p_code_idx = other_pcodeIdx;
   END IF;

   # update phone number.
   UPDATE TBL_EPOSTMEMBER
      SET hp = $PARAM_HP
    WHERE ci = $PARAM_CI AND p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CHANGE_EMAIL
**		Desc: 이메일 변경
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGE_EMAIL`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_CHANGE_EMAIL`(
   IN `$PARAM_EMAIL`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_EPOSTMEMBER
      SET email = $PARAM_EMAIL, modify_dt = now()
    WHERE p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS
**		Desc: 내 기관별 알림 설정 변경될 때마다 히스토리 저장
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_ACTION_DT`   VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   INSERT INTO TBL_CH_MYAGENCYDISP_HISTORY(p_code_idx,
                                           agency_id,
                                           edit_dt,
                                           acttion_fg)
        VALUES ($PARAM_PCODE_IDX,
                $PARAM_AGENCY_ID,
                now(),
                $PARAM_ACTION_DT);
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_MESSAGEPERMISSION
**		Desc: 푸시메세지 알림 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_MESSAGEPERMISSION`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_MESSAGEPERMISSION`(
   IN `$PARAM_PCODE_IDX`    BIGINT(20),
   IN `$PARAM_PERMISSION`   INT(11))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_PCODE
      SET push_permit_class = $PARAM_PERMISSION
    WHERE idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_MYAGENCY
**		Desc: 내 기관 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_MYAGENCY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_MYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_PCODE`       VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DECLARE myagency_cnt   INT(4);
   DECLARE addr_idx       BIGINT(20);

   # find default address
   SELECT idx
     INTO addr_idx
     FROM TBL_MEMBERADDRESS
    WHERE p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';

   # find my agency count
   SET myagency_cnt =
          (SELECT COUNT(*)
             FROM TBL_MYAGENCY
            WHERE     p_code_idx = $PARAM_PCODE_IDX
                  AND agency_id = $PARAM_AGENCY_ID);

   IF myagency_cnt = 0
   THEN
      INSERT INTO TBL_MYAGENCY(p_code_idx,
                               p_code,
                               agency_id,
                               use_YN,
                               disp_class,
                               myaddr_idx)
           VALUES ($PARAM_PCODE_IDX,
                   $PARAM_PCODE,
                   $PARAM_AGENCY_ID,
                   'Y',
                   '1',
                   addr_idx);
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_MYAGENCYADDRESS
**		Desc: 내 기관 문서 수령 주소지 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_MYAGENCYADDRESS`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_MYAGENCYADDRESS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_ADDR_IDX`    BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_MYAGENCY
      SET myaddr_idx = $PARAM_ADDR_IDX
    WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_PCODE
**		Desc: CI만 가지고 있는 비회원의 PCODE 생성
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_PCODE`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_PCODE`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DECLARE cnt   INT(10);

   SET cnt =
          (SELECT COUNT(*)
             FROM TBL_PCODE
            WHERE ci = $PARAM_CI);

   #PCODE 테이블에 해당 ci 값을 가진 데이터가 없는 경우
   IF cnt = 0
   THEN
      INSERT INTO TBL_PCODE(reg_dt,
                            p_code,
                            ci,
                            member_yn,
                            disp_class,
                            push_token,
                            push_permit_class)
           VALUES (now(),
                   $PARAM_PCODE,
                   $PARAM_CI,
                   'N',
                   NULL,
                   NULL,
                   NULL);
   #PCODE 테이블에 해당 ci 값을 가진 데이터가 있는 경우
   ELSE
      UPDATE TBL_PCODE
         SET p_code = $PARAM_PCODE
       WHERE ci = $PARAM_CI;
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_PUSHTOKEN
**		Desc: 내 기관별 푸시토큰 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_PUSHTOKEN`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_PUSHTOKEN`(
   IN `$PARAM_PUSH_TOKEN`   VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`    BIGINT(20))
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   #내 기관별 수신 종류 설정
   UPDATE TBL_PCODE
      SET push_token = $PARAM_PUSH_TOKEN
    WHERE idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNOUT
**		Desc: 탈퇴 처리 (주소, 차량, 푸시, 내기관, 문서 삭제)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNOUT`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_SIGNOUT`(IN `$PARAM_PCODE_IDX` BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_EPOSTMEMBER
      SET use_yn = "N", withdr_dt = now()
    WHERE p_code_idx = $PARAM_PCODE_IDX;

   DELETE FROM TBL_MEMBERADDRESS
         WHERE p_code_idx = $PARAM_PCODE_IDX;

   DELETE FROM TBL_MEMBERCAR
         WHERE p_code_idx = $PARAM_PCODE_IDX;

   DELETE FROM TBL_PUSHMSG
         WHERE p_code_idx = $PARAM_PCODE_IDX;

   DELETE FROM TBL_MYAGENCY
         WHERE p_code_idx = $PARAM_PCODE_IDX;

   UPDATE TBL_DOCUMENTS
      SET deleted_YN = 'Y'
    WHERE p_code_idx = $PARAM_PCODE_IDX;

   UPDATE TBL_PCODE
      SET disp_class = '2'
    WHERE idx = $PARAM_PCODE_IDX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP
**		Desc: 일반 회원 가입
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_SIGNUP`(
   IN `$PARAM_PCODE`      VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TYPE`       CHAR(1) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP`         VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_NAME`       VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUBKEY`     VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_UUID`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_BIRTH`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_EMAIL`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_GENDER`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MKT_OK`     VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # 마케팅 수신 동의 설정
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   # pcode 데이터 생성
   INSERT TBL_PCODE(reg_dt,
                    p_code,
                    ci,
                    mi,
                    member_yn,
                    disp_class,
                    push_token,
                    push_permit_class)
   VALUES (now(),
           $PARAM_PCODE,
           $PARAM_CI,
           $PARAM_MI,
           'Y',
           '1',
           NULL,
           7);

   SELECT idx, p_code
     INTO @p_code_idx, @p_code
     FROM TBL_PCODE
    WHERE p_code = $PARAM_PCODE;

   # member 데이터 생성
   INSERT TBL_EPOSTMEMBER(p_code_idx,
                          p_code,
                          type,
                          entry_dt,
                          withdr_dt,
                          modify_dt,
                          use_yn,
                          hp,
                          name,
                          ci,
                          password,
                          pincode,
                          pub_key,
                          uuid,
                          birth,
                          email,
                          login_fail_count,
                          last_login_dt,
                          gender,
                          marketing_ok)
   VALUES (@p_code_idx,
           $PARAM_PCODE,
           $PARAM_TYPE,
           now(),
           NULL,
           NULL,
           'Y',
           $PARAM_HP,
           $PARAM_NAME,
           $PARAM_CI,
           $PARAM_PASSWORD,
           NULL,
           $PARAM_PUBKEY,
           $PARAM_UUID,
           $PARAM_BIRTH,
           $PARAM_EMAIL,
           0,
           NULL,
           $PARAM_GENDER,
           OK_TIME);

   SELECT @p_code_idx AS p_code_idx, @p_code AS p_code;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP2
**		Desc: 문서 발송 내역이 있는 비회원의 회원 가입
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP2`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_SIGNUP2`(
   IN `$PARAM_PCODE`      VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TYPE`       CHAR(1) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP`         VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_NAME`       VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUBKEY`     VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_UUID`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_BIRTH`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_EMAIL`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_GENDER`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MKT_OK`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # 마케팅 수신 동의 설정
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   # APP 수령 설정, 회원가입 여부 변경
   UPDATE TBL_PCODE
      SET member_yn = 'Y',
          disp_class = '1',
          push_permit_class = 7,
          mi = $PARAM_MI
    WHERE p_code = $PARAM_PCODE;

   SELECT idx, p_code
     INTO @p_code_idx, @p_code
     FROM `TBL_PCODE`
    WHERE p_code = $PARAM_PCODE;

   INSERT TBL_EPOSTMEMBER(p_code_idx,
                          p_code,
                          type,
                          entry_dt,
                          withdr_dt,
                          modify_dt,
                          use_yn,
                          hp,
                          name,
                          ci,
                          password,
                          pincode,
                          pub_key,
                          uuid,
                          birth,
                          email,
                          login_fail_count,
                          last_login_dt,
                          gender,
                          marketing_ok)
   VALUES (@p_code_idx,
           $PARAM_PCODE,
           $PARAM_TYPE,
           now(),
           NULL,
           NULL,
           'Y',
           $PARAM_HP,
           $PARAM_NAME,
           $PARAM_CI,
           $PARAM_PASSWORD,
           NULL,
           $PARAM_PUBKEY,
           $PARAM_UUID,
           $PARAM_BIRTH,
           $PARAM_EMAIL,
           0,
           NULL,
           $PARAM_GENDER,
           OK_TIME);

   SELECT @p_code_idx AS p_code_idx, @p_code AS p_code;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP3
**		Desc: 탈퇴 회원의 회원가입처리
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP3`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_SET_SIGNUP3`(
   IN `$PARAM_PCODE`      VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TYPE`       CHAR(1) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP`         VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_NAME`       VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_EMAIL`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUBKEY`     VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_UUID`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MKT_OK`     VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   #마케팅 수신 동의 설정
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   # 탈퇴 회원 수령 방법을 다시 1(APP)로 설정
   UPDATE TBL_PCODE
      SET disp_class = '1', push_permit_class = 7
    WHERE p_code = $PARAM_PCODE;

   # 새로 입력한 정보를 기존 정보에 업데이트 함.
   UPDATE TBL_EPOSTMEMBER
      SET use_yn = 'Y',
          type = $PARAM_TYPE,
          hp = $PARAM_HP,
          name = $PARAM_NAME,
          password = $PARAM_PASSWORD,
          email = $PARAM_EMAIL,
          pub_key = $PARAM_PUBKEY,
          uuid = $PARAM_UUID,
          entry_dt = now(),
          marketing_ok = OK_TIME
    WHERE p_code = $PARAM_PCODE;

   # 회원 pcode, pcodeidx 정보 리턴
   SELECT idx AS p_code_idx, p_code AS p_code
     FROM TBL_PCODE
    WHERE p_code = $PARAM_PCODE;
END;
/******************************************************************************
**		Name: PROCEDURE SP_PAY_READY
**		Desc: 결제 준비 작업
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_PAY_READY`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_PAY_READY`(
   IN `$PARAM_CI`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`    BIGINT(20),
   IN `$PARAM_PAY_AMOUNT`   BIGINT(20),
   IN `$PARAM_PAY_IDX`      BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DECLARE errorCode   INT(10);
   DECLARE errorMsg    VARCHAR(128);

   # checking variables
   DECLARE user_chk    INT(10);
   DECLARE pay_chk     BIGINT(20);
   DECLARE payamount   BIGINT(20);


   # result variables
   DECLARE s_name      VARCHAR(50);
   DECLARE s_email     VARCHAR(128);
   DECLARE s_birth     VARCHAR(128);
   DECLARE s_hp        VARCHAR(11);
   DECLARE s_gender    VARCHAR(2);

   # ci, pcodeidx 일치 여부 확인
   SET user_chk =
          (SELECT COUNT(*)
             FROM TBL_EPOSTMEMBER
            WHERE ci = $PARAM_CI AND p_code_idx = $PARAM_PCODE_IDX);

   # 불일치
   IF user_chk = 0
   THEN
      SET errorCode = 10031;
      SET errorMsg = 'pcodeidx and ci not matched.';

      SELECT errorCode, errorMsg;
   # 일치
   ELSE
      # 결제 금액 일치 여부 확인
      SELECT COUNT(*), pay_amount
        INTO pay_chk, payamount
        FROM TBL_PAYMENT
       WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_PAY_IDX;

      # 유저 불일치
      IF pay_chk = 0
      THEN
         SET errorCode = 10032;
         SET errorMsg = 'There is no payment data. check params.';

         SELECT errorCode, errorMsg;
      # 금액 불일치
      ELSEIF $PARAM_PAY_AMOUNT <> payamount
      THEN
         SET errorCode = 10033;
         SET errorMsg = 'pay amount not matched. check params.';

         SELECT errorCode, errorMsg;
      # 일치
      ELSE
         # 결제에 필요한 사용자 정보 가져오기 ( sndOrdername, sndEmail, birthdate, mobile, gender )
         SELECT name,
                email,
                REPLACE(birth, '-', ''),
                hp,
                gender
           INTO s_name,
                s_email,
                s_birth,
                s_hp,
                s_gender
           FROM TBL_EPOSTMEMBER
          WHERE p_code_idx = $PARAM_PCODE_IDX;

         SET errorCode = 200;
         SET errorMsg = 'SUCCESS';

         SELECT errorCode,
                errorMsg,
                s_name AS name,
                s_email AS email,
                s_birth AS birth,
                s_hp AS hp,
                s_gender AS gender;
      END IF;
   END IF;
END;
/******************************************************************************
**		Name: PROCEDURE SP_PAY_RESULT
**		Desc: 결제 결과 업데이트
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_PAY_RESULT`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_PAY_RESULT`(
   IN `$PARAM_PAY_IDX`     BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_ERR_CODE`    INT(11),
   IN `$PARAM_ERR_MSG`     VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_INFO`    VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_KIND`    VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_INST`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   # if success, update payment
   IF $PARAM_ERR_CODE = 200
   THEN
      UPDATE TBL_PAYMENT
         SET pay_dt = now(),
             pay_kind = $PARAM_PAY_KIND,
             pay_inst = $PARAM_PAY_INST
       WHERE idx = $PARAM_PAY_IDX AND p_code_idx = $PARAM_PCODE_IDX;
   END IF;

   # update payment history
   INSERT INTO TBL_PAYMENT_HISTORY(pay_idx,
                                   p_code_idx,
                                   done_dt,
                                   error_code,
                                   error_msg,
                                   pay_info)
        VALUES ($PARAM_PAY_IDX,
                $PARAM_PCODE_IDX,
                now(),
                $PARAM_ERR_CODE,
                $PARAM_ERR_MSG,
                $PARAM_PAY_INFO);
END;
/******************************************************************************
**		Name: PROCEDURE SP_PS_GET_MESSAGE
**		Desc: 푸시 메시지 조회
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_PS_GET_MESSAGE`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_PS_GET_MESSAGE` ()
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   /*
  SELECT U.idx, U.org_code, U.dept_code, P.p_code, U.title, U.content, U.nosql_index, U.doc_id, P.push_token, U.msg_class, P.push_class_fg, U.multiplexing_fg
   FROM ( SELECT idx, org_code, dept_code, p_code_idx, title, content, nosql_index, doc_id, msg_class, multiplexing_fg FROM TBL_PUSHMSG WHERE push_YN = 'N' ) U
   INNER JOIN
   ( SELECT idx, p_code, push_token, push_class_fg FROM TBL_PCODE ) P
   ON U.p_code_idx = P.idx
   LIMIT 1000;
   */

   SELECT idx,
          push_token,
          org_code,
          dept_code,
          title,
          content,
          nosql_index,
          doc_id,
          multiplexing_fg
     FROM TBL_PUSHMSG
    WHERE push_YN = 'N'
    LIMIT 1000;
END;
/******************************************************************************
**		Name: PROCEDURE SP_PS_SET_DISPATCHED
**		Desc: 푸시 설정(Y:수신, N:발송안함, D:거절)
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_PS_SET_DISPATCHED`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_PS_SET_DISPATCHED`(
   IN `$PARAM_INDEX`   BIGINT(20),
   IN `$PARAM_YN`      VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_PUSHMSG
      SET push_YN = $PARAM_YN, push_dt = now()
    WHERE idx = $PARAM_INDEX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_PS_SET_ERROR
**		Desc: 분석서버에서 발송 실패 시 업데이트 -> 구글로부터 push 발송결과 값( 0: 성공 0외: 실패) 과 에러 메시지 설정
**
**		Author: HAEIN LEE
**		Date: 2020-07-01
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_PS_SET_ERROR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_PS_SET_ERROR`(
   IN `$PARAM_INDEX`    BIGINT(20),
   IN `$PARAM_RESULT`   INT(11),
   IN `$PARAM_ERROR`    VARCHAR(256) CHARACTER SET utf8 COLLATE utf8_general_ci)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   UPDATE TBL_PUSHMSG
      SET result = $PARAM_RESULT, error_string = $PARAM_ERROR
    WHERE idx = $PARAM_INDEX;
END;
/******************************************************************************
**		Name: PROCEDURE SP_IF_DEL_CAR
**		Desc: 회원 차량 정보 삭제
**
**		Author: HAEIN LEE
**		Date: 2020-07-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_DEL_CAR`;

CREATE DEFINER = `embuser` @`%`
PROCEDURE `EMAILBOX`.`SP_IF_DEL_CAR`(IN `$PARAM_PCODE_IDX`   BIGINT(20),
                                     IN `$PARAM_CAR_IDX`     BIGINT(20))
   LANGUAGE SQL
   DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
BEGIN
   DELETE FROM `TBL_MEMBERCAR`
         WHERE idx = $PARAM_CAR_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END;






















































































