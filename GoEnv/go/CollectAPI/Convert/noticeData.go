package Convert

import (
	"bytes"
	"fmt"
	"strings"

	jsonlib "../../common/JsonSerializer"
	perr "../Error"
	"../FileUtils"
	"../RDBMS"
	"../Utils"
)

func (ci *convInst) convertNoticeData(samFile string) error {
	var terr *perr.Error
	var err error
	var errCode string
	errCode = "0"

	var backupFile string
	var errorFile string
	backupFile = ci.getBackupPath(samFile)
	errorFile = backupFile + ".err"

	no := NewNoticeObj()
	defer func() {
		if ci.checkMoniteringFlag() {
			ci.insertRecvResultStat(&no.convObj, samFile, errCode)
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
	//maxlen := len(codes)
	for _, code := range codes {
		no.SetTemplateCode(code)
		terr = no.readBaseInfo(ci)
		if nil != terr {
			//errCode, err = terr.ErrCode, fmt.Errorf("readBaseFile() : %v", terr.Err)
			continue
		}

		terr = no.convertSAM2Bulk(ci, samFile)
		if nil != terr {
			//errCode, err = terr.ErrCode, fmt.Errorf("convertSAM2Bulk() : %v", terr.Err)
			continue
		}

		terr = no.createBulkFile(ci)
		if nil != terr {
			errCode, err = terr.ErrCode, fmt.Errorf("createBulkFile() : %v", terr.Err)
			goto _ERROR_PROC
			//continue
		}

		err = FileUtils.BackupFile(samFile, backupFile, GetBackupBufferSize())
		if nil != err {
			errCode, err = ERROR_CODE_ETC, fmt.Errorf("BackupFile() : %v", err)
			goto _ERROR_PROC
			//continue
		}

		err = Utils.UnlockFile(no.oPath)
		if nil != err {
			errCode, err = ERROR_CODE_ETC, fmt.Errorf("Utils::Unlock() : %v", err)
			goto _ERROR_PROC
			//continue
		}
	}

	//end..

	return nil

_ERROR_PROC:
	if checkSAMFileError(errCode) {
		FileUtils.BackupFile(samFile, errorFile, GetBackupBufferSize())
	}

	Utils.RmlockFile(no.oPath)

	return err
}

func (no *noticeObj) readBaseInfo(ci *convInst) *perr.Error {
	var err error

	no.dList, err = Utils.GetSliceFromFile(ci.getPathByExt(no.templateCode, EXT_LIST), "\r\n")
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dList error : %v, baseFile : %v", err, ci.getPathByExt(no.templateCode, EXT_LIST))}
	}

	no.dForm, err = jsonlib.GetJsonBytes(ci.getPathByExt(no.templateCode, EXT_FORM))
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dForm error : %v, baseFile : %v", err, ci.getPathByExt(no.templateCode, EXT_FORM))}
	}

	no.jCheck, err = jsonlib.NewJsonMapFromFile(ci.getPathByExt(no.templateCode, EXT_CHECKBOX))
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load jCheck error : %v, baseFile : %v", err, ci.getPathByExt(no.templateCode, EXT_CHECKBOX))}
	}

	return nil
}

func (no *noticeObj) convertSAM2Bulk(ci *convInst, samFile string) *perr.Error {
	samData, err := ci.getDataInfo(samFile)
	if nil != err {
		return &perr.Error{ERROR_CODE_DATA_FORMAT, fmt.Errorf("getDataInfo():: error : %v", err)}
	}

	var blankLine int
	for i := 0; i < len(samData); i++ {
		if 0 == strings.Compare("", samData[i]) {
			blankLine++
			continue
		}

		terr := no.convertSingleSAMData(ci, samData[i])
		if nil != terr {
			terr.Err = fmt.Errorf("convertSingleSAMData():: error : %v, SAMData LineNumber : %v", terr.Err, i)
			return terr
		}
	}

	var recordLength int
	var documentLength int
	recordLength = len(samData) - blankLine
	documentLength = len(no.ArrayMap)

	no.SetDataLength(recordLength, documentLength)

	return nil
}

func (no *noticeObj) convertSingleSAMData(ci *convInst, data string) *perr.Error {
	tokenList := strings.Split(data, DELIMITER_SAMFILE_DATA)
	if len(no.dList)-1 != len(tokenList) {
		return &perr.Error{ERROR_CODE_DATA_FORMAT, fmt.Errorf("Mismatched length:: %v, List length : %v != Data length : %v",
			ci.getPathByExt(no.templateCode, EXT_LIST), len(no.dList)-1, len(tokenList))}
	}

	retJMap, err := jsonlib.NewJsonMapFromBytes(no.dForm)
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error : %v", err)}
	}

	bd := bulkData{
		arrayMap: make(map[string][]string),
	}
	flagMap := make(map[string][]string)

	var checkSlice []string
	for i := 0; i < len(no.dList); i++ {
		if 0 == strings.Compare("", no.dList[i]) {
			continue
		}

		key := no.dList[i]
		val := tokenList[i]

		switch {
		case strings.Contains(key, "__IGNORE__"):
			continue

		case strings.Contains(key, "__FLAG__"):
			appendFlagContents(flagMap, key, val)
			continue

		case strings.Contains(key, "__ARRAY__"):
			appendArrayString(bd.arrayMap, key, val)
			continue

		case strings.Contains(key, "__CHECKBOX__"):
			no.appendCheckBoxString(&checkSlice, key, val)
			key = strings.Replace(key, "__CHECKBOX__", "", 1)
			key = no.jCheck.Find(fmt.Sprintf("%v.key", key))

		case strings.Contains(key, "__FORMAT__"):
			if(strings.Contains(key, ES_DATA_IJGWANRINO)){
				retJMap.Update(ES_DATA_REQUEST_ID, fmt.Sprintf("%s-%s-%s", ci.deptCode, tokenList[0],val))
			}
			key, val = modFormatGwanriNo(key, val)

		case 0 == strings.Compare(key, ci.standardJsonkey):
			val = modFormatStandardKey(ci.deptCode, val)

		//todo check form.. templeate
		case 0 == strings.Compare(key, ES_DATA_SIHAENG_DT):
			retJMap.Update(ES_DATA_SIHAENG_DT_MM, val[4:6])
		}

		retJMap.Update(key, val)
	}
	//todo check
	//updateFlagContents(retJMap, flagMap)

	//process checkbox
	jString := reBuildJFormCheckBox(retJMap, checkSlice)
	retJMap, err = jsonlib.NewJsonMapFromBytes([]byte(jString))
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error : %v", err)}
	}

	bd.stdKey = retJMap.Find(ci.standardJsonkey)
	no.bulkMap[bd.stdKey] = retJMap
	no.ArrayMap[bd.stdKey] = append(no.ArrayMap[bd.stdKey], bd)

	return nil
}

func (no *noticeObj) createBulkFile(ci *convInst) *perr.Error {
	buffer := &bytes.Buffer{}

	for stdKey, slcBD := range no.ArrayMap {
		data := strings.Replace(no.bulkMap[stdKey].Print(), arrayForm, ci.getArrayFromSliceBulkData(slcBD), 1)
		modData, terr := ci.modifyNoticeData(data)
		if nil != terr {
			terr.Err = fmt.Errorf("modifyData() error : %v", terr.Err)
			return terr
		}
		buffer.WriteString(fmt.Sprintf(insertBulkQuery, ci.orgCode, "\r\n", modData, "\r\n"))

		no.bulkIndex++
		if ci.maxBulkLength <= no.bulkIndex {
			pathLock := ci.getBulkPath()
			err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
			if nil != err {
				return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
			}
			no.appendBulkPath(pathLock)

			buffer.Reset()
			no.InitBulkIndex()
		}
	}

	if 0 < no.bulkIndex {
		pathLock := ci.getBulkPath()
		err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
		if nil != err {
			return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
		}
		no.appendBulkPath(pathLock)
	}

	return nil
}

func (ci *convInst) modifyNoticeData(data string) (string, *perr.Error) {
	jsonMap, err := jsonlib.NewJsonMapFromBytes([]byte(data))
	if nil != err {
		return "", &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error : %v", err)}
	}

	var class, modClass string
	//todo auto,
	class = jsonMap.Find(ES_DISPATCHING_CLASS)
	switch class {
	case "01":  //email
		//modClass = "8"
		modClass = "auto"
	case "02":  //우편
		modClass = "4"
	case "03": //sms
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
	rcAddr1 = jsonMap.Find(ES_RECEIVER_ADDR1)
	rcAddr2 = jsonMap.Find(ES_RECEIVER_ADDR2)

	if "" == rcAddr1 && "" == rcAddr2 {
		// do nothing
	} else if "" == rcAddr1 {
		jsonMap.Update(ES_RECEIVER_ADDR1, " ")
	} else if "" == rcAddr2 {
		jsonMap.Update(ES_RECEIVER_ADDR2, " ")
	}

	sdAddr1 := jsonMap.Find(ES_SENDER_ADDR1)
	sdAddr2 := jsonMap.Find(ES_SENDER_ADDR2)
	if "" == sdAddr1 && "" == sdAddr2 {
		// do nothing
	} else if "" == sdAddr1 {
		jsonMap.Update(ES_SENDER_ADDR1, " ")
	} else if "" == sdAddr2 {
		jsonMap.Update(ES_SENDER_ADDR2, " ")
	}

	var sriNm, dpjNm string
	sriNm = jsonMap.Find(ES_RECEIVER_NAME)
	dpjNm = jsonMap.Find(ES_DATA_DPJ_NM)

	if "" == dpjNm {
		// do nothing
	} else if "" == sriNm {
		jsonMap.Update(ES_RECEIVER_NAME, dpjNm)
	} else {
		jsonMap.Update(ES_RECEIVER_NAME, fmt.Sprintf(receiverNmForm, sriNm, dpjNm))
	}

	jsonMap.Update(ES_SEARCH_GROUPBY, Utils.GetDate())

	err = ci.encryptData(jsonMap)
	if nil != err {
		return "", &perr.Error{ERROR_CODE_ETC, fmt.Errorf("encryptData():: error : %v", err)}
	}

	return jsonMap.Print(), nil
}
