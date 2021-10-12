/******************************************************************************
**		Name: PROCEDURE SP_AN_REG_DOCUMENT
**		Desc: nosql의 문서 분석 후 문서 저장 PCODE 37->128
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_REG_DOCUMENT`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_REG_DOCUMENT`(
  $PARAM_PCODE          varchar(128),
  $PARAM_PCODE_IDX      BIGINT,
  $PARAM_DISP_CLASS     varchar(2),
  $PARAM_DOC_INDEX      varchar(64),
  $PARAM_DOC_ID         varchar(64),
  $PARAM_AGENCY_ID      varchar(20),
  $PARAM_TITLE          varchar(128),
  $PARAM_CONTENT        varchar(1024),
  $PARAM_REQUEST_ID     varchar(64),
  $PARAM_GROUP_BY       varchar(32),
  $PARAM_REG_DT         datetime,
  $PARAM_PAYAMOUNT      BIGINT,
  $PARAM_PAYPUB_DT      date,
  $PARAM_PAYDUE_DT      date,
  $PARAM_TEMPLATE_CODE  varchar(10),
  $PARAM_TEMPLATE_DNYN varchar(2)
  )
BEGIN

  SET @now_dt         := now();
  SET @LastIDX        := -1;
  
  INSERT IGNORE INTO TBL_DOCUMENTS( nosql_index, doc_id, reg_dt, agency_id, p_code, p_code_idx, doc_title, doc_content, disp_class, disp_status, disp_dt, read_dt, doc_download_YN, group_by, request_id, deleted_YN, template_code, dn_yn )
    VALUES ( $PARAM_DOC_INDEX, $PARAM_DOC_ID, $PARAM_REG_DT,  $PARAM_AGENCY_ID, $PARAM_PCODE, $PARAM_PCODE_IDX, $PARAM_TITLE, $PARAM_CONTENT,  $PARAM_DISP_CLASS, '1' ,@now_dt, null, 'N', $PARAM_GROUP_BY, $PARAM_REQUEST_ID, 'N', $PARAM_TEMPLATE_CODE, $PARAM_TEMPLATE_DNYN );

  SELECT  LAST_INSERT_ID() INTO @LastIDX;
  
  IF $PARAM_PAYAMOUNT > -1 AND @LastIDX > 0 THEN
    INSERT INTO TBL_PAYMENT( p_code, p_code_idx, doc_idx, reg_dt, nosql_index, doc_id, agency_id, pay_amount, pay_pub_dt, pay_duedate_dt, pay_dt )
      VALUES( $PARAM_PCODE, $PARAM_PCODE_IDX, @LastIDX, $PARAM_REG_DT, $PARAM_DOC_INDEX,  $PARAM_DOC_ID , $PARAM_AGENCY_ID, $PARAM_PAYAMOUNT, $PARAM_PAYPUB_DT, $PARAM_PAYDUE_DT, null );
  END IF;

  SELECT @LastIDX;

END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_AUTH
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AUTH`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AUTH`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   DECLARE pcode       VARCHAR(128);
   DECLARE pcode_idx   BIGINT(20);

   SET pcode = NULL;
   SET pcode_idx = 0;

   SELECT p_code, p_code_idx
     INTO pcode, pcode_idx
     FROM TBL_EPOSTMEMBER
    WHERE ci = $PARAM_CI AND use_yn = 'Y';

   SELECT pcode, pcode_idx;
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_ADDRESS
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_ADDRESS`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_ADDRESS`(
   IN `$PARAM_PCODE`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT *
     FROM TBL_MEMBERADDRESS
    WHERE p_code = $PARAM_PCODE;
END ;;
DELIMITER ;



/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_CAR
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_CAR`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_CAR`(
   IN `$PARAM_PCODE`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT *
     FROM TBL_MEMBERCAR
    WHERE p_code = $PARAM_PCODE;
END ;;
DELIMITER ;




/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_MEMBER
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MEMBER`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MEMBER`(
   IN `$PARAM_PCODE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;




/******************************************************************************
**		Name: PROCEDURE SP_IF_LOGIN
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_LOGIN`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_LOGIN`(
   IN `$PARAM_HP`           VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`     VARCHAR(256) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUSH_UUID`    VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP_UUID`      VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP_DESC`      VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_USER_AGENT`   VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   # error code / error msg
   DECLARE errorCode    INT(4);
   DECLARE errorMsg     VARCHAR(64);

   # search count
   DECLARE hp_cnt       INT(4);
   DECLARE pcode_cnt    INT(4);

   # return values
   DECLARE pcode_idx    BIGINT(11);
   DECLARE pcode        VARCHAR(128);
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
END ;;
DELIMITER ;



/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_AFTER_AUTH
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_AFTER_AUTH`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_AFTER_AUTH`(
   IN `$PARAM_PCODE`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_CAR
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CAR`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CAR`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_PCODE`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CARNUM`        TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
	IF $PARAM_CARNUM IS NOT NULL OR $PARAM_CARNUM <> 'null'
	THEN
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
   END IF;
END ;;
DELIMITER ;




/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_MYAGENCY
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_MYAGENCY`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_PCODE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20))
    DETERMINISTIC
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
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_PCODE
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_PCODE`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_PCODE`(
   IN `$PARAM_PCODE`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN	
	DECLARE cnt INT(10);
	
	SET cnt = (SELECT COUNT(*) FROM TBL_PCODE
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
END ;;
DELIMITER ;




/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP`(
   IN `$PARAM_PCODE`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
    DETERMINISTIC
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
END ;;
DELIMITER ;




/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP2
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP2`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP2`(
   IN `$PARAM_PCODE`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
    DETERMINISTIC
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
      SET member_yn = 'Y', disp_class = '1', push_permit_class = 7, mi = $PARAM_MI
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
END ;;
DELIMITER ;



/******************************************************************************
**		Name: PROCEDURE SP_IF_SET_SIGNUP3
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_SIGNUP3`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP3`(
   IN `$PARAM_PCODE`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_TYPE`       CHAR(1) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_HP`         VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_NAME`       VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PASSWORD`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_EMAIL`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PUBKEY`     VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_UUID`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_MKT_OK`     VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;


/******************************************************************************
**		Name: PROCEDURE SP_IF_GET_BIRTH
**		Desc: 
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-12
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_BIRTH`;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_BIRTH`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT birth
     FROM TBL_EPOSTMEMBER
    WHERE ci = $PARAM_CI;
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_IF_UPDATE_PIV2
**		Desc: PIv2 일괄 업데이트
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-07
+--------------+---------------------------+-------------+
| TABLE_SCHEMA | TABLE_NAME                | COLUMN_NAME |
+--------------+---------------------------+-------------+
| EMAILBOX     | TBL_DOCUMENTS             | p_code      |
| EMAILBOX     | TBL_EPOSTMEMBER           | p_code      |
| EMAILBOX     | TBL_MYAGENCY              | p_code      |
| EMAILBOX     | TBL_PAYMENT               | p_code      |
| EMAILBOX     | TBL_PCODE                 | p_code      |
+--------------+---------------------------+-------------+
*******************************************************************************/

