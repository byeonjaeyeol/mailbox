# 전제조건
# member_yn = 'N' 탈퇴회원 혹은 임시회원(잠시정보만) 
# member_yn = 'Y' 회원
# 추후 데이터베이스 업데이트가 필요하다.

select e.p_code, e.entry_dt, e.withdr_dt, p.member_yn from TBL_EPOSTMEMBER as e JOIN TBL_PCODE as p ON e.p_code = p.p_code where e.entry_dt < withdr_dt; 

DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBERFROMCI_V2`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMCI_V2`(
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
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
   SET @member_id_class := '1';

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
            #MEMBER 검색 실패 오류 (정확한 이해불가로 남겨둠)
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
         END IF;
      ELSE
         #MEMBER 아닐때 원래 코드는 SET @disp_class = '2'; 현재는 SMS/MMS 지원불가.
         SET @error := '-3';
         SET @disp_class := '-1';
         SET @error_code := '3103';
         SET @error_string :='탈퇴회원 혹은 임시 p_code로 member가 아닙니다.';
      END IF;
   END IF;

   
	IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_CI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
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


DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBERFROMMI_V2`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMMI_V2`(
   IN `$PARAM_MI`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
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
   SET @cnt := 0;
   SET @member_id_class := '3';

   SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_MI;

   #동일한 mi를 가진 회원들이 존재할 경우
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   #동일한 mi를 가진 회원들이 존재하지 않는 경우
   ELSE
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

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         #p_code 검색 실패
         SET @error := '-1';
         SET @disp_class := '-1';
         SET @error_code := '3101';
         SET @error_string := 'p_code가 등록 되어 있지 않습니다';
      
      ELSE
         IF @member_yn = 'Y' THEN
           SELECT disp_class
           INTO @disp_class
           FROM TBL_MYAGENCY
           WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = @p_code_idx;

            IF @disp_class IS NULL OR LENGTH(@disp_class) = 0 THEN
               SET @disp_class = @default_disp_class;
            END IF;

            IF @disp_class IS NULL OR LENGTH(@disp_class) = 0 THEN
               #MEMBER 검색 실패 오류 (정확한 이해불가로 남겨둠)
               SET @error := '-2';
               SET @disp_class := '-1';
               SET @error_code := '3102';
               SET @error_string := 'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
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
       VALUES ( $PARAM_MI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
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


DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_AN_GET_MEMBERFROMPI_V2`;

DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMPI_V2`(
   IN `$PARAM_PI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`	VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
   )
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
   SET @member_id_class := '2';

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
      SET @p_code := $PARAM_PI;
      
      IF @p_code IS NULL OR LENGTH(@p_code) = 0
      THEN
         SET @error := '-5';
         SET @disp_class := '-1';
         SET @error_code := '3105';
         SET @error_string := 'MI/PI/CI가 메지시에 존재하지 않습니다.';
      ELSE
         SET @error := '-1';
         SET @disp_class := '-1';
         SET @error_code := '3101';
         SET @error_string := 'p_code가 등록 되어 있지 않습니다';
      END IF;
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
            #MEMBER 검색 실패 오류 (정확한 이해불가로 남겨둠)
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
         END IF;
      ELSE
         #MEMBER 아닐때 원래 코드는 SET @disp_class = '2'; 현재는 SMS/MMS 지원불가.
         SET @error := '-3';
         SET @disp_class := '-1';
         SET @error_code := '3103';
         SET @error_string :='탈퇴회원 혹은 임시 p_code로 member가 아닙니다.';
      END IF;
   END IF;

   
	IF @error <> '0' THEN
     #에러 처리
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_PI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
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
