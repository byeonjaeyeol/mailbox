package Convert

import (
	"bytes"
	"fmt"
	"strconv"
	"strings"

	jsonlib "../../common/JsonSerializer"
	perr "../Error"
	"../FileUtils"

	"../RDBMS"
	"../Utils"
)

func (ci *convInst) convertJsonData(jsonFile string) error {
	var terr *perr.Error
	var err error
	var errCode string
	errCode = "0"

	var backupFile string
	var errorFile string
	backupFile = ci.getBackupPath(jsonFile)
	errorFile = backupFile + ".err"

	jo := NewJsonObj()
	defer func() {
		if ci.checkMoniteringFlag() {
			ci.insertRecvResultStat(&jo.convObj, jsonFile, errCode)
		}
	}()

	/**
	  renewal..
	  1. get db
	   - set templetecode..
	  2. for 문
	  3. if get ERROR_CODE_DATA_FORMAT
	  4. next for
	*/
	//ci.templateDirectory
	//var queryRes *jsonlib.JsonMap
	//var reqQuery = fmt.Sprintf()
	codes := RDBMS.GetTemplateCode(ci.agencyID)

	fmt.Println("[BlabAgent][jsonData] _INFO : convertNoticeData getTemplateCode [Codes : ", codes)

	// 코드 갯수 만큼 반복해서
	// maxlen := len(codes)

	jo.SetTemplateCode(BLAB_NOTICE_CODE)

	terr = jo.readBaseInfo(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("readBaseFile() : %v", terr.Err)
	}

	terr = jo.convertJsonToJson(ci, jsonFile)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("convertJsonToJson() : %v", terr.Err)
	}

	// json 파일 만들기
	terr = jo.createBulkFile(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("createBulkFile() : %v", terr.Err)
		goto _ERROR_PROC
	}

	// 백업파일 복사
	err = FileUtils.BackupFile(jsonFile, backupFile, GetBackupBufferSize())
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("BackupFile() : %v", err)
		goto _ERROR_PROC
	}
	// 파일 락 해제
	err = Utils.UnlockFile(jo.oPath)
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("Utils::Unlock() : %v", err)
		goto _ERROR_PROC
	}

	return nil

_ERROR_PROC:
	if checkSAMFileError(errCode) {
		FileUtils.BackupFile(jsonFile, errorFile, GetBackupBufferSize())
	}

	Utils.RmlockFile(jo.oPath)

	return err
}

func (ci *convInst) convertWebJsonData(jsonData *jsonlib.JsonMap, count int) error {
	var terr *perr.Error
	var err error
	var errCode string
	errCode = "0"

	jo := NewWebJsonObj()
	defer func() {
		if ci.checkMoniteringFlag() {
			ci.insertRecvResultStat(&jo.convObj, "Web API JsonData ("+strconv.Itoa(count)+")", errCode)
		}
	}()

	codes := RDBMS.GetTemplateCode(ci.agencyID)
	fmt.Println("[BlabAgent][jsonData] _INFO : convertNoticeData getTemplateCode [Codes : ", codes)

	jo.SetTemplateCode(BLAB_NOTICE_CODE)

	terr = jo.readBaseInfo(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("readBaseFile() : %v", terr.Err)
	}

	terr = jo.convertWebJsonToJson(ci, jsonData, count)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("convertJsonToJson() : %v", terr.Err)
	}

	// json 파일 만들기
	terr = jo.createBulkFile(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("createBulkFile() : %v", terr.Err)
		goto _ERROR_PROC1
	}

	// 파일 락 해제
	err = Utils.UnlockFile(jo.oPath)
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("Utils::Unlock() : %v", err)
		goto _ERROR_PROC2
	}

	return nil

_ERROR_PROC1:
	fmt.Println("Error Web Convert1")

	Utils.RmlockFile(jo.oPath)

	return err

_ERROR_PROC2:
	fmt.Println("Error Web Convert2")

	Utils.RmlockFile(jo.oPath)

	return err
}

// 템플릿의 기본정보를 읽는다
func (jo *jsonObj) readBaseInfo(ci *convInst) *perr.Error {
	var err error

	// fmt.Println("[BlabAgent][jsonData] _INFO : readBaseInfo Start")
	// jo.dList, err = Utils.GetSliceFromFile(ci.getPathByExt(jo.templateCode, EXT_LIST), "\r\n")
	// fmt.Println("[BlabAgent][jsonData] _INFO : readBaseInfo [jo.dList : ", jo.dList, "][Code:", jo.templateCode, "]")
	// if nil != err {
	// 	return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dList error : %v, baseFile : %v", err, ci.getPathByExt(jo.templateCode, EXT_LIST))}
	// }

	jo.dForm, err = jsonlib.GetJsonBytes(ci.getPathByExt(jo.templateCode, EXT_FORM))
	// fmt.Println("[BlabAgent][jsonData] _INFO : readBaseInfo [jo.dForm : ", jo.dForm)

	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dForm error : %v, baseFile : %v", err, ci.getPathByExt(jo.templateCode, EXT_FORM))}
	}

	jo.jCheck, err = jsonlib.NewJsonMapFromFile(ci.getPathByExt(jo.templateCode, EXT_CHECKBOX))
	// fmt.Println("[BlabAgent][jsonData] _INFO : readBaseInfo [jo.jCheck : ", jo.jCheck)

	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load jCheck error : %v, baseFile : %v", err, ci.getPathByExt(jo.templateCode, EXT_CHECKBOX))}
	}
	// fmt.Println("[BlabAgent][jsonData] _INFO : readBaseInfo End")

	return nil
}

// bulk json data 갯수를 파악한다 하나씩 컨버팅을 한다
func (jo *jsonObj) convertJsonToJson(ci *convInst, jsonFile string) *perr.Error {

	jsonBulkDataMap, err := jsonlib.NewJsonMapFromFile(jsonFile)
	// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonBulkDataMap : ", jsonBulkDataMap, "]")
	if nil != err {
		fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonBulkDataMap error: ", err, "]")
		return &perr.Error{ERROR_CODE_DATA_FORMAT, fmt.Errorf("getDataInfo():: error : %v", err)}
	}

	var jsonCount int
	jsonCount, err = strconv.Atoi(jsonBulkDataMap.Find("count"))
	// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonCount : ", jsonCount, "]")
	if nil != err {
		return &perr.Error{ERROR_CODE_DATA_FORMAT, fmt.Errorf("getDataInfo():: error : %v", err)}
	}

	// json 파일을 읽어서 갯수 만큼 컨버팅
	var blankLine int
	for i := 0; i < jsonCount; i++ {
		// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonCount for i : ", i, "]")

		// fmt.Println("[BlabAgent][jsonData] _INFO : [ jsonBulkDataMap : msg."+strconv.Itoa(i)+".data-hash", jsonBulkDataMap.Find("msg."+strconv.Itoa(i)+".data-hash"), "]")
		if 0 == strings.Compare("", jsonBulkDataMap.Find("msg."+strconv.Itoa(i))) {
			blankLine++
			fmt.Println("[BlabAgent][jsonData] _INFO : [ jsonBulkDataMap blankLine : ", blankLine)
			continue
		}

		terr := jo.convertSingleJsonData(ci, jsonBulkDataMap.Find("msg."+strconv.Itoa(i)), "1", strconv.Itoa(jsonCount), strconv.Itoa(i+1))
		// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [terr : ", terr, "]")
		if nil != terr {
			terr.Err = fmt.Errorf("convertSingleSAMData():: error : %v, SAMData LineNumber : %v", terr.Err, i)
			return terr
		}
	}

	var recordLength int
	var documentLength int
	recordLength = jsonCount - blankLine
	documentLength = len(jo.ArrayMap)

	jo.SetDataLength(recordLength, documentLength)

	return nil
}

// api json data 갯수를 파악한다 하나씩 컨버팅을 한다
func (jo *jsonObj) convertWebJsonToJson(ci *convInst, jsonData *jsonlib.JsonMap, count int) *perr.Error {

	jsonBulkDataMap := jsonData
	// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonBulkDataMap : ", jsonBulkDataMap, "]")
	// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [count : ", count, "]")

	// json 파일을 읽어서 갯수 만큼 컨버팅
	var blankLine int
	for i := 0; i < count; i++ {
		// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [jsonCount for i : ", i, "]")

		if 0 == strings.Compare("", jsonBulkDataMap.Find("msg."+strconv.Itoa(i))) {
			blankLine++
			fmt.Println("[BlabAgent][jsonData] _INFO : [ jsonBulkDataMap blankLine : ", blankLine)
			continue
		}

		terr := jo.convertSingleJsonData(ci, jsonBulkDataMap.Find("msg."+strconv.Itoa(i)), "2", strconv.Itoa(count), strconv.Itoa(i+1))
		// fmt.Println("[BlabAgent][jsonData] _INFO : convertJsonToJson [terr : ", terr, "]")
		if nil != terr {
			terr.Err = fmt.Errorf("convertSingleSAMData():: error : %v, SAMData LineNumber : %v", terr.Err, i)
			return terr
		}
	}

	var recordLength int
	var documentLength int
	recordLength = count - blankLine
	documentLength = len(jo.ArrayMap)

	jo.SetDataLength(recordLength, documentLength)

	return nil
}

// form 형태에 맞춰서 벌크 데이터를 만든다
func (jo *jsonObj) convertSingleJsonData(ci *convInst, jsonData string, conType string, count string, countNum string) *perr.Error {

	// form 파일의 json 읽어서 맵을 만듬
	retJMap, err := jsonlib.NewJsonMapFromBytes(jo.dForm)
	// fmt.Println("[BlabAgent][noticeData] _INFO : convertSingleJsonData [retJMap1 : ", retJMap, "]")
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error1 : %v", err)}
	}

	jbd := jsonBulkData{
		arrayMap: make(map[string][]string),
	}

	var checkSlice []string

	// 해당 값을 form 에 맞춰서 입력하기
	jsonMap, err := jsonlib.NewJsonMapFromBytes([]byte(jsonData))
	// fmt.Println("[BlabAgent][noticeData] _INFO : convertSingleJsonData [jsonMap1 : ", jsonMap, "]")
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error2 : %v", err)}
	}

	retJMap.Update("odata-hash", jsonMap.Find("data-hash"))

	//  Original data update
	retJMap.Update("binding.data.request-id", jsonMap.Find("data.request-id"))
	retJMap.Update("binding.data.pi", jsonMap.Find("data.pi"))
	retJMap.Update("binding.data.ci", jsonMap.Find("data.ci"))
	retJMap.Update("binding.data.mi", jsonMap.Find("data.mi"))
	retJMap.Update("binding.data.disp_class", jsonMap.Find("data.disp_class"))
	retJMap.Update("binding.data.send_date", jsonMap.Find("data.send_date"))
	retJMap.Update("binding.data.sender_pi", jsonMap.Find("data.sender_pi"))
	retJMap.Update("binding.data.match_key", jsonMap.Find("data.match_key"))
	retJMap.Update("binding.data.official_doc", jsonMap.Find("data.official_doc"))
	retJMap.Update("binding.data.se_type", jsonMap.Find("data.se_type"))
	retJMap.Update("binding.data.se_name", jsonMap.Find("data.se_name"))
	retJMap.Update("binding.data.se_zip_code", jsonMap.Find("data.se_zip_code"))
	retJMap.Update("binding.data.se_addr1", jsonMap.Find("data.se_addr1"))
	retJMap.Update("binding.data.se_addr2", jsonMap.Find("data.se_addr2"))
	retJMap.Update("binding.data.se_tel", jsonMap.Find("data.se_tel"))
	retJMap.Update("binding.data.re_name", jsonMap.Find("data.re_name"))
	retJMap.Update("binding.data.re_zip_code", jsonMap.Find("data.re_zip_code"))
	retJMap.Update("binding.data.re_addr1", jsonMap.Find("data.re_addr1"))
	retJMap.Update("binding.data.re_addr2", jsonMap.Find("data.re_addr2"))
	retJMap.Update("binding.data.re_addr3", jsonMap.Find("data.re_addr3"))
	retJMap.Update("binding.data.dr_no", jsonMap.Find("data.dr_no"))
	retJMap.Update("binding.data.dr_name", jsonMap.Find("data.dr_name"))
	retJMap.Update("binding.data.dr_form", jsonMap.Find("data.dr_form"))
	retJMap.Update("binding.data.dr_num", jsonMap.Find("data.dr_num"))
	retJMap.Update("binding.data.ddj_nm", jsonMap.Find("data.ddj_nm"))
	retJMap.Update("binding.data.ddj_tel", jsonMap.Find("data.ddj_tel"))
	retJMap.Update("binding.data.grj_num", jsonMap.Find("data.grj_num"))
	retJMap.Update("binding.data.jiwon_sum", jsonMap.Find("data.jiwon_sum"))
	retJMap.Update("binding.data.jigeup_sum", jsonMap.Find("data.jigeup_sum"))
	retJMap.Update("binding.data.jigeup_dt", jsonMap.Find("data.jigeup_dt"))
	retJMap.Update("binding.data.jiwon_yymm", jsonMap.Find("data.jiwon_yymm"))
	retJMap.Update("binding.data.sej_nm", jsonMap.Find("data.sej_nm"))
	retJMap.Update("binding.data.sej_addr1", jsonMap.Find("data.sej_addr1"))
	retJMap.Update("binding.data.sej_addr2", jsonMap.Find("data.sej_addr2"))
	retJMap.Update("binding.data.gy_gwanri_no", jsonMap.Find("data.gy_gwanri_no"))

	// update

	request_id := jsonMap.Find("data.request-id")
	retJMap.Update(ci.standardJsonkey, modFormatStandardKey(ci.deptCode, request_id))

	match_key := jsonMap.Find("data.match_key")
	// fmt.Println("[BlabAgent][noticeData] _INFO : convertSingleJsonData [match_key", match_key)
	retJMap.Update("match_key", match_key)

	var key, modKey, modVal string
	// 1: pi, 2: ci, 3. mi
	key = match_key
	switch key {
	case "1":
		modKey = "pi"
		modVal = jsonMap.Find("data.pi")
	case "2":
		modKey = "ci"
		modVal = jsonMap.Find("data.ci")
	case "3":
		modKey = "mi"
		modVal = jsonMap.Find("data.mi")
	}
	retJMap.Update(modKey, modVal)

	retJMap.Update("send_date", jsonMap.Find("data.send_date"))
	retJMap.Update("official_doc", jsonMap.Find("data.official_doc"))
	retJMap.Update("binding.reserved.essential.dispatching.class", jsonMap.Find("data.disp_class"))
	retJMap.Update("binding.reserved.essential.dispatching.type", jsonMap.Find("data.se_type"))
	retJMap.Update("binding.reserved.essential.template.dr_form", jsonMap.Find("data.dr_form"))

	retJMap.Update("binding.reserved.essential.search.type", conType)
	retJMap.Update("binding.reserved.essential.search.count", count)
	retJMap.Update("binding.reserved.essential.search.count-num", countNum)

	retJMap.Update("binding.reserved.additional.sender.name", jsonMap.Find("data.se_name"))
	retJMap.Update("binding.reserved.additional.sender.zip-code", jsonMap.Find("data.se_zip_code"))
	retJMap.Update("binding.reserved.additional.sender.addr1", jsonMap.Find("data.se_addr1"))
	retJMap.Update("binding.reserved.additional.sender.adde2", jsonMap.Find("data.se_addr2"))
	retJMap.Update("binding.reserved.additional.sender.tel", jsonMap.Find("data.se_tel"))

	retJMap.Update("binding.reserved.additional.receiver.name", jsonMap.Find("data.re_name"))
	retJMap.Update("binding.reserved.additional.receiver.zip-code", jsonMap.Find("data.re_zip_code"))
	retJMap.Update("binding.reserved.additional.receiver.addr1", jsonMap.Find("data.re_addr1"))
	retJMap.Update("binding.reserved.additional.receiver.addr2", jsonMap.Find("data.re_addr2"))
	retJMap.Update("binding.reserved.additional.receiver.addr3", jsonMap.Find("data.re_addr3"))

	// fmt.Println("jbd.arrayMap", jbd.arrayMap)

	var grjNum int
	grjNum, err = strconv.Atoi(jsonMap.Find("data.grj_num"))
	// fmt.Println("[BlabAgent][jsonData] _INFO : convertSingleJsonData [grjNum : ", grjNum, "]")

	for i := 0; i < grjNum; i++ {

		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_no", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_no"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_nm", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_nm"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_birth", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_birth"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_jiwon_fg", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_jiwon_fg"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_jiwon_prc", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_jiwon_prc"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".grj_bjg_sayu", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".grj_bjg_sayu"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__grjlist|"+strconv.Itoa(i)+".jiwon_yymm", jsonMap.Find("data.grjlist."+strconv.Itoa(i)+".jiwon_yymm"))
	}

	var docNum int
	docNum, err = strconv.Atoi(jsonMap.Find("data.dr_num"))
	for i := 1; i <= docNum; i++ {
		appendArrayString(jbd.arrayMap, "__ARRAY__dr_list.var"+strconv.Itoa(i), jsonMap.Find("data.dr_list.var"+strconv.Itoa(i)))
	}

	jString := reBuildJFormCheckBox(retJMap, checkSlice)
	retJMap, err = jsonlib.NewJsonMapFromBytes([]byte(jString))
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error3 : %v", err)}
	}

	jbd.stdKey = retJMap.Find(ci.standardJsonkey)
	jo.bulkMap[jbd.stdKey] = retJMap
	jo.ArrayMap[jbd.stdKey] = append(jo.ArrayMap[jbd.stdKey], jbd)

	return nil
}

// 벌크 데이터를 json파일로 만든다
func (jo *jsonObj) createBulkFile(ci *convInst) *perr.Error {

	fmt.Println("[BlabAgent][jsonData] _INFO : createBulkFile Start")

	buffer := &bytes.Buffer{}
	// json 파일 만들기

	// fmt.Println("[BlabAgent][jsonData] _INFO : createBulkFile [buffer1 : ", buffer, "]")

	for stdKey, slcBD := range jo.ArrayMap {

		data := strings.Replace(jo.bulkMap[stdKey].Print(), grjArrayForm, ci.getArrayFromSliceDRJsonBulkData(slcBD), 1)
		modData, terr := ci.modifyJsonData(data)
		if nil != terr {
			terr.Err = fmt.Errorf("modifyData() error : %v", terr.Err)
			return terr
		}
		// 버퍼 추가
		buffer.WriteString(fmt.Sprintf(insertBulkQuery, ci.orgCode, "\r\n", modData, "\r\n"))

		fmt.Println("[BlabAgent][jsonData] _INFO : createBulkFile no.bulkIndex ", jo.bulkIndex, "")
		fmt.Println("[BlabAgent][jsonData] _INFO : createBulkFile ci.maxBulkLength ", ci.maxBulkLength, "")
		jo.bulkIndex++
		if ci.maxBulkLength <= jo.bulkIndex {

			pathLock := ci.getBulkPath()
			err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
			if nil != err {
				return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
			}
			jo.appendBulkPath(pathLock)

			buffer.Reset()
			jo.InitBulkIndex()
		}
	}

	if 0 < jo.bulkIndex {
		pathLock := ci.getBulkPath()
		err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
		if nil != err {
			return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
		}
		jo.appendBulkPath(pathLock)
	}

	return nil
}

// 필요한 변수를 수정한다
func (ci *convInst) modifyJsonData(data string) (string, *perr.Error) {

	jsonMap, err := jsonlib.NewJsonMapFromBytes([]byte(data))
	if nil != err {
		return "", &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error4 : %v", err)}
	}

	var class, modClass string
	// 01: 모바일고지, 02: 실물고지, 03. 모바일-실물고지
	class = jsonMap.Find(ES_DISPATCHING_CLASS)
	switch class {
	case "01":
		modClass = "auto"
	case "02":
		modClass = "4"
	case "03":
		modClass = "auto"
	}
	jsonMap.Update(ES_DISPATCHING_CLASS, modClass)

	var dmflag []string
	for i := 0; i < jsonMap.Size(ES_DATA_GRJLIST); i++ {
		dmflag = append(dmflag, jsonMap.Find(fmt.Sprintf(ES_GRJLIST_GRJJIWONFG, i)))
	}
	dmtype := DMTYPE_01
	for i := 0; i < len(dmflag); i++ {
		if 0 == strings.Compare("02", dmflag[i]) {
			dmtype = DMTYPE_02
			break
		}
	}
	jsonMap.Update(ES_DISPATCHING_DM_TYPE, dmtype)

	if "auto" == modClass {
		jsonMap.Update(ES_AUTO_NONMEMBER, "dm")
	}

	var rcAddr1, rcAddr2 string
	rcAddr1 = jsonMap.Find(BLAB_RECEIVER_ADDR1)
	rcAddr2 = jsonMap.Find(BLAB_RECEIVER_ADDR2)

	if "" == rcAddr1 && "" == rcAddr2 {
		// do nothing
	} else if "" == rcAddr1 {
		jsonMap.Update(ES_RECEIVER_ADDR1, " ")
	} else if "" == rcAddr2 {
		jsonMap.Update(ES_RECEIVER_ADDR2, " ")
	}

	sdAddr1 := jsonMap.Find(BLAB_SENDER_ADDR1)
	sdAddr2 := jsonMap.Find(BLAB_SENDER_ADDR2)
	if "" == sdAddr1 && "" == sdAddr2 {
		// do nothing
	} else if "" == sdAddr1 {
		jsonMap.Update(ES_SENDER_ADDR1, " ")
	} else if "" == sdAddr2 {
		jsonMap.Update(ES_SENDER_ADDR2, " ")
	}

	jsonMap.Update(ES_SEARCH_GROUPBY, Utils.GetDate())

	// data-hash
	err = ci.encryptData(jsonMap)
	if nil != err {
		return "", &perr.Error{ERROR_CODE_ETC, fmt.Errorf("encryptData():: error : %v", err)}
	}

	return jsonMap.Print(), nil
}
