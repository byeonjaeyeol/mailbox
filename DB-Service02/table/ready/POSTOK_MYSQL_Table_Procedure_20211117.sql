-- MariaDB dump 10.17  Distrib 10.4.6-MariaDB, for osx10.15 (x86_64)
--
-- Host: 211.115.219.40    Database: EMAILBOX
-- ------------------------------------------------------
-- Server version	10.2.8-MariaDB-10.2.8+maria~jessie

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `TBL_AGENCY`
--

DROP TABLE IF EXISTS `TBL_AGENCY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_AGENCY` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(128) DEFAULT NULL,
  `org_code` varchar(10) DEFAULT NULL,
  `org_name` varchar(64) DEFAULT NULL,
  `dept_code` varchar(10) DEFAULT NULL COMMENT 'KT의 기관코드에 해당 됨  ',
  `dept_name` varchar(64) DEFAULT NULL,
  `manager` varchar(32) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `icon_link` varchar(260) DEFAULT NULL,
  `validity_dt` datetime DEFAULT NULL,
  `channel` varchar(20) DEFAULT NULL,
  `org` varchar(20) DEFAULT NULL,
  `multiplexing_fg` int(11) DEFAULT 0 COMMENT '멀티 threading 작업을 위한 플래',
  `stat_trace` smallint(6) DEFAULT 2 COMMENT '통계 자료 추출 범위( 현재 날짜로 부터 설정된 숫자 이전 까지)',
  `rollover_maxage` varchar(4) DEFAULT '30d',
  `rollover_maxdoc` int(11) DEFAULT 0,
  `license_number` varchar(16) DEFAULT '',
  `foundation_day` varchar(16) NOT NULL DEFAULT '' COMMENT '창립일',
  PRIMARY KEY (`idx`),
  KEY `VALIDITY` (`validity_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_AGENCY_USER`
--

DROP TABLE IF EXISTS `TBL_AGENCY_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_AGENCY_USER` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_name` text NOT NULL,
  `dept_name` text NOT NULL,
  `user` text NOT NULL,
  `password` text NOT NULL,
  `salt` text NOT NULL,
  `manager` text NOT NULL,
  `contact` text NOT NULL,
  `email` text NOT NULL,
  `authority` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_BCCHANNEL`
--

DROP TABLE IF EXISTS `TBL_BCCHANNEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_BCCHANNEL` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_BCORG`
--

DROP TABLE IF EXISTS `TBL_BCORG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_BCORG` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `org_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_CALL`
--

DROP TABLE IF EXISTS `TBL_CALL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_CALL` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` int(11) NOT NULL,
  `subject` text NOT NULL,
  `content` text NOT NULL,
  `reg_dt` timestamp NOT NULL DEFAULT current_timestamp(),
  `reg_name` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_CH_MYAGENCYDISP_HISTORY`
--

DROP TABLE IF EXISTS `TBL_CH_MYAGENCYDISP_HISTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_CH_MYAGENCYDISP_HISTORY` (
  `p_code_idx` bigint(20) unsigned NOT NULL,
  `agency_id` bigint(20) NOT NULL,
  `edit_dt` datetime NOT NULL,
  `acttion_fg` varchar(3) NOT NULL DEFAULT '-1' COMMENT 'cr:insert,deny,online,dm',
  KEY `P_CODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`edit_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `p2024` VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_CONNECTION`
--

DROP TABLE IF EXISTS `TBL_CONNECTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_CONNECTION` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` text NOT NULL,
  `user_type` text NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_DOCUMENTS`
--

DROP TABLE IF EXISTS `TBL_DOCUMENTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_DOCUMENTS` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL COMMENT '문서번호 ',
  `reg_dt` datetime NOT NULL COMMENT '접수 시간 ',
  `p_code` varchar(128) NOT NULL,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관일련번호 ',
  `disp_class` varchar(2) DEFAULT NULL COMMENT '발송종류(APP:1, DM:2)',
  `disp_status` varchar(2) DEFAULT NULL COMMENT '발송상태(0: 대기, 1: 발송 ....',
  `disp_dt` datetime DEFAULT NULL COMMENT '발송시간 ',
  `read_dt` datetime DEFAULT NULL COMMENT '열람시',
  `recv_dt` datetime DEFAULT NULL,
  `doc_title` varchar(128) DEFAULT NULL COMMENT '문서 제목 ',
  `doc_content` varchar(1024) DEFAULT NULL COMMENT '문서 내용 ',
  `doc_path` varchar(260) DEFAULT NULL COMMENT 'pdf 파일 경로 ',
  `doc_size` bigint(20) DEFAULT NULL COMMENT 'pdf 파일 크기 ',
  `doc_version` varchar(20) DEFAULT NULL COMMENT '문서 버전 ',
  `doc_download_YN` varchar(2) DEFAULT NULL COMMENT 'pdf 파일 다운로드 여부 ',
  `group_by` varchar(32) DEFAULT NULL COMMENT '그룹으로 검색을 하기 위한 기관에서 관리하는 keyword ',
  `request_id` varchar(64) DEFAULT NULL COMMENT '기관에서 관리 하는 발송요청 id',
  `deleted_YN` varchar(2) DEFAULT NULL COMMENT '삭제 여부(N: 삭제 안됨,  Y: 삭제 됨)',
  `deleted_dt` datetime DEFAULT NULL COMMENT '삭제된 날짜 시간 ',
  `template_code` varchar(10) DEFAULT NULL,
  `dn_yn` varchar(2) DEFAULT 'Y' COMMENT '다운로드 가능 여부 확',
  PRIMARY KEY (`idx`,`reg_dt`),
  UNIQUE KEY `nosql_index` (`reg_dt`,`nosql_index`,`doc_id`),
  KEY `DOCID` (`doc_id`),
  KEY `INDICES` (`nosql_index`),
  KEY `PCODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`reg_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_DOCUMENTS_back`
--

DROP TABLE IF EXISTS `TBL_DOCUMENTS_back`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_DOCUMENTS_back` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL COMMENT '문서번호 ',
  `reg_dt` datetime DEFAULT NULL COMMENT '접수 시간 ',
  `p_code` varchar(100) DEFAULT NULL COMMENT 'P Code',
  `p_code_idx` bigint(20) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관일련번호 ',
  `disp_class` varchar(2) DEFAULT NULL COMMENT '발송종류(APP:1, DM:2)',
  `disp_status` varchar(2) DEFAULT NULL COMMENT '발송상태(0: 대기, 1: 발송 ....',
  `disp_dt` datetime DEFAULT NULL COMMENT '발송시간 ',
  `read_dt` datetime DEFAULT NULL COMMENT '열람시',
  `recv_dt` datetime DEFAULT NULL,
  `doc_title` varchar(128) DEFAULT NULL COMMENT '문서 제목 ',
  `doc_content` varchar(1024) DEFAULT NULL COMMENT '문서 내용 ',
  `doc_path` varchar(260) DEFAULT NULL COMMENT 'pdf 파일 경로 ',
  `doc_size` bigint(20) DEFAULT NULL COMMENT 'pdf 파일 크기 ',
  `doc_version` varchar(20) DEFAULT NULL COMMENT '문서 버전 ',
  `doc_download_YN` varchar(2) DEFAULT NULL COMMENT 'pdf 파일 다운로드 여부 ',
  `group_by` varchar(32) DEFAULT NULL COMMENT '그룹으로 검색을 하기 위한 기관에서 관리하는 keyword ',
  `request_id` varchar(64) DEFAULT NULL COMMENT '기관에서 관리 하는 발송요청 id',
  `deleted_YN` varchar(2) DEFAULT NULL COMMENT '삭제 여부(N: 삭제 안됨,  Y: 삭제 됨)',
  `deleted_dt` datetime DEFAULT NULL COMMENT '삭제된 날짜 시간 ',
  PRIMARY KEY (`idx`),
  UNIQUE KEY `nosql_index` (`nosql_index`,`doc_id`),
  KEY `DOCID` (`doc_id`),
  KEY `INDICES` (`nosql_index`),
  KEY `PCODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_EPOSTMEMBER`
--

DROP TABLE IF EXISTS `TBL_EPOSTMEMBER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_EPOSTMEMBER` (
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(128) CHARACTER SET utf8 NOT NULL,
  `type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entry_dt` datetime DEFAULT NULL,
  `withdr_dt` datetime DEFAULT NULL,
  `modify_dt` datetime DEFAULT NULL,
  `use_yn` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hp` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ci` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pincode` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pub_key` varchar(4096) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uuid` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `login_fail_count` int(11) NOT NULL,
  `last_login_dt` datetime DEFAULT NULL,
  `gender` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '2: female, 1: male',
  `marketing_ok` datetime DEFAULT NULL COMMENT '마케팅 수신 동의 (null : 미동의, time : 동의)',
  PRIMARY KEY (`p_code`),
  UNIQUE KEY `TBL_EPOSTMEMBER_hp_uindex` (`hp`),
  UNIQUE KEY `TBL_EPOSTMEMBER_ci_uindex` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_EPOSTMEMBER_CO`
--

DROP TABLE IF EXISTS `TBL_EPOSTMEMBER_CO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_EPOSTMEMBER_CO` (
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(67) NOT NULL,
  `type` char(1) DEFAULT NULL,
  `entry_dt` datetime DEFAULT NULL,
  `withdr_dt` datetime DEFAULT NULL,
  `modify_dt` datetime DEFAULT NULL,
  `use_yn` varchar(1) DEFAULT NULL,
  `hp` varchar(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `ci` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `pincode` varchar(128) DEFAULT NULL,
  `pub_key` varchar(4096) DEFAULT NULL,
  `uuid` varchar(128) DEFAULT NULL,
  `birth` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `login_fail_count` int(11) NOT NULL,
  `last_login_dt` datetime DEFAULT NULL,
  `gender` varchar(2) NOT NULL COMMENT '2: female, 1: male',
  `marketing_ok` datetime DEFAULT NULL COMMENT '마케팅 수신 동의 (null : 미동의, time : 동의)',
  `COSERVICE` varchar(5) NOT NULL COMMENT 'POST(인터넷우체국)/KOTI(한국교통연구원)/?',
  `ID` varchar(30) NOT NULL COMMENT 'CO SERVICE 회원 ID : EPOST회원ID',
  `MI` varchar(67) NOT NULL COMMENT 'EPOST회원ID',
  `FRGNRYN` varchar(2) NOT NULL COMMENT '(Y:외국인, N:내국인)',
  PRIMARY KEY (`p_code`),
  UNIQUE KEY `TBL_EPOSTMEMBER_ci_uindex` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_FAILED_DISPATCH`
--

DROP TABLE IF EXISTS `TBL_FAILED_DISPATCH`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_FAILED_DISPATCH` (
  `p_seqid` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` varchar(128) DEFAULT NULL COMMENT 'CI or PI or MI',
  `member_id_class` varchar(2) DEFAULT NULL COMMENT 'CI: 1, PI: 2, MI: 3',
  `agency_id` bigint(20) NOT NULL,
  `nosql_index` varchar(64) NOT NULL,
  `doc_id` varchar(64) NOT NULL,
  `disp_class` varchar(2) NOT NULL COMMENT '발송종류(검색실패: -1, MMS: 2, DM: 4)',
  `doc_title` varchar(128) DEFAULT NULL,
  `reg_dt` datetime NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `error_code` varchar(6) NOT NULL,
  `error_reason` varchar(260) DEFAULT NULL,
  PRIMARY KEY (`p_seqid`,`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_FILES`
--

DROP TABLE IF EXISTS `TBL_FILES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_FILES` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` text NOT NULL,
  `origin_filename` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_LOGIN_HISTORY`
--

DROP TABLE IF EXISTS `TBL_LOGIN_HISTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_LOGIN_HISTORY` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `p_code_index` bigint(20) unsigned DEFAULT NULL,
  `login_dt` datetime NOT NULL COMMENT '문서번호 ',
  `error_code` int(11) NOT NULL,
  `error_msg` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_hp_uuid` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '핸드폰 UUID',
  `login_hp_desc` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '핸드폰 기기',
  `user_agent` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'http header agent: 접속시 사용한 user agent ',
  PRIMARY KEY (`idx`,`login_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
 PARTITION BY RANGE (year(`login_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MEMBERADDRESS`
--

DROP TABLE IF EXISTS `TBL_MEMBERADDRESS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MEMBERADDRESS` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` tinytext DEFAULT NULL,
  `type` char(3) DEFAULT NULL,
  `recv_yn` char(3) DEFAULT NULL,
  `zipcode` tinytext DEFAULT NULL,
  `addr1` varchar(384) DEFAULT NULL,
  `addr2` varchar(384) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`idx`),
  KEY `PCODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MEMBERADDRESS_CO`
--

DROP TABLE IF EXISTS `TBL_MEMBERADDRESS_CO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MEMBERADDRESS_CO` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` tinytext DEFAULT NULL,
  `type` char(3) DEFAULT NULL,
  `recv_yn` char(3) DEFAULT NULL,
  `zipcode` tinytext DEFAULT NULL,
  `addr1` varchar(384) DEFAULT NULL,
  `addr2` varchar(384) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MEMBERADDRESS_RENEWAL`
--

DROP TABLE IF EXISTS `TBL_MEMBERADDRESS_RENEWAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MEMBERADDRESS_RENEWAL` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` tinytext DEFAULT NULL,
  `type` char(3) DEFAULT NULL,
  `recv_yn` char(3) DEFAULT NULL,
  `zipcode` tinytext DEFAULT NULL,
  `addr1` varchar(384) DEFAULT NULL,
  `addr2` varchar(384) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `subscr_dt` datetime DEFAULT NULL,
  `withdr_dt` datetime DEFAULT NULL,
  `seq` bigint(10) DEFAULT NULL,
  `status` char(4) DEFAULT 'IDLE' COMMENT 'IDLE/PUSH/OKAY/DENY',
  `push_idx` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MEMBERCAR`
--

DROP TABLE IF EXISTS `TBL_MEMBERCAR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MEMBERCAR` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` tinytext DEFAULT NULL,
  `car_num` tinytext DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `column_6` int(11) DEFAULT NULL,
  `column_7` int(11) DEFAULT NULL,
  PRIMARY KEY (`idx`),
  KEY `PCODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MYAGENCY`
--

DROP TABLE IF EXISTS `TBL_MYAGENCY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MYAGENCY` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(128) NOT NULL,
  `agency_id` bigint(20) DEFAULT NULL,
  `use_YN` varchar(2) DEFAULT 'Y',
  `disp_class` varchar(3) DEFAULT NULL COMMENT '수령 종류(0: 차단, 1: Online, 4: DM)',
  `myaddr_idx` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`idx`),
  KEY `PCODE_IDX` (`p_code_idx`),
  KEY `AGENCYID` (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_MYDOCUMENT`
--

DROP TABLE IF EXISTS `TBL_MYDOCUMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_MYDOCUMENT` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `p_code_idx` bigint(20) DEFAULT NULL COMMENT '회원 고유의 PI IDX',
  `p_code` varchar(128) NOT NULL,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관 아이디',
  `disp_class` varchar(2) DEFAULT 'Y' COMMENT '발송종류(DENY: 0, APP:1, DM:2)',
  `use_YN` varchar(2) DEFAULT NULL COMMENT '내 기관 사용 여부',
  `collect_YN` varchar(2) DEFAULT NULL COMMENT '수집 사용 여부',
  `sync_dt` datetime DEFAULT NULL COMMENT '최근 업데이트 날짜',
  PRIMARY KEY (`idx`),
  KEY `AGENCYID` (`agency_id`),
  KEY `PCODE_IDX` (`p_code_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_NOTICE`
--

DROP TABLE IF EXISTS `TBL_NOTICE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_NOTICE` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` text NOT NULL,
  `content` text NOT NULL,
  `reg_dt` timestamp NOT NULL DEFAULT current_timestamp(),
  `reg_name` text NOT NULL,
  `file` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PAYMENT`
--

DROP TABLE IF EXISTS `TBL_PAYMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PAYMENT` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doc_idx` bigint(20) DEFAULT NULL,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL,
  `reg_dt` datetime NOT NULL COMMENT '접수 시간 ',
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(128) NOT NULL,
  `agency_id` bigint(20) DEFAULT NULL,
  `pay_amount` bigint(20) DEFAULT NULL COMMENT '결제 금액 ',
  `pay_pub_dt` date DEFAULT NULL COMMENT '고지서 발행날짜 ',
  `pay_duedate_dt` date DEFAULT NULL COMMENT '납부 기한 ',
  `pay_dt` datetime DEFAULT NULL COMMENT '납부한 날짜 ',
  `pay_kind` varchar(20) DEFAULT NULL COMMENT '결제 구분: 일반결제(N), 간편카드(C), 간편계좌이체(A)',
  `pay_inst` varchar(64) DEFAULT NULL COMMENT '결제 기관 ',
  PRIMARY KEY (`idx`,`reg_dt`),
  KEY `PCODE_IDX` (`p_code_idx`),
  KEY `DOC_IDX` (`doc_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`reg_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PAYMENT_HISTORY`
--

DROP TABLE IF EXISTS `TBL_PAYMENT_HISTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PAYMENT_HISTORY` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pay_idx` bigint(20) unsigned NOT NULL,
  `p_code_idx` bigint(20) unsigned NOT NULL,
  `done_dt` datetime NOT NULL COMMENT '결제 처리 날짜 ',
  `error_code` int(11) NOT NULL COMMENT '결제 결과 코드',
  `error_msg` varchar(50) NOT NULL COMMENT '결제 결과 메세지',
  `pay_info` varchar(1024) NOT NULL COMMENT '결제 처리 상세정보(json)',
  PRIMARY KEY (`idx`,`done_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`done_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PAYMENT_back`
--

DROP TABLE IF EXISTS `TBL_PAYMENT_back`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PAYMENT_back` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doc_idx` bigint(20) DEFAULT NULL,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `p_code` varchar(37) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL,
  `pay_amount` bigint(20) DEFAULT NULL,
  `pay_pub_dt` date DEFAULT NULL COMMENT '고지서 발행날짜 ',
  `pay_duedate_dt` date DEFAULT NULL COMMENT '납부 기한 ',
  `pay_dt` datetime DEFAULT NULL COMMENT '납부한 날짜 ',
  PRIMARY KEY (`idx`),
  KEY `PCODE_IDX` (`p_code_idx`),
  KEY `DOC_IDX` (`doc_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PCODE`
--

DROP TABLE IF EXISTS `TBL_PCODE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PCODE` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `reg_dt` datetime DEFAULT NULL COMMENT '생성일',
  `p_code` varchar(128) CHARACTER SET utf8 NOT NULL,
  `ci` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mi` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `member_yn` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disp_class` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '우편 수령 방법 선택(1: APP, 4: DM, 0: 차단)',
  `push_token` varchar(4096) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `push_permit_class` int(11) DEFAULT 15 COMMENT '푸쉬 수신 허용 종류  (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트) - 전체 거부:0, 전체 허용: 15,  기본  허용: 2 ',
  PRIMARY KEY (`idx`,`p_code`),
  UNIQUE KEY `TBL_PCODE_ci_uindex` (`ci`),
  UNIQUE KEY `TBL_PCODE_p_code_uindex` (`p_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PCODE_CO`
--

DROP TABLE IF EXISTS `TBL_PCODE_CO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PCODE_CO` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `reg_dt` datetime DEFAULT NULL COMMENT '생성일',
  `p_code` varchar(67) NOT NULL,
  `ci` varchar(128) NOT NULL,
  `mi` varchar(128) DEFAULT NULL,
  `member_yn` varchar(1) NOT NULL,
  `disp_class` varchar(2) DEFAULT '1' COMMENT '우편 수령 방법 선택(1: APP, 4: DM, 0: 차단)',
  `push_token` varchar(4096) DEFAULT NULL,
  `push_permit_class` int(11) DEFAULT 15 COMMENT '푸쉬 수신 허용 종류  (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트) - 전체 거부:0, 전체 허용: 15,  기본  허용: 2 ',
  `birth` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`idx`,`p_code`),
  UNIQUE KEY `TBL_PCODE_p_code_uindex` (`p_code`),
  UNIQUE KEY `TBL_PCODE_ci_uindex` (`ci`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PROOF_OF_DISTRIBUTION`
--

DROP TABLE IF EXISTS `TBL_PROOF_OF_DISTRIBUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PROOF_OF_DISTRIBUTION` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(64) DEFAULT '' COMMENT 'es의 request_id',
  `issue_number` varchar(128) DEFAULT '' COMMENT '발급번호',
  `from_name` varchar(50) DEFAULT '' COMMENT '송신자-이름',
  `from_license_num` varchar(16) DEFAULT '' COMMENT '송신자-식별번호(사업자등록번호)',
  `to_name` varchar(50) DEFAULT '' COMMENT '수신자-이름',
  `to_pi` varchar(37) DEFAULT '' COMMENT '수신자-PI값',
  `send_date` varchar(20) DEFAULT '' COMMENT '송신날짜',
  `recv_date` varchar(20) DEFAULT '' COMMENT '수신날짜',
  `read_date` varchar(20) DEFAULT '' COMMENT '열람일자',
  `doc_title` varchar(128) DEFAULT '' COMMENT '문서제목',
  `doc_hash` varchar(64) DEFAULT '' COMMENT '본문정보값',
  `issue_date` varchar(20) DEFAULT '' COMMENT '증명서 발급일시(최초발급일자)',
  PRIMARY KEY (`idx`),
  UNIQUE KEY `request_id` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PROOF_OF_DISTRIBUTION_LOG`
--

DROP TABLE IF EXISTS `TBL_PROOF_OF_DISTRIBUTION_LOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PROOF_OF_DISTRIBUTION_LOG` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `agency_user` varchar(64) DEFAULT '' COMMENT '발급요청자 관리자포털 계정',
  `issue_datetime` datetime DEFAULT NULL,
  `issue_number` varchar(128) DEFAULT '' COMMENT '발급번호',
  `from_name` varchar(50) DEFAULT '' COMMENT '송신자-이름',
  `from_license_num` varchar(16) DEFAULT '' COMMENT '송신자-식별번호(사업자등록번호)',
  `to_name` varchar(50) DEFAULT '' COMMENT '수신자-이름',
  `to_pi` varchar(37) DEFAULT '' COMMENT '수신자-PI값',
  `send_date` varchar(20) DEFAULT '' COMMENT '송신날짜',
  `recv_date` varchar(20) DEFAULT '' COMMENT '수신날짜',
  `read_date` varchar(20) DEFAULT '' COMMENT '열람일자',
  `doc_title` varchar(128) DEFAULT '' COMMENT '문서제목',
  `doc_hash` varchar(64) DEFAULT '' COMMENT '본문정보값',
  `issue_date` varchar(20) DEFAULT '' COMMENT '증명서 발급일시(최초발급일자)',
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PUSHMSG`
--

DROP TABLE IF EXISTS `TBL_PUSHMSG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PUSHMSG` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `push_token` varchar(4096) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL,
  `org_code` varchar(10) DEFAULT NULL,
  `dept_code` varchar(10) DEFAULT NULL,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `doc_idx` bigint(20) DEFAULT NULL,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL COMMENT 'push message 제목 ',
  `content` varchar(1024) DEFAULT NULL COMMENT 'push message 내용 ',
  `push_YN` varchar(2) DEFAULT 'N' COMMENT 'push 여부(N/Y)',
  `reg_dt` datetime NOT NULL COMMENT '등록 시간 ',
  `push_dt` datetime DEFAULT NULL COMMENT '구글에 푸시 발송 요청한 시간',
  `msg_class` int(11) DEFAULT 2 COMMENT '푸쉬 종류 (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트, 16: 동의 서비스) ',
  `multiplexing_fg` int(11) DEFAULT NULL COMMENT '멀티 쓰레딩을 위한 작업 index ',
  `result` int(11) DEFAULT 0 COMMENT '구글로 부터 push 발송결과 값( 0: 성공 0외: 실패) ',
  `error_string` varchar(256) DEFAULT NULL COMMENT '실패인경우 실패 원인 ',
  PRIMARY KEY (`idx`,`reg_dt`),
  KEY `PCODE_IDX` (`p_code_idx`),
  KEY `PUSH_YN` (`push_YN`),
  KEY `DOC_IDX` (`doc_idx`),
  KEY `PUSH_DT` (`push_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE  COLUMNS(`reg_dt`)
(PARTITION `p202003` VALUES LESS THAN ('2020-04-01 00:00:00') ENGINE = InnoDB,
 PARTITION `p202004` VALUES LESS THAN ('2020-05-01 00:00:00') ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_PUSHMSG_back`
--

DROP TABLE IF EXISTS `TBL_PUSHMSG_back`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_PUSHMSG_back` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `push_token` varchar(4096) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL,
  `org_code` varchar(10) DEFAULT NULL,
  `dept_code` varchar(10) DEFAULT NULL,
  `p_code_idx` bigint(20) DEFAULT NULL,
  `doc_idx` bigint(20) DEFAULT NULL,
  `nosql_index` varchar(64) DEFAULT NULL,
  `doc_id` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL COMMENT 'push message 제목 ',
  `content` varchar(1024) DEFAULT NULL COMMENT 'push message 내용 ',
  `push_YN` varchar(2) DEFAULT 'N' COMMENT 'push 여부(N/Y)',
  `reg_dt` datetime DEFAULT NULL COMMENT '등록 시간 ',
  `push_dt` datetime DEFAULT NULL COMMENT '구글에 푸시 발송 요청한 시간',
  `msg_class` int(11) DEFAULT 2 COMMENT '푸쉬 종류 (비트 연산 - 1: 시스템, 2: 편지, 4: 공지, 8: 이벤트) ',
  `multiplexing_fg` int(11) DEFAULT NULL COMMENT '멀티 쓰레딩을 위한 작업 index ',
  `result` int(11) DEFAULT 0 COMMENT '구글로 부터 push 발송결과 값( 0: 성공 0외: 실패) ',
  `error_string` varchar(256) DEFAULT NULL COMMENT '실패인경우 실패 원인 ',
  PRIMARY KEY (`idx`),
  KEY `PCODE_IDX` (`p_code_idx`),
  KEY `PUSH_YN` (`push_YN`),
  KEY `DOC_IDX` (`doc_idx`),
  KEY `PUSH_DT` (`push_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_REGISTRATION_NUM`
--

DROP TABLE IF EXISTS `TBL_REGISTRATION_NUM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_REGISTRATION_NUM` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `agency_idx` bigint(20) NOT NULL,
  `start_num` bigint(20) NOT NULL,
  `end_num` bigint(20) NOT NULL,
  `current_num` bigint(20) NOT NULL,
  `use_status` int(2) DEFAULT 0,
  `reg_dt` datetime NOT NULL COMMENT '등록 시간',
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_STAT_DISPRESULT`
--

DROP TABLE IF EXISTS `TBL_STAT_DISPRESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_STAT_DISPRESULT` (
  `update_dt` datetime DEFAULT NULL COMMENT '업데이트 또 추가된 시간',
  `reg_dt` date NOT NULL COMMENT '접수된 날',
  `org_code` varchar(10) NOT NULL,
  `dept_code` varchar(10) NOT NULL,
  `group_by` varchar(32) NOT NULL,
  `template` varchar(64) NOT NULL COMMENT '서식 파일 이름(확장자 제외)',
  `reg_cnt` int(11) DEFAULT NULL COMMENT '우편물 접수(등록) 수 ',
  `read_cnt` int(11) DEFAULT NULL COMMENT '열람된 갯',
  `wait_cnt` int(11) DEFAULT NULL COMMENT '발송 대기 ',
  `ing_mms_cnt` int(11) DEFAULT NULL COMMENT '발송처리(요청한) MMS 수 ',
  `ing_dm_cnt` int(11) DEFAULT NULL COMMENT 'DM 발송 요청 ',
  `ing_deny_cnt` int(11) DEFAULT NULL COMMENT 'Deny 되어 발송기관의 정보로 DM 발송 처리',
  `disp_mms_cnt` int(11) DEFAULT NULL COMMENT 'mms 발송 요청 완료 ',
  `disp_dm_cnt` int(11) DEFAULT NULL COMMENT 'DM 발송 요청 처리된 수',
  `disp_deny_cnt` int(11) DEFAULT NULL COMMENT 'Deny 되어 발송기관의 정보로 DM 발송요청 처리된 수',
  `done_app_cnt` int(11) DEFAULT NULL COMMENT '발송 완료한 APP 수 ',
  `done_mms_cnt` int(11) DEFAULT NULL COMMENT '발송 완료 mms 수 ',
  `done_dm_cnt` int(11) DEFAULT NULL COMMENT '발송 요청을 완료한 DM 수 ',
  `done_deny_cnt` int(11) DEFAULT NULL COMMENT 'Deny 되어 발송기관의 정보로 DM 발송 처리 완료',
  `retry_mms_dm_cnt` int(11) DEFAULT NULL COMMENT 'mms 발송 실패로 DM으로 재처리 한 갯수 ',
  `failed_deny_cnt` int(11) DEFAULT NULL COMMENT 'Deny 되어 발송기관의 정보로 DM 발송용 정보가 없어 발송 차단 된 경우',
  `failed_retry_cnt` int(11) DEFAULT NULL COMMENT 'MMS 발송 실패로 DM  발송 요청 작업중 수신자 정보가 없어 발송 요청을 하지 못한 갯수 ',
  `failed_cnt` int(11) DEFAULT NULL COMMENT '등록된 CI 정보가 없음',
  `result_mms_suc_cnt` int(11) DEFAULT NULL COMMENT 'mms 발송 처리 결과 성공한 수 ',
  `result_mms_fail_cnt` int(11) DEFAULT NULL COMMENT 'mms 발송 처리 결과가 실패한 ',
  PRIMARY KEY (`reg_dt`,`org_code`,`dept_code`,`group_by`,`template`),
  KEY `REG_DT` (`reg_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='발송결과 통계 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_STAT_RECVFILE_RESULT`
--

DROP TABLE IF EXISTS `TBL_STAT_RECVFILE_RESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_STAT_RECVFILE_RESULT` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `reg_dt` datetime NOT NULL COMMENT '분석 시간',
  `file_name` varchar(100) NOT NULL,
  `records_num` int(20) NOT NULL,
  `documents_num` int(20) NOT NULL,
  `error_YN` varchar(2) NOT NULL,
  `error_string` varchar(100) DEFAULT NULL,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관일련번호',
  PRIMARY KEY (`idx`,`reg_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`reg_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `p2024` VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_STAT_SENDFILE_RESULT`
--

DROP TABLE IF EXISTS `TBL_STAT_SENDFILE_RESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_STAT_SENDFILE_RESULT` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `reg_dt` datetime NOT NULL COMMENT '전송 시간',
  `file_name` varchar(100) NOT NULL,
  `target_ip` varchar(20) NOT NULL,
  `disp_class` varchar(2) NOT NULL,
  `documents_num` int(20) NOT NULL,
  `success_num` int(20) NOT NULL,
  `failed_num` int(20) NOT NULL,
  `reproc_num` int(20) NOT NULL,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관일련번호',
  PRIMARY KEY (`idx`,`reg_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (year(`reg_dt`))
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `p2024` VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION `pDefault` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_SYSTEM_USER`
--

DROP TABLE IF EXISTS `TBL_SYSTEM_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_SYSTEM_USER` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` text NOT NULL,
  `password` text NOT NULL,
  `salt` text NOT NULL,
  `manager` text NOT NULL,
  `contact` text NOT NULL,
  `email` text NOT NULL,
  `authority` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_TEMPLATE`
--

DROP TABLE IF EXISTS `TBL_TEMPLATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_TEMPLATE` (
  `idx` bigint(20) NOT NULL AUTO_INCREMENT,
  `agency_id` bigint(20) DEFAULT NULL COMMENT '기관+부서 ID ',
  `template_name` varchar(260) DEFAULT NULL COMMENT '템플릿 이름 ',
  `template_code` varchar(10) DEFAULT NULL COMMENT '서식 코드 ',
  `file_name` varchar(260) DEFAULT NULL COMMENT '파일 이름 ( 통계 검색 조건 이므로 발송 Data의 템플릿 파일이름과 동일하게 해야 함) ',
  `reg_dt` datetime DEFAULT NULL COMMENT '등록 일자 ',
  `dn_yn` varchar(2) DEFAULT 'Y',
  `upload_dt` datetime DEFAULT NULL COMMENT '업로드 일자',
  `app_yn` varchar(2) DEFAULT NULL COMMENT '앱 저장 여부',
  PRIMARY KEY (`idx`),
  UNIQUE KEY `template_code` (`template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TBL_ZIPCODE_bak`
--

DROP TABLE IF EXISTS `TBL_ZIPCODE_bak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TBL_ZIPCODE_bak` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `구역번호` varchar(5) DEFAULT NULL,
  `시도` varchar(20) DEFAULT NULL,
  `시도영문` varchar(40) DEFAULT NULL,
  `시군구` varchar(20) DEFAULT NULL,
  `시군구영문` varchar(40) DEFAULT NULL,
  `읍면` varchar(20) DEFAULT NULL,
  `읍면영문` varchar(40) DEFAULT NULL,
  `도로명코드` varchar(12) DEFAULT NULL,
  `도로명` varchar(80) DEFAULT NULL,
  `도로명영문` varchar(80) DEFAULT NULL,
  `지하여부` varchar(1) DEFAULT NULL,
  `건물번호본번` int(11) DEFAULT NULL,
  `건물번호부번` int(11) DEFAULT NULL,
  `건물관리번호` varchar(25) DEFAULT NULL,
  `다량배달처명` varchar(40) DEFAULT NULL,
  `시군구용건물명` varchar(200) DEFAULT NULL,
  `법정동코드` varchar(10) DEFAULT NULL,
  `법정동명` varchar(20) DEFAULT NULL,
  `리명` varchar(20) DEFAULT NULL,
  `행정동명` varchar(40) DEFAULT NULL,
  `산여부` varchar(1) DEFAULT NULL,
  `지번본번` int(11) DEFAULT NULL,
  `읍면동일련번호` varchar(2) DEFAULT NULL,
  `지번부번` int(11) DEFAULT NULL,
  `구우편번호` varchar(6) DEFAULT NULL,
  `우편번호일련번호` varchar(3) DEFAULT NULL,
  `검색용` text DEFAULT NULL,
  PRIMARY KEY (`no`),
  KEY `zipcode_idx3` (`시도`),
  KEY `zipcode_idx1` (`구역번호`),
  KEY `zipcode_idx2` (`도로명코드`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'EMAILBOX'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_CLEANUP` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBER` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMCI` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMCI_V2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMCI_V2`(
   IN `$PARAM_CI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
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
            
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
         END IF;
      ELSE
         
         SET @error := '-3';
         SET @disp_class := '-1';
         SET @error_code := '3103';
         SET @error_string :='탈퇴회원 혹은 임시 p_code로 member가 아닙니다.';
      END IF;
   END IF;

   
IF @error <> '0' THEN
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_CI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
END IF;
   

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMMI_V2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMMI_V2`(
   IN `$PARAM_MI`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();
   SET @cnt := 0;
   SET @member_id_class := '3';

   SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_MI;

   
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   
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
               
               SET @error := '-2';
               SET @disp_class := '-1';
               SET @error_code := '3102';
               SET @error_string := 'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
            END IF;
         ELSE
            
            SET @error := '-3';
            SET @disp_class := '-1';
            SET @error_code := '3103';
            SET @error_string :='탈퇴회원 혹은 임시 p_code인 비회원으로 member가 아닙니다.';
         END IF;
      END IF;
   END IF;

   IF @error <> '0' THEN
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_MI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBERFROMPI_V2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBERFROMPI_V2`(
   IN `$PARAM_PI`          VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`   VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`      VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20),
   IN `$PARAM_TITLE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
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
            
            SET @error := '-2';
            SET @disp_class := '-1';
            SET @error_code := '3102';
            SET @error_string :=
                   'p_code에 member로 표시 되어 있으나 member table에서 검색 되지 않았습니다';
         END IF;
      ELSE
         
         SET @error := '-3';
         SET @disp_class := '-1';
         SET @error_code := '3103';
         SET @error_string :='탈퇴회원 혹은 임시 p_code로 member가 아닙니다.';
      END IF;
   END IF;

   
IF @error <> '0' THEN
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_PI, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
END IF;
   

   
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBER_V1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V1`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   
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
         
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         
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
            
            SET @error := '-3';
            SET @disp_class := '-1';
            SET @error_code := '3103';
            SET @error_string :='탈퇴회원 혹은 임시 p_code인 비회원으로 member가 아닙니다.';
         END IF;
      END IF;
   END IF;

   IF @error <> '0' THEN
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

   
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBER_V2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V2`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   
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
         
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         
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
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

   
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_MEMBER_V3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_AN_GET_MEMBER_V3`(
   IN `$PARAM_ID_CLASS`     VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_ID`           VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_INDEX`    VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_DOC_ID`       VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`    BIGINT(20),
   IN `$PARAM_TITLE`        VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_REQUEST_ID`VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci
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
   SET @member_yn := 'N';                                      
   SET @push_token := '';
   SET @push_permit_class := '';
   SET @now_dt := now();
   SET @cnt := 0;
   SET @member_id_class := $PARAM_ID_CLASS;
   SET @member_id := $PARAM_ID;

   IF @member_id_class = MEMBER_MI THEN
      SELECT COUNT(*) INTO @cnt FROM TBL_PCODE WHERE mi = $PARAM_ID;  
   END IF;

   
   IF @cnt > 1 THEN
      SET @error := '-4';
      SET @disp_class := '-1';
      SET @error_code := '3104';
      SET @error_string := 'mi에 p_code가 중복으로 매칭되는 member들이 존재 합니다';
   
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
         
         SELECT idx, p_code, member_yn, disp_class, push_token, push_permit_class
         INTO @p_code_idx, @p_code, @member_yn, @default_disp_class, @push_token, @push_permit_class
         FROM TBL_PCODE
         WHERE mi = $PARAM_ID;
      END IF;

      IF @p_code IS NULL OR LENGTH(@p_code) = 0 THEN
         
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
     
     INSERT INTO TBL_FAILED_DISPATCH( member_id, member_id_class, agency_id, nosql_index, doc_id, disp_class, doc_title, reg_dt, request_id, error_code, error_reason )
       VALUES ( $PARAM_ID, @member_id_class, $PARAM_AGENCY_ID, $PARAM_DOC_INDEX ,$PARAM_DOC_ID, @disp_class, $PARAM_TITLE, @now_dt, $PARAM_REQUEST_ID, @error_code, @error_string );
   END IF;

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_TEMPLATECODE` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_GET_VALIDITYAGENCY` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_REG_DOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_REG_FAILEDDISPATCH` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
	IN `$PARAM_AGENCY_ID`		BIGINT(20),
	IN `$PARAM_DOC_INDEX`     	VARCHAR(64),
	IN `$PARAM_DOC_ID`        	VARCHAR(64),
	IN `$PARAM_DISP_CLASS`	  	VARCHAR(2),
	IN `$PARAM_TITLE`         	VARCHAR(128),
	IN `$PARAM_REQUEST_ID`		VARCHAR(64),
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_SET_REGISTRATIONNUM` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AN_SET_STAT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_AUTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_ADDR` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_CAR` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYAGENCYADDRESS` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYDOCUMENT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_DEL_MYDOCUMENT2` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_ADDRESS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_AGENCY` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_BIRTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYAGENCY` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYAGENCYDOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYAGENCYDOCUMENT`(IN $PARAM_PCODE_IDX bigint)
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
          INNER JOIN (select MM.idx as document_id, MM.agency_id, MM.use_yn, collect_YN, disp_class
                        from TBL_MYDOCUMENT MM
                       where MM.p_code_idx = $PARAM_PCODE_IDX) M
             ON A.idx = M.agency_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYAGENCYDOCUMENTCHECK` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYAGENCYDOCUMENTCHECK`(IN $PARAM_PCODE_IDX bigint,
                                                                    IN $PARAM_AGENT_IDX bigint)
BEGIN
    select use_YN
      from TBL_MYDOCUMENT
     where p_code_idx = $PARAM_PCODE_IDX
       and agency_id = $PARAM_AGENT_IDX
       and use_YN = 'Y';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT2`(IN $PARAM_PCODE_IDX bigint, IN $PARAM_STARTDATE date,
                                                          IN $PARAM_ENDDATE date, IN $PARAM_LIMIT_START bigint,
                                                          IN $PARAM_LIMIT bigint, IN $PARAM_GETCOUNT bigint,
                                                          IN $PARAM_KEYWORD varchar(128))
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
           D.template_code,
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT_AGENT_LIST` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT_AGENT_LIST`(IN `$PARAM_AGENT_IDX` BIGINT(20))
BEGIN
	
	SELECT M.p_code as pi,
				M.ci,
				P.mi,
				M.name,
				M.hp,
				M.email,
				M.birth,
				M.gender,
				D.use_YN as use_yn,
				D.collect_YN as collect_yn,
				D.sync_dt
	 FROM (
		 SELECT p_code, name, hp, ci, birth, email, gender 
		 FROM TBL_EPOSTMEMBER ) M
	 INNER JOIN (
		 SELECT p_code, use_yn, collect_YN, sync_dt 
		 FROM TBL_MYDOCUMENT 
		 WHERE agency_id = $PARAM_AGENT_IDX 
		 AND collect_YN = 'N') D	 
	 ON M.p_code = D.p_code
	 INNER JOIN (
		 SELECT p_code, mi 
		 FROM TBL_PCODE ) P 
	 ON D.p_code = P.p_code;
 	 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT_API` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT_API`(
   IN `$PARAM_AGENT_IDX` BIGINT(20),
   IN `$PARAM_START_DATE`	VARCHAR(20),
   IN `$PARAM_END_DATE`	VARCHAR(20)
)
BEGIN
	
	IF $PARAM_START_DATE AND $PARAM_END_DATE THEN
		
		SET $PARAM_END_DATE = DATE_ADD($PARAM_END_DATE, INTERVAL 1 DAY);
		SET $PARAM_START_DATE = DATE($PARAM_START_DATE);
		SET $PARAM_END_DATE = DATE($PARAM_END_DATE);
		
		SELECT M.p_code as pi,
				M.ci,
				P.mi,
				M.name,
				M.hp,
				M.email,
				M.birth,
				M.gender,
				D.use_YN as use_yn,
				D.collect_YN as collect_yn,
				D.sync_dt
		FROM (
		 SELECT p_code, name, hp, ci, birth, email, gender 
		 FROM TBL_EPOSTMEMBER ) M
		INNER JOIN (
		 SELECT p_code, use_yn, collect_YN, sync_dt 
		 FROM TBL_MYDOCUMENT 
		 WHERE agency_id = $PARAM_AGENT_IDX 
		 AND collect_YN = 'N' AND sync_dt >= $PARAM_START_DATE AND sync_dt <= $PARAM_END_DATE ) D	 
		ON M.p_code = D.p_code
		INNER JOIN (
		 SELECT p_code, mi 
		 FROM TBL_PCODE ) P 
		ON D.p_code = P.p_code;
			 
	ELSE
	 
		SELECT M.p_code as pi,
				M.ci,
				P.mi,
				M.name,
				M.hp,
				M.email,
				M.birth,
				M.gender,
				D.use_YN as use_yn,
				D.collect_YN as collect_yn,
				D.sync_dt
		FROM (
		 SELECT p_code, name, hp, ci, birth, email, gender 
		 FROM TBL_EPOSTMEMBER ) M
		INNER JOIN (
		 SELECT p_code, use_yn, collect_YN, sync_dt 
		 FROM TBL_MYDOCUMENT 
		 WHERE agency_id = $PARAM_AGENT_IDX 
		 AND collect_YN = 'N') D	 
		ON M.p_code = D.p_code
		INNER JOIN (
		 SELECT p_code, mi 
		 FROM TBL_PCODE ) P 
		ON D.p_code = P.p_code;
			 
	END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYDOCUMENT_FILE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_MYDOCUMENT_FILE`(IN `$PARAM_AGENT_IDX` BIGINT(20))
BEGIN
	
	SELECT M.p_code as pi,
				M.ci,
				P.mi,
				M.name,
				M.hp,
				M.email,
				M.birth,
				M.gender,
				D.use_YN as use_yn,
				D.collect_YN as collect_yn,
				D.sync_dt
	 FROM (
		 SELECT p_code, name, hp, ci, birth, email, gender 
		 FROM TBL_EPOSTMEMBER ) M
	 INNER JOIN (
		 SELECT p_code, use_yn, collect_YN, sync_dt 
		 FROM TBL_MYDOCUMENT 
		 WHERE agency_id = $PARAM_AGENT_IDX 
		 AND collect_YN = 'N') D	 
	 ON M.p_code = D.p_code
	 INNER JOIN (
		 SELECT p_code, mi 
		 FROM TBL_PCODE ) P 
	 ON D.p_code = P.p_code;
 	 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYMESSAGE` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYMESSAGE2` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_MYPAYMENT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_PCODE` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_GET_TEMPLATES` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_GET_TEMPLATES`()
BEGIN
    select TT.idx as template_id,
           TT.agency_id,
           TA.org_code,
           TA.dept_code,
           TT.template_name,
           TT.template_code,
           TT.file_name,
           TT.upload_dt
      from TBL_TEMPLATE TT left join  TBL_AGENCY TA on TT.agency_id = TA.idx
     where TT.app_yn = 'Y'
  order by TT.upload_dt;
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
   
   DECLARE errorCode    INT(4);
   DECLARE errorMsg     VARCHAR(64);

   
   DECLARE hp_cnt       INT(4);
   DECLARE pcode_cnt    INT(4);

   
   DECLARE pcode_idx    BIGINT(11);
   DECLARE pcode        VARCHAR(128);
   DECLARE push_class   VARCHAR(64);
   DECLARE pwd          VARCHAR(128);
   DECLARE uname        VARCHAR(16);
   DECLARE fail_cnt     INT(4);

   
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

      
      IF hp_cnt <= 0
      THEN
         
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
      
      ELSEIF hp_cnt >= 2
      THEN
         SET errorCode = 10011;
         SET errorMsg = 'Hp is duplicated. identify';

         SELECT errorCode, errorMsg;
      
      ELSEIF pcode = NULL
      THEN
         SET errorCode = 10012;
         SET errorMsg = 'Pcode is null. identify';
         SET fail_cnt = fail_cnt + 1;

         
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      
      ELSEIF (SELECT TIMESTAMPDIFF(MONTH, last_login, now()) > 2)
      THEN
         SET errorCode = 10016;
         SET errorMsg = 'Inactive account. Identify';
         SET fail_cnt = fail_cnt + 1;

         
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      
      ELSEIF fail_cnt >= 5
      THEN
         SET errorCode = 10013;
         SET errorMsg = 'Locked ID. identify';

         SELECT errorCode, errorMsg, fail_cnt;
      
      ELSEIF pcode <> $PARAM_PCODE
      THEN
         SET errorCode = 10014;
         SET errorMsg = 'Pcode not matched. Identify';
         SET fail_cnt = fail_cnt + 1;

         
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         SELECT errorCode, errorMsg, fail_cnt;
      
      ELSEIF pwd <> $PARAM_PASSWORD
      THEN
         SET errorCode = 10015;
         SET errorMsg = 'Wrong password';
         SET fail_cnt = fail_cnt + 1;

         
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = fail_cnt
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         

         SELECT errorCode, errorMsg, fail_cnt;
      
      ELSE
         SET errorCode = 200;
         SET errorMsg = 'OK';
         SET fail_cnt = 0;

         
         UPDATE TBL_EPOSTMEMBER
            SET login_fail_count = 0, last_login_dt = now()
          WHERE hp = $PARAM_HP AND use_yn = 'Y';

         
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_ADDRPICKUP` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_AFTER_AUTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_AFTER_AUTH`(
   IN `$PARAM_PCODE`   VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN
   
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEADDRESS` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGECAR` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEMYAGENCYRECVCLASS` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEMYDOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_CHANGEMYDOCUMENT`(IN $PARAM_PCODE_IDX bigint, IN $PARAM_DOCUMENT_ID bigint,
                                                               IN $PARAM_USEYN varchar(2))
    DETERMINISTIC
BEGIN

DECLARE dispClass INT(4);

IF $PARAM_USEYN = 'Y'
THEN
    SET dispClass = 1;
ELSE
    SET dispClass = 0;
END IF;


UPDATE TBL_MYDOCUMENT
SET use_YN = $PARAM_USEYN, disp_class = dispClass, collect_YN = 'N', sync_dt = now()
WHERE p_code_idx = $PARAM_PCODE_IDX AND idx = $PARAM_DOCUMENT_ID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEPASS` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGEPHONE` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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

   # if there's same number, change it to null.
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_CHANGE_EMAIL` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_HISTORY_MYAGENCY_DISPCLASS` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MESSAGEPERMISSION` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MYAGENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MYAGENCY`(
   IN `$PARAM_PCODE_IDX`   BIGINT(20),
   IN `$PARAM_PCODE`       VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_AGENCY_ID`   BIGINT(20))
    DETERMINISTIC
BEGIN
   DECLARE myagency_cnt   INT(4);
   DECLARE addr_idx       BIGINT(20);

   
   SELECT idx
     INTO addr_idx
     FROM TBL_MEMBERADDRESS
    WHERE p_code_idx = $PARAM_PCODE_IDX AND recv_yn = 'Y';

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_MYDOCUMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_MYDOCUMENT`(IN $PARAM_PCODE_IDX bigint, IN $PARAM_PCODE varchar(37),
                                                         IN $PARAM_AGENCY_ID bigint)
    DETERMINISTIC
BEGIN
   DECLARE mydocument_cnt   INT(4);
   DECLARE i INT(4);
   DECLARE agencyIdx INT(4);

   # find my document count
   SET mydocument_cnt =
          (SELECT COUNT(*)
             FROM TBL_MYDOCUMENT MM
            WHERE     MM.p_code_idx = $PARAM_PCODE_IDX);

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
                                   agency_id
#                                    template_id,
                                   )
               VALUES ($PARAM_PCODE_IDX,
                       $PARAM_PCODE,
                       agencyIdx);
#                        (SELECT idx
#                           FROM TBL_TEMPLATE
#                          WHERE agency_id = $PARAM_AGENCY_ID
#                            AND dn_yn = 'Y'
#                            limit i, 1),
           SET i = i - 1;
           END WHILE;
   END IF;

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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`embuser`@`%` PROCEDURE `SP_IF_SET_PCODE`(
   IN `$PARAM_PCODE`      VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci,
   IN `$PARAM_CI`         VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci)
    DETERMINISTIC
BEGIN 
   DECLARE cnt INT(10);

    SET cnt = (SELECT COUNT(*) FROM TBL_PCODE WHERE ci = $PARAM_CI);

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNOUT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_IF_SET_SIGNUP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
   
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
   
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   
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
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
   
   DECLARE OK_TIME   TIMESTAMP;

   SET OK_TIME = NULL;

   IF $PARAM_MKT_OK = '1'
   THEN
      SET OK_TIME = now();
   END IF;

   
   UPDATE TBL_PCODE
      SET disp_class = '1', push_permit_class = 7
    WHERE p_code = $PARAM_PCODE;

   
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PAY_RESULT` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_GET_MESSAGE` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_SET_DISPATCHED` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_PS_SET_ERROR` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_TEST` */;
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
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
ALTER DATABASE `EMAILBOX` CHARACTER SET utf8 COLLATE utf8_general_ci ;
