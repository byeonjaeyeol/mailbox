package Convert

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"strings"

	jsonlib "../../common/JsonSerializer"
	perr "../Error"
	"../FileUtils"
	"../Utils"
)

func (ci *convInst) convertUnstructuredData(samFile string, pdfFileList []string) error {
	var terr *perr.Error
	var err error
	var errCode string
	errCode = "0"

	var backupFile string
	var errorFile string
	backupFile = ci.getBackupPath(samFile)
	errorFile = backupFile + ".err"

	uo := NewUnstructuredObj()
	defer func() {
		if ci.checkMoniteringFlag() {
			ci.insertRecvResultStat(&uo.convObj, samFile, errCode)
		}
	}()

	var pdfFileLastName string
	var pdfFileFullPath string
	var bFind bool
	var pdfFileFullName string
	pdfFileLastName = getPdfFileLastName(samFile)
	pdfFileFullPath, bFind = fetchPdfFilePath(pdfFileLastName, pdfFileList)
	if !bFind {
		errCode, err = ERROR_CODE_ETC, errors.New("fetchPdfFilePath() : not find template file")
		goto _ERROR_PROC
	}
	pdfFileFullName = getPdfFileFullName(pdfFileFullPath)

	uo.SetPdfFileName(pdfFileFullName)
	uo.SetTemplateCode(ILJARI_UNSTRUCTERED_CODE)

	terr = uo.readBaseInfo(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("readBaseFile() : %v", terr.Err)
		goto _ERROR_PROC
	}

	terr = uo.convertSAM2Bulk(ci, samFile)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("convertSAM2Bulk() : %v", terr.Err)
		goto _ERROR_PROC
	}

	terr = uo.createBulkFile(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("createBulkFile() : %v", terr.Err)
		goto _ERROR_PROC
	}

	err = FileUtils.BackupFile(samFile, backupFile, GetBackupBufferSize())
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("BackupFile() : %v", err)
		goto _ERROR_PROC
	}

	err = Utils.UnlockFile(uo.oPath)
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("Utils::Unlock() : %v", err)
		goto _ERROR_PROC
	}

	err = ci.templateFileBackup(pdfFileFullPath)
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("templateFileBackup() : %v", err)
		goto _ERROR_PROC
	}

	return nil

_ERROR_PROC:
	if checkSAMFileError(errCode) {
		FileUtils.BackupFile(samFile, errorFile, GetBackupBufferSize())
	}

	Utils.RmlockFile(uo.oPath)

	return err
}

func (uo *unstructuredObj) readBaseInfo(ci *convInst) *perr.Error {
	var err error

	uo.dList, err = Utils.GetSliceFromFile(ci.getPathByExt(uo.templateCode, EXT_LIST), "\r\n")
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dList error : %v, baseFile : %v", err, ci.getPathByExt(uo.templateCode, EXT_LIST))}
	}

	uo.dForm, err = jsonlib.GetJsonBytes(ci.getPathByExt(uo.templateCode, EXT_FORM))
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dForm error : %v, baseFile : %v", err, ci.getPathByExt(uo.templateCode, EXT_FORM))}
	}

	return nil
}

func (uo *unstructuredObj) convertSAM2Bulk(ci *convInst, samFile string) *perr.Error {
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

		terr := uo.convertSingleSAMData(ci, samData[i])
		if nil != terr {
			terr.Err = fmt.Errorf("convertSingleSAMData():: error : %v, SAMData LineNumber : %v", terr.Err, i)
			return terr
		}
	}

	var recordLength int
	var documentLength int
	recordLength = len(samData) - blankLine
	documentLength = recordLength

	uo.SetDataLength(recordLength, documentLength)

	return nil
}

func (uo *unstructuredObj) convertSingleSAMData(ci *convInst, data string) *perr.Error {
	tokenList := strings.Split(data, DELIMITER_SAMFILE_DATA)
	if len(uo.dList)-1 != len(tokenList) {
		return &perr.Error{ERROR_CODE_DATA_FORMAT, fmt.Errorf("Mismatched length:: %v, List length : %v != Data length : %v",
			ci.getPathByExt(uo.templateCode, EXT_LIST), len(uo.dList)-1, len(tokenList))}
	}

	retJMap, err := jsonlib.NewJsonMapFromBytes(uo.dForm)
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error : %v", err)}
	}
	retJMap.Update(ES_DM_UNSTRUCTURED_FILENAME, uo.pdfFileName)

	for i := 0; i < len(uo.dList); i++ {
		if 0 == strings.Compare("", uo.dList[i]) {
			continue
		}

		key := uo.dList[i]
		val := tokenList[i]

		switch {
		case strings.Contains(key, "__IGNORE__"):
			continue

		case strings.Contains(key, "__DMTYPE__"):
			key, val = modUnstructuredDataDMType(key, val)
		}

		retJMap.Update(key, val)
	}

	err = checkUnstructuredData(retJMap)
	if err != nil {
		return &perr.Error{ERROR_CODE_DATA_INVALID, fmt.Errorf("checkUnstructuredData():: error : %v", err)}
	}

	uo.appendJUntDataList(retJMap)

	return nil
}

func checkUnstructuredData(jsonMap *jsonlib.JsonMap) error {
	var postDmType string
	postDmType = jsonMap.Find(ES_DISPATCHING_DM_TYPE)
	if postDmType != DMTYPE_01 && postDmType != DMTYPE_02 {
		return errors.New("Dmtype is invalid")
	}

	var postColor string
	postColor = jsonMap.Find(ES_DM_UNSTRUCTURED_COLOR)
	if postColor != "01" && postColor != "02" {
		return errors.New("Color is invalid")
	}

	var envelope string
	envelope = jsonMap.Find(ES_DM_UNSTRUCTURED_ENVELOPE)
	if envelope != "01" && envelope != "02" && envelope != "03" {
		return errors.New("Envelope is invalid")
	}

	return nil
}

func (uo *unstructuredObj) createBulkFile(ci *convInst) *perr.Error {
	buffer := &bytes.Buffer{}

	for _, jUntData := range uo.jUntDataList {
		modData, terr := ci.modifyUnstructuredData(jUntData)
		if nil != terr {
			terr.Err = fmt.Errorf("checkUnstructuredData() error : %v", terr.Err)
			return terr
		}
		buffer.WriteString(fmt.Sprintf(insertBulkQuery, ci.orgCode, "\r\n", modData, "\r\n"))

		uo.bulkIndex++
		if ci.maxBulkLength <= uo.bulkIndex {
			pathLock := ci.getBulkPath()
			err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
			if nil != err {
				return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
			}
			uo.appendBulkPath(pathLock)

			buffer.Reset()
			uo.InitBulkIndex()
		}
	}

	if 0 < uo.bulkIndex {
		pathLock := ci.getBulkPath()
		err := FileUtils.WriteFile_CreateByBuffer(pathLock, buffer)
		if nil != err {
			return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("FileUtils::WriteFile_CreateByBuffer() error : %v, path : %v", err, pathLock)}
		}
		uo.appendBulkPath(pathLock)
	}

	return nil
}

func (ci *convInst) modifyUnstructuredData(jsonMap *jsonlib.JsonMap) (string, *perr.Error) {
	var class, modClass string
	class = jsonMap.Find(ES_DISPATCHING_CLASS)
	if "01" == class {
		modClass = "4"
	}
	jsonMap.Update(ES_DISPATCHING_CLASS, modClass)

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

	var sriNm, sejNm string
	sriNm = jsonMap.Find(ES_RECEIVER_NAME)
	sejNm = jsonMap.Find(ES_DATA_SEJ_NM)

	if "" == sriNm || "" == sejNm {
		// do nothing
	} else {
		jsonMap.Update(ES_DATA_SEJ_NM, fmt.Sprintf(receiverNmForm, sejNm, sriNm))
	}

	var jisaTel string
	jisaTel = jsonMap.Find(ES_SENDER_TEL)
	if "" == jisaTel {
		jsonMap.Update(ES_SENDER_TEL, LAYOUT_SAM_JISATEL)
	}

	var url string
	url = jsonMap.Find(ES_DATA_URL)
	if "" == url {
		jsonMap.Update(ES_DATA_URL, LAYOUT_SAM_URL)
	}

	jsonMap.Update(ES_SEARCH_GROUPBY, Utils.GetDate())

	err := ci.encryptData(jsonMap)
	if nil != err {
		return "", &perr.Error{ERROR_CODE_ETC, fmt.Errorf("encryptData():: error : %v", err)}
	}

	return jsonMap.Print(), nil
}

func (ci *convInst) templateFileBackup(pdfFileFullPath string) error {
	var templateFileServerPath string
	templateFileServerPath = ci.getTemplatePath(pdfFileFullPath)

	if _, e := os.Stat(templateFileServerPath); os.IsNotExist(e) {
		// do nothing
	} else {
		return nil
	}

	err := FileUtils.BackupFile(pdfFileFullPath, templateFileServerPath, GetBackupBufferSize())
	if nil != err {
		return fmt.Errorf("BackupFile() : %v", err)
	}

	return nil
}
