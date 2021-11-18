package Convert

import (
	jsonlib "../../common/JsonSerializer"
)

const (
	EXT_LIST     string = "list"
	EXT_CHECKBOX string = "checkbox"
	EXT_FORM     string = "form"
	EXT_DONE     string = "done"
	//EXT_ARRAY    string = "array"

	DELIMITER_SAMFILE_NAME  string = "$"
	DELIMITER_SAMFILE_DATA  string = "|"
	LENGTH_REGISTRATION_NUM int    = 13

	checkedForm    string = `"%v" : { "tag" : { "onclick" : "return false", "checked" : "", "value" : "value" }, "type" : "checkbox", "desc" : "%v" }`
	unCheckedForm  string = `"%v" : { "tag" : { "onclick" : "return false", "value" : "value" }, "type" : "checkbox", "desc" : "%v" }`
	receiverNmForm string = `%v(%v)`
	arrayForm      string = `"__arrayprint__":""`

	encryptKey      string = "1234567890123456"
	insertBulkQuery string = `{ "index": { "_index":"%v", "_type":"_doc"} }%v%v%v`

	FORM_IJGWANRINO string = "0000-0000000"
	FORM_GYGWANRINO string = "000-00-00000-0"

	DMTYPE_01 string = "general"
	DMTYPE_02 string = "registered"

	ES_DATA_IJGWANRINO          string = "binding.data.ij_gwanri_no"
	ES_DATA_GYGWANRINO          string = "binding.data.gy_gwanri_no"
	ES_DISPATCHING_CLASS        string = "binding.reserved.essential.dispatching.class"
	ES_SEARCH_GROUPBY           string = "binding.reserved.essential.search.group-by"
	ES_DATA_GRJLIST             string = "binding.data.grjlist"
	ES_GRJLIST_GRJJIWONFG       string = `binding.data.grjlist.%v.grj_jiwon_fg`
	ES_DISPATCHING_DM_TYPE      string = "binding.reserved.essential.dispatching.dm.type"    //no list file
	ES_DISPATCHING_DM_REGNUM    string = "binding.reserved.essential.dispatching.dm.reg-num" //no list file
	ES_DATA_REQUEST_ID          string = "binding.reserved.essential.search.request-id"
	ES_BINDING_DATA             string = "binding.data"
	ES_DATA_HASH                string = "data-hash"
	ES_RECEIVER_ADDR1           string = "binding.reserved.additional.receiver.addr1"
	ES_RECEIVER_ADDR2           string = "binding.reserved.additional.receiver.addr2"
	ES_SENDER_ADDR1             string = "binding.reserved.additional.sender.addr1"
	ES_SENDER_ADDR2             string = "binding.reserved.additional.sender.addr2"
	ES_RECEIVER_NAME            string = "binding.reserved.additional.receiver.name"
	ES_DATA_DPJ_NM              string = "binding.data.dpj_nm"
	ES_AUTO_NONMEMBER           string = "binding.reserved.essential.dispatching.auto.non-member"
	ES_DM_UNSTRUCTURED_FLEX     string = "binding.reserved.essential.dispatching.dm.unstructured.flex"
	ES_DM_UNSTRUCTURED_COLOR    string = "binding.reserved.essential.dispatching.dm.unstructured.color"
	ES_DM_UNSTRUCTURED_ENVELOPE string = "binding.reserved.essential.dispatching.dm.unstructured.color"
	ES_DM_UNSTRUCTURED_FILENAME string = "binding.reserved.essential.dispatching.dm.unstructured.filename"
	ES_DATA_SEJ_NM              string = "binding.data.sej_nm"
	ES_SENDER_TEL               string = "binding.reserved.additional.sender.tel"
	ES_DATA_URL                 string = "binding.data.url"
	ES_DATA_SIHAENG_DT          string = "binding.data.sihaeng_dt"
	ES_DATA_SIHAENG_DT_MM       string = "binding.data.sihaeng_dt_mm"

	LAYOUT_SAM_JISATEL string = "1588-0075"
	LAYOUT_SAM_URL     string = "www.kcomwel.or.kr"

	ERROR_CODE_JSON_PARSE   string = "10"
	ERROR_CODE_DATA_FORMAT  string = "11"
	ERROR_CODE_DATA_INVALID string = "12"
	ERROR_CODE_DB           string = "20"
	ERROR_CODE_ETC          string = "50"

	ILJARI_COMMON_CODE       string = "common"
	ILJARI_NOTICE_CODE       string = "00001"
	ILJARI_UNSTRUCTERED_CODE string = "00002"
	ILJARI_NOTICE_CODE_3     string = "00003"

	// 공인전자문서

	BLAB_COLLECT_FORM        string = "collect"
	collectArrayForm         string = `"__usersarrayprint__":""`
	BLAB_COLLECT_COMMON_CODE string = "common_collect"

	grjArrayForm string = `"__grjarrayprint__":""`

	BLAB_RECEIVER_NAME  string = "binding.data.re_name"
	BLAB_RECEIVER_ADDR1 string = "binding.data.re_addr1"
	BLAB_RECEIVER_ADDR2 string = "binding.data.re_addr2"
	BLAB_SENDER_ADDR1   string = "binding.data.se_addr1"
	BLAB_SENDER_ADDR2   string = "binding.data.se_addr2"
	BLAB_SENDER_TEL     string = "binding.data.se_tel"

	BLAB_DATA_DR_LIST     string = "binding.data.dr_list"
	BLAB_DATA_DR_LIST_VAR string = `binding.data.dr_list.%v.var`

	BLAB_DATA_GRJLIST       string = "binding.data.grjlist"
	BLAB_GRJLIST_GRJJIWONFG string = `binding.data.grjlist.%v.grj_jiwon_fg`

	BLAB_COMMON_CODE string = "common_web"

	BLAB_NOTICE_CODE string = "00004"
	// 공인전자문서

	DB_QUERY_TEMPLATE string = "SELECT template_code FROM TBL_TEMPLATE WHERE agency_id=6"
)

type convObj struct {
	templateCode string
	bulkIndex    int

	recordLength   int
	documentLength int

	dForm []byte
	dList []string
	oPath []string
}

type jsonObj struct {
	convObj

	jCheck   *jsonlib.JsonMap
	ArrayMap map[string][]jsonBulkData
	bulkMap  map[string]*jsonlib.JsonMap
}

type noticeObj struct {
	convObj

	jCheck   *jsonlib.JsonMap
	ArrayMap map[string][]bulkData
	bulkMap  map[string]*jsonlib.JsonMap
}

type jsonBulkData struct {
	stdKey   string
	arrayMap map[string][]string
}

type bulkData struct {
	stdKey   string
	arrayMap map[string][]string
}

type unstructuredObj struct {
	convObj

	pdfFileName  string
	jUntDataList []*jsonlib.JsonMap
}

func NewJsonObj() *jsonObj {
	jo := jsonObj{
		ArrayMap: make(map[string][]jsonBulkData),
		bulkMap:  make(map[string]*jsonlib.JsonMap),
	}
	return &jo
}

func NewWebJsonObj() *jsonObj {
	jo := jsonObj{
		ArrayMap: make(map[string][]jsonBulkData),
		bulkMap:  make(map[string]*jsonlib.JsonMap),
	}
	return &jo
}

func NewNoticeObj() *noticeObj {
	no := noticeObj{
		ArrayMap: make(map[string][]bulkData),
		bulkMap:  make(map[string]*jsonlib.JsonMap),
	}
	return &no
}

func NewUnstructuredObj() *unstructuredObj {
	uo := unstructuredObj{}
	return &uo
}

func (co *convObj) SetTemplateCode(templateCode string) {
	co.templateCode = templateCode
}

func (co *convObj) SetDataLength(recordLength int, documentLength int) {
	co.recordLength = recordLength
	co.documentLength = documentLength
}

func (co *convObj) InitBulkIndex() {
	co.bulkIndex = 0
}

func (co *convObj) appendBulkPath(pathLock string) {
	co.oPath = append(co.oPath, pathLock)
}

func (uo *unstructuredObj) appendJUntDataList(jUntData *jsonlib.JsonMap) {
	uo.jUntDataList = append(uo.jUntDataList, jUntData)
}

func (uo *unstructuredObj) SetPdfFileName(pdfFileName string) {
	uo.pdfFileName = pdfFileName
}
