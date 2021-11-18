package Stats

var QUERY_KEY_ORG_CODE string = "$ORG_CODE"
var QUERY_KEY_DEPT_CODE string = "$DEPT_CODE"
var QUERY_KEY_REQUEST_ID string = "$REQUEST_ID"
var QUERY_KEY_GROUP_BY string = "$GROUP_BY"
var QUERY_KEY_DOC_ID string = "$DOC_ID"
var QUERY_KEY_DM_REG_NUM string = "$DM_REGNUM"
var QUERY_KEY_NAME string = "$NAME"
var QUERY_KEY_GTE string = "$GTE"
var QUERY_KEY_LT string = "$LT"
var QUERY_KEY_PAGE_FROM string = "$PAGE_FROM"
var QUERY_KEY_PAGE_SIZE string = "$PAGE_SIZE"
var QUERY_KEY_SORT_KEY string = "$SORT_KEY"
var QUERY_KEY_SORT_ORDER string = "$SORT_ORDER"

var REQ_KEY_ORG_CODE string = "org_code"
var REQ_KEY_DEPT_CODE string = "dept_code"
var REQ_KEY_REQUEST_ID string = "req_id"
var REQ_KEY_GROUP_BY string = "group_by"
var REQ_KEY_DOC_ID string = "doc_id"
var REQ_KEY_DM_REG_NUM string = "reg_num"
var REQ_KEY_NAME string = "name"
var REQ_KEY_GTE string = "gte"
var REQ_KEY_LT string = "lt"
var REQ_KEY_PAGE_FROM string = "page_from"
var REQ_KEY_PAGE_SIZE string = "page_size"
var REQ_KEY_SORT_KEY string = "sort_key"
var REQ_KEY_SORT_ORDER string = "sort_order"

var CONF_KEY_URL string = "stats.stat_url"
var CONF_KEY_USER string = "stats.user"
var CONF_KEY_PASSWORD string = "stats.password"

var QUERY_FILE_BY_REQUEST_ID string = "queries/byreqid.json"
var QUERY_FILE_BY_DOC_ID string = "queries/bydocid.json"
var QUERY_FILE_BY_GROUP_BY string = "queries/bygroup.json"
var QUERY_FILE_BY_TIME string = "queries/bytime.json"
var QUERY_FILE_BY_DM_REGNUM string = "queries/bydmregnum.json"
var QUERY_FILE_BY_NAME string = "queries/byname.json"

var keyMap = map[string]string{
	REQ_KEY_ORG_CODE:   QUERY_KEY_ORG_CODE,
	REQ_KEY_DEPT_CODE:  QUERY_KEY_DEPT_CODE,
	REQ_KEY_REQUEST_ID: QUERY_KEY_REQUEST_ID,
	REQ_KEY_GROUP_BY:   QUERY_KEY_GROUP_BY,
	REQ_KEY_DOC_ID:     QUERY_KEY_DOC_ID,
	REQ_KEY_GTE:        QUERY_KEY_GTE,
	REQ_KEY_LT:         QUERY_KEY_LT,
	REQ_KEY_PAGE_FROM:  QUERY_KEY_PAGE_FROM,
	REQ_KEY_PAGE_SIZE:  QUERY_KEY_PAGE_SIZE,
	REQ_KEY_SORT_KEY:   QUERY_KEY_SORT_KEY,
	REQ_KEY_SORT_ORDER: QUERY_KEY_SORT_ORDER,
	REQ_KEY_DM_REG_NUM: QUERY_KEY_DM_REG_NUM,
	REQ_KEY_NAME:       QUERY_KEY_NAME,
}
