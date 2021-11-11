# 전제조건
# member_yn = 'N' 탈퇴회원 혹은 임시회원(잠시정보만) 
# member_yn = 'Y' 회원
# 추후 데이터베이스 업데이트가 필요하다.
# 1: PI / 2: CI / 3. MI

SELECT MAX(idx) FROM TBL_PCODE;

/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBER_V1
**		Desc: TEST CODE
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-20
*******************************************************************************/
CALL SP_AN_GET_MEMBER_V1('1', 'P4c67f6033600536f82e57b01e95c23654b62c13ed70577d2292dab1bc6842a1aKR', '1243', '1234', 16, 'KKK', '12344');
CALL SP_AN_GET_MEMBER_V1('1', 'P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317fb441ce71babcKR', '1243', '1234', 17, 'KKK', '12344');

CALL SP_AN_GET_MEMBER_V2('1', 'P4c67f6033600536f82e57b01e95c23654b62c13ed70577d2292dab1bc6842a1aKR', '1243', '1234', 16, 'KKK', '12344');
CALL SP_AN_GET_MEMBER_V2('1', 'P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317fb441ce71babcKR', '1243', '1234', 17, 'KKK', '12344');
CALL SP_AN_GET_MEMBER_V2('1', 'P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317eb441ce71babXKR', '1243', '1234', 17, 'KKK', '12344');

CALL SP_AN_GET_MEMBER_V3('1', 'P4c67f6033600536f82e57b01e95c23654b62c13ed70577d2292dab1bc6842a1aKR', '1243', '1234', 16, 'KKK', '12344');
CALL SP_AN_GET_MEMBER_V3('1', 'P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317fb441ce71babcKR', '1243', '1234', 17, 'KKK', '12344');
CALL SP_AN_GET_MEMBER_V3('1', 'P211a50f81a40e564c7f5c08847cc99b7ebacbcd895b51138317eb441ce71babXKR', '1243', '1234', 17, 'KKK', '12344');

/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBER_V1
**		Desc: 메시지 분석 
**          <회원>
**          - PCODE O  MEMBER Y  MYDOC Y  -> AnalyzedMatched, TBL_DOCUMENTS
**          - PCODE O  MEMBER Y  MYDOC N  -> AnalyzedDenied, TBL_DOCUMENTS
**          <비회원>
**          - PCODE O  MEMBER N (MYDOC N) -> AnalyzedMissed, TBL_FAILED_DISPATCH
**          - PCODE X (MEMBER N  MYDOC N)-> AnalyzedMissed, TBL_FAILED_DISPATCH
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-20
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBER_V1`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V1`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
BEGIN
   DECLARE MEMBER_PI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '1';
   DECLARE MEMBER_CI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '2';
   DECLARE MEMBER_MI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '3';

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
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   #동일한 mi를 가진 회원들이 존재할 경우. 보통 mi 일때만 발생함.
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   #동일한 mi를 가진 회원들이 존재하지 않는 경우
   ELSE
      IF @member_id_class = MEMBER_PI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE p_code = $PARAM_ID;
      ELSEIF @member_id_class = MEMBER_CI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE ci = $PARAM_ID;
      ELSE 
         #member_id_class = MEMBER_MI
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         #p_code 검색 실패
         IF @member_id IS NULL OR LENGTH(@member_id) = 0 THEN
            SET @error := '-5';
            SET @disp_class := '-1';
            SET @error_code := '3105';
            SET @error_string := 'MI|PI|CI가 메시지에 존재하지 않습니다.';
         ELSE
            SET @error := '-1';
            SET @disp_class := '-1';
            SET @error_code := '3101';
            SET @error_string := 'p_code가 등록 되어 있지 않습니다';
         END IF;
      ELSE
         IF @member_yn = 'Y' THEN
           SELECT disp_class
           INTO @disp_class
           FROM TBL_MYDOCUMENT
           WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx AND use_YN = 'Y';

            IF @disp_class IS NULL OR LENGTH(@disp_class) = 0 THEN
               SET @disp_class = '0';
            END IF;
         ELSE
            #MEMBER 아닐때 원래 코드는 "SET @disp_class = '2';" 현재는 SMS/MMS 지원불가.
            SET @error := '-3';
            SET @disp_class := '-1';
            SET @error_code := '3103';
            SET @error_string :='탈퇴회원 혹은 임시 p_code인 비회원으로 member가 아닙니다.';
         END IF;
      END IF;
   END IF;

   IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

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
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBER_V2
**		Desc: 메시지 분석 
**          <회원>
**          - PCODE O  MEMBER Y  MYDOC Y  -> AnalyzedMatched, TBL_DOCUMENTS
**          - PCODE O  MEMBER Y  MYDOC N  -> AnalyzedDenied, TBL_DOCUMENTS
**          <비회원>
**          - PCODE O  MEMBER N (MYDOC N) -> AnalyzedDenied, TBL_DOCUMENTS
**          - PCODE X (MEMBER N  MYDOC N)-> AnalyzedMissed, TBL_FAILED_DISPATCH
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-20
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBER_V2`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V2`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
BEGIN
   DECLARE MEMBER_PI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '1';
   DECLARE MEMBER_CI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '2';
   DECLARE MEMBER_MI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '3';

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
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   #동일한 mi를 가진 회원들이 존재할 경우. 보통 mi 일때만 발생함.
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   #동일한 mi를 가진 회원들이 존재하지 않는 경우
   ELSE
      IF @member_id_class = MEMBER_PI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE p_code = $PARAM_ID;
      ELSEIF @member_id_class = MEMBER_CI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE ci = $PARAM_ID;
      ELSE 
         #member_id_class = MEMBER_MI
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         #p_code 검색 실패
         IF @member_id IS NULL OR LENGTH(@member_id) = 0 THEN
            SET @error := '-5';
            SET @disp_class := '-1';
            SET @error_code := '3105';
            SET @error_string := 'MI|PI|CI가 메시지에 존재하지 않습니다.';
         ELSE
            SET @error := '-1';
            SET @disp_class := '-1';
            SET @error_code := '3101';
            SET @error_string := 'p_code가 등록 되어 있지 않습니다';
         END IF;
      ELSE
         IF @member_yn = 'Y' THEN
           SELECT disp_class
           INTO @disp_class
           FROM TBL_MYDOCUMENT
           WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx AND use_YN = 'Y';

            IF @disp_class IS NULL OR LENGTH(@disp_class) = 0 THEN
               SET @disp_class = '0';
            END IF;
         ELSE
            SET @disp_class := '0';
         END IF;
      END IF;
   END IF;

   IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

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
END ;;
DELIMITER ;

/******************************************************************************
**		Name: PROCEDURE SP_AN_GET_MEMBER_V3
**		Desc: 메시지 분석 
**          <회원>
**          - PCODE O  MEMBER Y  MYDOC Y  -> AnalyzedMatched, TBL_DOCUMENTS
**          - PCODE O  MEMBER Y  MYDOC N  -> AnalyzedDenied, TBL_DOCUMENTS
**          <비회원>
**          - PCODE O  MEMBER N (MYDOC N) -> AnalyzedDenied, TBL_DOCUMENTS
**          - PCODE X (MEMBER N  MYDOC N) -> AnalyzedMissed, TBL_DOCUMENTS, TBL_PCODE (PI|CI)
**          - PCODE X (MEMBER N  MYDOC N) -> AnalyzedMissed, TBL_FAILED_DISPATCH (MI)
**
**		Author: KYEHYUK AHN
**		Date: 2021-10-20
*******************************************************************************/
DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBER_V3`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V3`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
BEGIN
   DECLARE MEMBER_PI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '1';
   DECLARE MEMBER_CI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '2';
   DECLARE MEMBER_MI VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '3';

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
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   #동일한 mi를 가진 회원들이 존재할 경우. 보통 mi 일때만 발생함.
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   #동일한 mi를 가진 회원들이 존재하지 않는 경우
   ELSE
      IF @member_id_class = MEMBER_PI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE p_code = $PARAM_ID;
      ELSEIF @member_id_class = MEMBER_CI THEN
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE ci = $PARAM_ID;
      ELSE 
         #member_id_class = MEMBER_MI
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         #p_code 검색 실패
         IF @member_id IS NULL OR LENGTH(@member_id) = 0 THEN
            SET @error := '-5';
            SET @disp_class := '-1';
            SET @error_code := '3105';
            SET @error_string := 'MI|PI|CI가 메시지에 존재하지 않습니다.';
         ELSE
            SET @error := '-1';
            SET @disp_class := '-1';
            SET @error_code := '3101';
            SET @error_string := 'p_code가 등록 되어 있지 않습니다';
         END IF;
      ELSE
         IF @member_yn = 'Y' THEN
           SELECT disp_class
           INTO @disp_class
           FROM TBL_MYDOCUMENT
           WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx AND use_YN = 'Y';

            IF @disp_class IS NULL OR LENGTH(@disp_class) = 0 THEN
               SET @disp_class = '0';
            END IF;
         ELSE
            SET @disp_class := '0';
         END IF;
      END IF;
   END IF;

   IF (@error <> '0' AND (@error <> '-1' OR @member_id_class = MEMBER_MI)) THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

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
END ;;
DELIMITER ;
