/******************************************************************************
**		Name: TABLE TBL_MYDOCUMENT
**		Desc: 포스톡 회원 기관별 동의 테이블
**
**		Author: MOON TAEHOON
**		Date: 2021-10-12
*******************************************************************************/
-- auto-generated definition
create table TBL_MYDOCUMENT
(
    idx         bigint unsigned auto_increment
        primary key,
    p_code_idx  bigint                 null comment '회원 고유의 PI IDX',
    p_code      varchar(37)            null comment '회원 고유의 PI CODE',
    agency_id   bigint                 null comment '기관 아이디',
    disp_class  varchar(2) default '1' null comment '발송종류(APP:1, DM:2)',
    template_id bigint                 null comment '템플릿 아이디',
    use_YN      varchar(2)             null comment '내 기관 사용 여부',
    collect_YN  varchar(2)             null comment '수집 사용 여부'
)
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;

create index AGENCYID
    on TBL_MYDOCUMENT (agency_id);

create index PCODE_IDX
    on TBL_MYDOCUMENT (p_code_idx);



/* 없어도 될듯 */