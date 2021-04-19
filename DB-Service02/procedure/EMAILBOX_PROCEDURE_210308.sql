-- MySQL dump 10.16  Distrib 10.2.8-MariaDB, for Linux (x86_64)
--
-- Host: 10.65.203.109    Database: EMAILBOX
-- ------------------------------------------------------
-- Server version	10.2.8-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'EMAILBOX'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_CLEANUP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_CLEANUP`(IN `$PARAM_COUNT`      INT(11),
                                    IN `$PARAM_VALIDITY`   INT(11))
BEGIN
/*
 DELETE FROM TBL_DOCLIST
  WHERE RegTime < DATE_SUB(NOW(), INTERVAL $PARAM_VALIDITY DAY )
  LIMIT $PARAM_COUNT;
 */
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER`(
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
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
   SET @member_yn := '';                                          #가입 회원 여부 - Y/N
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


   IF @error <> '0'
   THEN
      #에러 처리
      INSERT INTO TBL_FAILED_DISPATCH(ci,
                                      agency_id,
                                      nosql_index,
                                      doc_id,
                                      disp_class,
                                      doc_title,
                                      reg_dt,
                                      error_code,
                                      error_reason)
           VALUES ($PARAM_CI,
                   $PARAM_AGENCY_ID,
                   $PARAM_DOC_INDEX,
                   $PARAM_DOC_ID,
                   @disp_class,
                   $PARAM_TITLE,
                   @now_dt,
                   @error_code,
                   @error_string);
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMCI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMCI`(
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMMI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMMI`(
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
   
   # 동일한 mi를 가진 회원들이 존재할 경우
   IF @cnt > 1 THEN
		SET @error := '-3';
		SET @disp_class := '-1';
		SET @error_code := '3103';
		SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
		
   # 동일한 mi를 가진 회원들이 존재하지 않는 경우
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
				#MEMBER 검색 실패 오류
				SET @error := '-2';
				SET @disp_class := '-1';
				SET @error_code := '3102';
				SET @error_string := 'p_code에 member로 표시 되어 있으나 member talbe에서 검색 되지 않았습니다';
			  END IF;
			  
			ELSE
				SET @disp_class = '2';	
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMPI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMPI`(
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_RECVADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_RECVADDRESS`(
  $PARAM_PCODE_IDX  bigint,
  $PARAM_AGENCY_IDX bigint
)
BEGIN
	
  SET @myaddr_idx := null;
  SET @name := null;
  SET @zipcode := null;
  SET @addr1 := null;
  SET @addr2 := null;
  
  SELECT myaddr_idx INTO @myaddr_idx FROM TBL_MYAGENCY WHERE p_code_idx = $PARAM_PCODE_IDX AND agency_id = $PARAM_AGENCY_IDX AND use_YN = 'Y';
  SELECT name INTO @name FROM TBL_EPOSTMEMBER WHERE p_code_idx = $PARAM_PCODE_IDX;
  
  IF @myaddr_idx IS NULL THEN
    SELECT zipcode, addr1, addr2 INTO @zipcode, @addr1, @addr2 FROM TBL_MEMBERADDRESS WHERE  p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';
  ELSE    
    SELECT zipcode, addr1, addr2 INTO @zipcode, @addr1, @addr2 FROM TBL_MEMBERADDRESS WHERE idx = @myaddr_idx;
    IF @zipcode IS NULL THEN
      SELECT zipcode, addr1, addr2 INTO @zipcode, @addr1, @addr2 FROM TBL_MEMBERADDRESS WHERE  p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';
    END IF;
  END IF;
  
  SELECT @name, @zipcode, @addr1, @addr2;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_TEMPLATECODE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_TEMPLATECODE`(IN `$PARAM_AGENCYID` BIGINT(20))
BEGIN
   SELECT template_code, dn_yn
     FROM TBL_TEMPLATE
    WHERE agency_id = $PARAM_AGENCYID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_VALIDITYAGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_VALIDITYAGENCY`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_REG_DOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_REG_DOCUMENT`(
  $PARAM_PCODE          varchar(37),
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_REG_FAILEDDISPATCH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_REG_FAILEDDISPATCH`(
	IN `$PARAM_MEMBER_ID`     	VARCHAR(128),
	IN `$PARAM_MEMBER_ID_CLASS` VARCHAR(2),
	IN `$PARAM_AGENCY_ID`      BIGINT(20),
	IN `$PARAM_DOC_INDEX`     	VARCHAR(64),
	IN `$PARAM_DOC_ID`        	VARCHAR(64),
	IN `$PARAM_DISP_CLASS`	  	VARCHAR(2),
	IN `$PARAM_TITLE`         	VARCHAR(128),
	IN `$PARAM_REQUEST_ID`     VARCHAR(64),
	IN `$PARAM_ERROR_CODE`    	VARCHAR(6),
	IN `$PARAM_ERROR_STRING`  	VARCHAR(260))
BEGIN
	SET @now_dt := now();
	 
	    INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
	  VALUES ( $PARAM_MEMBER_ID, $PARAM_MEMBER_ID_CLASS, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, $PARAM_DISP_CLASS, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, $PARAM_ERROR_CODE, $PARAM_ERROR_STRING );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_SET_REGISTRATIONNUM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_SET_REGISTRATIONNUM`(
   IN `$PARAM_AGENCY_ID`    BIGINT(20)
   )
BEGIN
	
	SET @error := '0';
	SET @idx := 0;
	SET @end_num := 0;
	SET @current_num := 0;

	SELECT idx, end_num, current_num INTO @idx, @end_num, @current_num FROM TBL_REGISTRATION_NUM WHERE agency_idx = $PARAM_AGENCY_ID AND use_status = 1;

	IF @current_num = 0 THEN
		SET @error := '-1';
	ELSE
		IF @end_num > @current_num THEN
			UPDATE TBL_REGISTRATION_NUM SET current_num = @current_num + 1 WHERE idx = @idx;
		ELSE
			UPDATE TBL_REGISTRATION_NUM SET current_num = @end_num, use_status = 2 WHERE idx = @idx;
			UPDATE TBL_REGISTRATION_NUM SET use_status = 1 WHERE agency_idx = $PARAM_AGENCY_ID AND use_status = 0 ORDER BY idx ASC LIMIT 1;
		END IF;
	END IF;
   
	#return
	SELECT	@error,
			@current_num;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_SET_STAT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_SET_STAT`(
   IN `$PARAM_DATE`              DATE,
   IN `$PARAM_ORG_CODE`          VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DEPT_CODE`         VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_GROUP_BY`          VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_FILENAME`          VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REG_CNT`           INT(11),
   IN `$PARAM_READ_CNT`          INT(11),
   IN `$PARAM_WAIT_CNT`          INT(11),
   IN `$PARAM_ING_MMS_CNT`       INT(11),
   IN `$PARAM_ING_DM_CNT`        INT(11),
   IN `$PARAM_ING_DENY_CNT`      INT(11),
   IN `$PARAM_DISP_MMS_CNT`      INT(11),
   IN `$PARAM_DISP_DM_CNT`       INT(11),
   IN `$PARAM_DISP_DENY_CNT`     INT(11),
   IN `$PARAM_DONE_APP_CNT`      INT(11),
   IN `$PARAM_DONE_MMS_CNT`      INT(11),
   IN `$PARAM_DONE_DM_CNT`       INT(11),
   IN `$PARAM_DONE_DENY_CNT`     INT(11),
   IN `$PARAM_RETRY_CNT`         INT(11),
   IN `$PARAM_FAILED_DENY_CNT`   INT(11),
   IN `$PARAM_FAILED_RETRY_CNT`  INT(11),
   IN `$PARAM_FAILED_CNT`        INT(11),
   IN `$PARAM_RES_MMSSUC_CNT`    INT(11),
   IN `$PARAM_RES_MMSFAIL_CNT`   INT(11))
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
                           retry_mms_dm_cnt =  $PARAM_RETRY_CNT,
                           failed_deny_cnt = $PARAM_FAILED_DENY_CNT,
                           failed_retry_cnt = $PARAM_FAILED_RETRY_CNT,
                           failed_cnt = $PARAM_FAILED_CNT,
                           result_mms_suc_cnt = $PARAM_RES_MMSSUC_CNT,
                           result_mms_fail_cnt = $PARAM_RES_MMSFAIL_CNT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AUTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AUTH`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_ADDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_DEL_ADDR`(IN `$PARAM_PCODE_IDX`   BIGINT(20),
                                     IN `$PARAM_IDX`         BIGINT(20))
BEGIN
   DECLARE default_idx   BIGINT(20);
   SET default_idx = 0;

   DELETE FROM TBL_MEMBERADDRESS
         WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_IDX;

   SELECT idx
     INTO default_idx
     FROM TBL_MEMBERADDRESS
    WHERE p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';

	# 내 기관 수령 주소에 삭제한 주소가 등록된 항목이 있다면, 기본수령지로 수령 주소를 변경해준다.
   UPDATE TBL_MYAGENCY
      SET myaddr_idx = default_idx
    WHERE p_code_idx = $PARAM_PCODE_IDX AND myaddr_idx = $PARAM_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_CAR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_DEL_CAR`(IN `$PARAM_PCODE_IDX`   BIGINT(20),
                                     IN `$PARAM_CAR_IDX`     BIGINT(20))
    DETERMINISTIC
BEGIN
 DELETE FROM `TBL_MEMBERCAR`
         WHERE idx = $PARAM_CAR_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYAGENCYADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_DEL_MYAGENCYADDRESS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
    DETERMINISTIC
BEGIN
   UPDATE TBL_MYAGENCY
      SET myaddr_idx = NULL
    WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYDOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_DEL_MYDOCUMENT`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DOC_IDX`     BIGINT(20))
BEGIN
   UPDATE TBL_DOCUMENTS
      SET deleted_YN = 'Y', deleted_dt = now()
    WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_DOC_IDX;

   UPDATE TBL_PUSHMSG
      SET push_YN = 'D'
    WHERE p_code_idx = $PARAM_PCODE_IDX AND doc_idx = $PARAM_DOC_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYDOCUMENT2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_DEL_MYDOCUMENT2`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DOC_IDX`     BIGINT(20),
   IN `$PARAM_YEAR`        VARCHAR(4)
   )
BEGIN
  
  SET @strQuery := concat( "UPDATE TBL_DOCUMENTS PARTITION(p",$PARAM_YEAR,")
                              SET deleted_YN = 'Y', deleted_dt = now()
                              WHERE p_code_idx = ",$PARAM_PCODE_IDX," AND idx = ",$PARAM_DOC_IDX,";");
                              
  PREPARE stmt FROM @strQuery; 
  execute stmt;

   UPDATE TBL_PUSHMSG
      SET push_YN = 'D'
    WHERE p_code_idx = $PARAM_PCODE_IDX AND doc_idx = $PARAM_DOC_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_ADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_ADDRESS`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT *
     FROM TBL_MEMBERADDRESS
    WHERE p_code = $PARAM_PCODE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_AGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_AGENCY`(
   IN `$PARAM_OPTION`   VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_CAR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_CAR`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT *
     FROM TBL_MEMBERCAR
    WHERE p_code = $PARAM_PCODE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MEMBER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MEMBER`(
   IN `$PARAM_PCODE`       VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYAGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYAGENCY`(IN `$PARAM_PCODE_IDX` BIGINT(20))
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
          INNER JOIN (SELECT agency_id, disp_class, myaddr_idx, use_YN
                        FROM TBL_MYAGENCY
                       WHERE p_code_idx = $PARAM_PCODE_IDX) M
             ON A.idx = M.agency_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT`(IN `$PARAM_PCODE_IDX` BIGINT(20))
BEGIN
   (SELECT D.agency_id,
           D.nosql_index,
           D.idx,
           D.p_code_idx,
           D.doc_id,
           D.doc_title,
           D.doc_path,
           D.disp_dt,
           D.read_dt,
           D.doc_content,
           D.dn_yn,
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
                   disp_dt,
                   read_dt,
                   dn_yn
              FROM TBL_DOCUMENTS
             WHERE     p_code_idx = $PARAM_PCODE_IDX
                   AND disp_class = '1'
                   AND deleted_YN = 'N') D
           INNER JOIN (SELECT doc_idx,
                              p_code,
                              agency_id,
                              doc_id,
                              pay_amount,
                              pay_pub_dt,
                              pay_duedate_dt,
                              pay_dt
                         FROM TBL_PAYMENT
                        WHERE p_code_idx = $PARAM_PCODE_IDX) P
              ON D.idx = P.doc_idx)
   UNION
   (SELECT agency_id,
           nosql_index,
           idx,
           p_code_idx,
           doc_id,
           doc_title,
           doc_path,
           disp_dt,
           read_dt,
           doc_content,
           dn_yn,
           -1,
           NULL,
           NULL,
           NULL
      FROM TBL_DOCUMENTS
     WHERE     p_code_idx = $PARAM_PCODE_IDX
           AND disp_class = '1'
           AND deleted_YN = 'N'
           AND idx NOT IN (SELECT doc_idx
                             FROM TBL_PAYMENT
                            WHERE p_code_idx = $PARAM_PCODE_IDX));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT2`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_STARTDATE`     DATE,
   IN `$PARAM_ENDDATE`       DATE,
   IN `$PARAM_LIMIT_START`   BIGINT(20),
   IN `$PARAM_LIMIT`         BIGINT(20),
   IN `$PARAM_GETCOUNT`      BIGINT(20),
   IN `$PARAM_KEYWORD`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
BEGIN
   DECLARE $P_YEAR       VARCHAR(20);
   DECLARE $YEAR_START   YEAR;
   DECLARE $YEAR_END     YEAR;

   SET $PARAM_ENDDATE = DATE_ADD($PARAM_ENDDATE, INTERVAL 1 DAY);
   SET $YEAR_START = YEAR($PARAM_STARTDATE);
   SET $YEAR_END = YEAR($PARAM_ENDDATE);

   # 2019년 이전 날짜를 검색한 경우
   IF $YEAR_END < '2019'
   THEN
      # 검색 조건 불일치 (2019년 이전 파티션 없음), null 을 리턴하기 위한 빈 쿼리
      SET @strQuery :=
             "SELECT p_code_idx FROM TBL_EPOSTMEMBER WHERE p_code_idx = -1";

      # 문서 개수를 구하는 경우
      IF $PARAM_GETCOUNT = 1
      THEN
         SET @strQuery :=
                CONCAT("SELECT count(*) AS count FROM (", @strQuery, ") A ;");
      ELSE
         SET @strQuery := CONCAT(@strQuery, ";");
      END IF;
   # 검색 조건 enddate 가 2019년 이상인 경우
   ELSE
      # 검색 조건 startdate 가 2019년 이하인 경우 조건을 2019-01-01 ~ $ENDDATE 까지로 변경함.
      IF $YEAR_START < '2019'
      THEN
         SET $YEAR_START = '2019';
         SET $PARAM_STARTDATE = '2019-01-01';
      END IF;


      ## 파티션 조건문 생성
      # 다른 파티션 그룹에서 데이터를 찾아야하는 경우
      IF $YEAR_START <> $YEAR_END
      THEN
         # ex)  p2019, p2020
         SET $P_YEAR =
                concat("p",
                       $YEAR_START,
                       ", p",
                       $YEAR_END);
      # 같은 파티션 그룹에서 데이터를 찾아야하는 경우
      ELSE
         # ex)  p2020
         SET $P_YEAR = concat("p", $YEAR_END);
      END IF;

      #CALL SP_IF_GET_MYMESSAGE( 1, '2020-01-01' );
      SET @strQuery :=
             concat("SELECT D.agency_id,
           D.nosql_index,
           D.idx,
           D.p_code_idx,
           D.doc_id,
           D.doc_title,
           D.doc_path,
           D.reg_dt,
           D.disp_dt,
           D.disp_class,
           D.read_dt,
           D.doc_content,
           D.dn_yn,
		   P.idx AS pay_idx,
           P.pay_amount,
           P.pay_pub_dt,
           P.pay_duedate_dt,
           P.pay_dt
      FROM TBL_DOCUMENTS PARTITION(",
                    $P_YEAR,
                    ") D LEFT OUTER JOIN TBL_PAYMENT PARTITION(",
                    $P_YEAR,
                    ") P ON D.idx = P.doc_idx AND D.p_code_idx = P.p_code_idx
	  WHERE D.p_code_idx = ",
                    $PARAM_PCODE_IDX,
                    " 
                    AND D.reg_dt >= '",
                    $PARAM_STARTDATE,
                    "'
	  AND D.reg_dt < '",
                    $PARAM_ENDDATE,
                    "' 
	  AND D.deleted_YN = 'N' ");

      # 검색 키워드가 존재하는 경우
      IF    $PARAM_KEYWORD IS NOT NULL
         OR $PARAM_KEYWORD <> 'null'
         OR $PARAM_KEYWORD <> ''
      THEN
         SET @strQuery := CONCAT(@strQuery, $PARAM_KEYWORD);
      END IF;

      # 조건에 해당하는 문서 개수를 구하는 경우
      IF $PARAM_GETCOUNT = 1
      THEN
         SET @strQuery :=
                CONCAT("SELECT count(*) AS count FROM (", @strQuery, ") A ;");
      # 조건에 해당하는 문서를 구하는 경우
      ELSE
         SET @strQuery :=
                CONCAT(@strQuery,
                       " ORDER BY D.reg_dt desc, D.idx LIMIT ",
                       $PARAM_LIMIT_START,
                       ", ",
                       $PARAM_LIMIT,
                       " ; ");
      END IF;
   END IF;

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYMESSAGE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYMESSAGE`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DATETIME`    DATETIME)
BEGIN
     SELECT U.idx,
            U.agency_id,
            U.nosql_index,
            U.doc_id,
            U.title,
            U.content,
-- 			(SELECT read_dt
-- 			   FROM TBL_DOCUMENTS
-- 			  WHERE idx = U.doc_idx) AS read_dt,
            U.push_dt
       FROM (SELECT idx,
                    agency_id,
                    p_code_idx,
                    doc_idx,
                    nosql_index,
                    doc_id,
                    title,
                    content,
                    push_dt,
                    msg_class
               FROM TBL_PUSHMSG
              WHERE     p_code_idx = $PARAM_PCODE_IDX
                    AND push_YN = 'Y'
                    AND push_dt >= $PARAM_DATETIME) U
            INNER JOIN (SELECT idx, push_permit_class
                          FROM TBL_PCODE
                         WHERE idx = $PARAM_PCODE_IDX) P
               ON U.p_code_idx = P.idx AND U.msg_class & P.push_permit_class
   ORDER BY U.push_dt DESC
      LIMIT 100;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYMESSAGE2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYMESSAGE2`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_DATETIME`    DATETIME)
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
                    WHERE p_code_idx = ",$PARAM_PCODE_IDX," AND push_YN = 'Y' AND push_dt >= '",$PARAM_DATETIME,"' ) U
                  INNER JOIN
                ( SELECT idx FROM TBL_DOCUMENTS WHERE p_code_idx = ",$PARAM_PCODE_IDX," AND read_dt IS NULL ) D
              ON U.doc_idx = D.idx
              ORDER BY U.push_dt DESC
              LIMIT 100;");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYPAYMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYPAYMENT`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_STARTDATE`     DATE,
   IN `$PARAM_ENDDATE`       DATE,
   IN `$PARAM_LIMIT_START`   BIGINT(20),
   IN `$PARAM_LIMIT`         BIGINT(20),
   IN `$PARAM_GETCOUNT`      BIGINT(20))
BEGIN
   DECLARE $P_YEAR       VARCHAR(20);
   DECLARE $YEAR_START   YEAR;
   DECLARE $YEAR_END     YEAR;

   SET $PARAM_ENDDATE = DATE_ADD($PARAM_ENDDATE, INTERVAL 1 DAY);
   SET $YEAR_START = YEAR($PARAM_STARTDATE);
   SET $YEAR_END = YEAR($PARAM_ENDDATE);

   # 2019년 이전 날짜를 검색한 경우
   IF $YEAR_END < '2019'
   THEN
      # 검색 조건 불일치 (2019년 이전 파티션 없음), null 을 리턴하기 위한 빈 쿼리
      SET @strQuery :=
             "SELECT p_code_idx FROM TBL_EPOSTMEMBER WHERE p_code_idx = -1";

      # 문서 개수를 구하는 경우
      IF $PARAM_GETCOUNT = 1
      THEN
         SET @strQuery :=
                CONCAT("SELECT count(*) AS count FROM (", @strQuery, ") A ;");
      ELSE
         SET @strQuery := CONCAT(@strQuery, ";");
      END IF;
   # 검색 조건 enddate 가 2019년 이상인 경우
   ELSE
      # 검색 조건 startdate 가 2019년 이하인 경우 조건을 2019-01-01 ~ $ENDDATE 까지로 변경함.
      IF $YEAR_START < '2019'
      THEN
         SET $YEAR_START = '2019';
         SET $PARAM_STARTDATE = '2019-01-01';
      END IF;

      ## 파티션 조건문 생성
      # 다른 파티션 그룹에서 데이터를 찾아야하는 경우
      IF $YEAR_START <> $YEAR_END
      THEN
         # ex)  p2019, p2020
         SET $P_YEAR =
                concat("p",
                       $YEAR_START,
                       ", p",
                       $YEAR_END);
      # 같은 파티션 그룹에서 데이터를 찾아야하는 경우
      ELSE
         # ex)  p2020
         SET $P_YEAR = concat("p", $YEAR_END);
      END IF;

      # 쿼리 생성
      SET @strQuery :=
             concat(
                "(SELECT P.p_code, D.idx AS doc_idx, D.doc_title, P.pay_dt, P.pay_kind, P.pay_amount
	FROM TBL_PAYMENT PARTITION (",
                $P_YEAR,
                ") P 
	INNER JOIN TBL_DOCUMENTS PARTITION (",
                $P_YEAR,
                ") D
	ON D.idx = P.doc_idx 
	AND P.p_code_idx = ",
                $PARAM_PCODE_IDX,
                " AND P.pay_dt IS NOT NULL 
	AND D.deleted_YN = 'N' 
	AND P.pay_dt >= '",
                $PARAM_STARTDATE,
                "' 
	AND P.pay_dt < '",
                $PARAM_ENDDATE,
                "')");

      # 조건에 해당하는 문서 개수를 구하는 경우
      IF $PARAM_GETCOUNT = 1
      THEN
         SET @strQuery :=
                CONCAT("SELECT count(*) AS count FROM (", @strQuery, ") A ;");
      # 조건에 해당하는 문서를 구하는 경우
      ELSE
         SET @strQuery :=
                CONCAT(@strQuery,
                       " ORDER BY pay_dt desc, doc_idx LIMIT ",
                       $PARAM_LIMIT_START,
                       ", ",
                       $PARAM_LIMIT,
                       " ; ");
      END IF;
   END IF;

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_PCODE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_PCODE`(
   IN `$PARAM_CI`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   SELECT p_code, ci
     FROM TBL_PCODE
    WHERE ci = $PARAM_CI;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_LOGIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_LOGIN`(
   IN `$PARAM_HP`           VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE`        VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_ADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_ADDRESS`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_PCODE`         TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_RECVYN`        CHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ZIPCODE`       TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR1`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR2`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_ADDRPICKUP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_ADDRPICKUP`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_IDX`         BIGINT(20))
BEGIN
   # 기본 수령지 N 설정
   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = 'N'
    WHERE recv_yn = 'Y' AND p_code_idx = $PARAM_PCODE_IDX;

   # 기본 수령지 변경
   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = 'Y'
    WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_AFTER_AUTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_AFTER_AUTH`(
   IN `$PARAM_PCODE`   VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CAR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CAR`(
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_PCODE`         VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEADDRESS`(
   IN `$PARAM_IDX`           BIGINT(20),
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_ZIPCODE`       TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_RECVYN`        CHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR1`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ADDR2`         VARCHAR(384) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   # DM 오발송 방지를 위한 ADDR2값 설정
   IF CHAR_LENGTH($PARAM_ADDR2) = 0
   THEN
      SET $PARAM_ADDR2 = '    ';
   END IF;

   # 기본주소지 설정
   IF LOWER($PARAM_RECVYN) = 'y'
   THEN
      UPDATE TBL_MEMBERADDRESS
         SET recv_yn = 'N'
       WHERE     recv_yn = 'Y'
             AND p_code_idx = $PARAM_PCODE_IDX
             AND idx != $PARAM_IDX;
   END IF;

   UPDATE TBL_MEMBERADDRESS
      SET recv_yn = UPPER($PARAM_RECVYN),
          zipcode = $PARAM_ZIPCODE,
          addr1 = $PARAM_ADDR1,
          addr2 = $PARAM_ADDR2,
          description = $PARAM_DESCRIPTION
    WHERE idx = $PARAM_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGECAR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGECAR`(
   IN `$PARAM_IDX`           BIGINT(20),
   IN `$PARAM_PCODE_IDX`     BIGINT(20),
   IN `$PARAM_CARNUM`        TINYTEXT CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DESCRIPTION`   VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   UPDATE TBL_MEMBERCAR
      SET car_num = $PARAM_CARNUM, description = $PARAM_DESCRIPTION
    WHERE idx = $PARAM_IDX AND p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEMYAGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEMYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_USEYN`       VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   UPDATE TBL_MYAGENCY
      SET use_YN = $PARAM_USEYN
    WHERE p_code_idx = $PARAM_PCODE_IDX AND agency_id = $PARAM_AGENCY_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEMYAGENCYRECVCLASS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEMYAGENCYRECVCLASS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_CLASS`       VARCHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci)
BEGIN
   IF $PARAM_CLASS = '0' OR $PARAM_CLASS = '1' OR $PARAM_CLASS = '4'
   THEN
      UPDATE TBL_MYAGENCY
         SET disp_class = $PARAM_CLASS
       WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;
       
      INSERT INTO TBL_CH_MYAGENCYDISP_HISTORY( p_code_idx, agency_id, edit_dt, acttion_fg )
        VALUES( $PARAM_PCODE_IDX, $PARAM_AGENCY_ID, now(), $PARAM_CLASS );
   END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEPASS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEPASS`(
   IN `$PARAM_PASSWORD`    VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
    DETERMINISTIC
BEGIN

         UPDATE TBL_EPOSTMEMBER
            SET password = $PARAM_PASSWORD,
                modify_dt = now(),
                login_fail_count = 0
          WHERE p_code_idx = $PARAM_PCODE_IDX;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEPHONE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEPHONE`(
   IN `$PARAM_HP`          VARCHAR(11) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`   BIGINT(20))
    DETERMINISTIC
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

   # if theres same number, change it to null.
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
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGE_EMAIL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGE_EMAIL`(
	IN `$PARAM_EMAIL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
	IN `$PARAM_PCODE_IDX` BIGINT

(20)
)
BEGIN
	UPDATE TBL_EPOSTMEMBER
      SET email = $PARAM_EMAIL, modify_dt = now()
    WHERE p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS`(
$PARAM_PCODE_IDX  BIGINT,
$PARAM_AGENCY_ID  BIGINT,
$PARAM_ACTION_DT  VARCHAR(10)
)
BEGIN

 INSERT INTO TBL_CH_MYAGENCYDISP_HISTORY( p_code_idx, agency_id, edit_dt, acttion_fg )
  VALUES( $PARAM_PCODE_IDX, $PARAM_AGENCY_ID, now(), $PARAM_ACTION_DT );
                            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MESSAGEPERMISSION` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MESSAGEPERMISSION`(
   IN `$PARAM_PCODE_IDX`    BIGINT(20),
   IN `$PARAM_PERMISSION`   INT(11))
BEGIN
   UPDATE TBL_PCODE
      SET push_permit_class = $PARAM_PERMISSION
    WHERE idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MYAGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_PCODE`       VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MYAGENCYADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MYAGENCYADDRESS`(
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_ADDR_IDX`    BIGINT(20))
    DETERMINISTIC
BEGIN
   UPDATE TBL_MYAGENCY
      SET myaddr_idx = $PARAM_ADDR_IDX
    WHERE agency_id = $PARAM_AGENCY_ID AND p_code_idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_PCODE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_PCODE`(
   IN `$PARAM_PCODE`      VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_PUSHTOKEN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_PUSHTOKEN`(
   IN `$PARAM_PUSH_TOKEN`   VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`    BIGINT(20))
BEGIN
   #내 기관별 수신 종류 설정
   UPDATE TBL_PCODE
      SET push_token = $PARAM_PUSH_TOKEN
    WHERE idx = $PARAM_PCODE_IDX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNOUT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNOUT`(IN `$PARAM_PCODE_IDX` BIGINT(20))
    DETERMINISTIC
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNUP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP`(
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNUP2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP2`(
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNUP3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_SIGNUP3`(
   IN `$PARAM_PCODE`      VARCHAR(37) CHARACTER SET utf8 COLLATE utf8_general_ci,
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PAY_READY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_PAY_READY`(
   IN `$PARAM_CI`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PCODE_IDX`    BIGINT(20),
   IN `$PARAM_PAY_AMOUNT`   BIGINT(20),
   IN `$PARAM_PAY_IDX`      BIGINT(20))
    DETERMINISTIC
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PAY_RESULT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_PAY_RESULT`(
   IN `$PARAM_PAY_IDX`     BIGINT(20),
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_ERR_CODE`    INT(11),
   IN `$PARAM_ERR_MSG`     VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_INFO`    VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_KIND`    VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_PAY_INST`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_GET_MESSAGE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_PS_GET_MESSAGE`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_SET_DISPATCHED` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_PS_SET_DISPATCHED`(
   IN `$PARAM_INDEX`   BIGINT(20),
   IN `$PARAM_YN`      VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci)
BEGIN
   UPDATE TBL_PUSHMSG
      SET push_YN = $PARAM_YN, push_dt = now()
    WHERE idx = $PARAM_INDEX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_SET_ERROR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_PS_SET_ERROR`(
   IN `$PARAM_INDEX`    BIGINT(20),
   IN `$PARAM_RESULT`   INT(11),
   IN `$PARAM_ERROR`    VARCHAR(256) CHARACTER SET utf8 COLLATE utf8_general_ci)
BEGIN
   UPDATE TBL_PUSHMSG
      SET result = $PARAM_RESULT, error_string = $PARAM_ERROR
    WHERE idx = $PARAM_INDEX;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_TEST` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_TEST`(IN `$PARAM_PCODE_IDX`   BIGINT(20),
                               IN `$PARAM_DATETIME`    DATETIME)
BEGIN
   #CALL SP_IF_GET_MYMESSAGE( 1, '2020-01-01' );
   SET @strQuery :=
          concat(
             "SELECT D.agency_id,
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
      FROM TBL_DOCUMENTS PARTITION(P2020) D LEFT OUTER JOIN TBL_PAYMENT PARTITION(P2020) P 
	  ON D.idx = P.doc_idx AND D.p_code_idx = P.p_code_idx
	  WHERE D.p_code_idx = 21
	  AND D.reg_dt >= '2020.01.01'
	  AND D.reg_dt < '2020.12.31' 
	  AND D.deleted_YN = 'N'");

   PREPARE stmt FROM @strQuery;

   EXECUTE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-04 16:55:59
