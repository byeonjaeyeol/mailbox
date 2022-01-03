# 전제조건
# tbl_agency에 등록되어 있는 기관들에 동의 여부를 확인한다.
# 추후 데이터베이스 업데이트가 필요하다.

DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_MYDOCUMENT`;

DELIMITER ;;
create definer = embuser@`%` procedure `SP_IF_SET_MYDOCUMENT`(IN $PARAM_PCODE_IDX bigint, IN $PARAM_PCODE varchar(64),
                                                         IN $PARAM_AGENCY_ID bigint) deterministic
BEGIN
   DECLARE mydocument_cnt   INT(4);
   DECLARE i INT(4);
   DECLARE agencyIdx INT(4);

   # find my document count
   SET mydocument_cnt =
          (SELECT COUNT(*)
             FROM TBL_MYDOCUMENT MM
            WHERE MM.p_code_idx = $PARAM_PCODE_IDX);

   IF mydocument_cnt = 0
   THEN
       SET i = (SELECT COUNT(*)
             FROM TBL_AGENCY) - 1;
       WHILE i >= 0 DO
          SET agencyIdx = (SELECT idx
                 FROM TBL_AGENCY
                 ORDER BY idx
                 LIMIT i, 1);

INSERT INTO TBL_MYDOCUMENT(p_code_idx,
                           p_code,
                           agency_id)
VALUES ($PARAM_PCODE_IDX,
        $PARAM_PCODE,
        agencyIdx);
SET i = i - 1;
END WHILE;
END IF;

END;
DELIMITER ;



DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_GET_MYAGENCYDOCUMENT`;

DELIMITER ;;
create definer = embuser@`%` procedure `SP_IF_GET_MYAGENCYDOCUMENT`(IN $PARAM_PCODE_IDX bigint)
BEGIN
SELECT A.idx AS agency_id,
       A.org_code,
       A.org_name,
       A.dept_code,
       A.dept_name,
       A.icon_link,
       M.document_id,
       M.disp_class,
       M.use_yn,
       M.collect_yn
FROM (SELECT idx,
             org_code,
             org_name,
             dept_code,
             dept_name,
             icon_link
      FROM TBL_AGENCY
      WHERE validity_dt >= now()) A
         INNER JOIN (select MM.idx as document_id, MM.agency_id, MM.use_yn, MM.collect_YN, MM.disp_class
                     from TBL_MYDOCUMENT MM
                     where MM.p_code_idx = $PARAM_PCODE_IDX) M
                    ON A.idx = M.agency_id;
END;
DELIMITER ;



DROP PROCEDURE IF EXISTS `EMAILBOX`.`SP_IF_SET_CHANGEMYDOCUMENT`;

DELIMITER ;;
create definer = embuser@`%` procedure `SP_IF_SET_CHANGEMYDOCUMENT`(IN $PARAM_PCODE_IDX bigint, IN $PARAM_DOCUMENT_ID bigint,
                                                               IN $PARAM_USEYN varchar(2)) deterministic
BEGIN
UPDATE TBL_MYDOCUMENT
SET use_YN = $PARAM_USEYN
WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_DOCUMENT_ID;
END;
DELIMITER ;
