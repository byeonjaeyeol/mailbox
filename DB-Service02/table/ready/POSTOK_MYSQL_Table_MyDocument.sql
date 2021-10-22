/******************************************************************************
**		Name: TABLE TBL_MYDOCUMENT
**		Desc: 회원이 등록한 내 기관과 서식
**
**		Author: 
**		Date: 2021-10-12
*******************************************************************************/
CREATE TABLE `TBL_MYDOCUMENT`
(
   idx           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
   p_code_idx    BIGINT(20) NULL DEFAULT NULL,
   p_code        VARCHAR(128)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT NULL,
   agency_id     BIGINT(20) NULL DEFAULT NULL,
   template_id   BIGINT(20) NULL DEFAULT NULL,
   `use_YN`      VARCHAR(2)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT 'Y',
   disp_class    VARCHAR(3)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT NULL
                   COMMENT '수령 종류(0: 차단, 1: 모바일고지, 2: 실물고지, 3: 모바일고지-실물고지)',
   `collect_YN`  VARCHAR(2)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NULL
                   DEFAULT 'Y',
   sync_dt       DATETIME(0) NULL DEFAULT NULL,

   PRIMARY KEY(idx)
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;