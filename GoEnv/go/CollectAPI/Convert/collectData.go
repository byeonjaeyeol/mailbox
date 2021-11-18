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

func (ci *convInst) convertCollectData(agencyID int) (error, int) {
	var terr *perr.Error
	var err error
	var errCode string
	var count int
	count = 0
	errCode = "0"

	// fmt.Println(errCode)

	// var backupFile string
	// var errorFile string
	// backupFile = ci.getBackupPath("collectAPI.json")
	// errorFile = backupFile + ".err"

	jo := NewJsonObj()
	defer func() {
		if ci.checkMoniteringFlag() {
			// ci.insertRecvResultStat(&jo.convObj, strconv.Itoa(agencyID), errCode)
		}
	}()

	jo.SetTemplateCode("collect")

	terr = jo.readCollectBaseInfo(ci)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("readBaseFile() : %v", terr.Err)
		goto _ERROR_PROC
	}

	terr, count = jo.collectSingleJsonData(ci, agencyID)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("collectSingleJsonData() : %v", terr.Err)
		goto _ERROR_PROC
	}

	terr = jo.createCollectFile(ci, agencyID)
	if nil != terr {
		errCode, err = terr.ErrCode, fmt.Errorf("createCollectFile() : %v", terr.Err)
		goto _ERROR_PROC
	}

	// 파일 락 해제
	err = Utils.UnlockFile(jo.oPath)
	if nil != err {
		errCode, err = ERROR_CODE_ETC, fmt.Errorf("Utils::Unlock() : %v", err)
		goto _ERROR_PROC
	}
	fmt.Println("End Proc")
	return nil, count

_ERROR_PROC:
	Utils.RmlockFile(jo.oPath)

	fmt.Println("Error Proc", errCode, ":", err)

	return err, count
}

func (jo *jsonObj) readCollectBaseInfo(ci *convInst) *perr.Error {
	var err error

	jo.dForm, err = jsonlib.GetJsonBytes(ci.getPathByExt(jo.templateCode, EXT_FORM))
	if nil != err {
		return &perr.Error{ERROR_CODE_ETC, fmt.Errorf("load dForm error : %v, baseFile : %v", err, ci.getPathByExt(jo.templateCode, EXT_FORM))}
	}

	return nil
}

func (jo *jsonObj) collectSingleJsonData(ci *convInst, agencyID int) (*perr.Error, int) {

	// fmt.Println("[CollectAPI][collectData] _INFO : convertSingleJsonData Start ", agencyID, ":")
	retJMap, err := jsonlib.NewJsonMapFromBytes(jo.dForm)
	// fmt.Println("[CollectAPI][collectData] _INFO : convertSingleJsonData [retJMap1 : ", retJMap, "]")
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error1 : %v", err)}, 0
	}

	jsonMap, cnt, err := RDBMS.GetCollectData(agencyID)
	// fmt.Println("[CollectAPI][collectData] _INFO : GetCollectData [jsonMap : ", jsonMap, "]")
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::GetCollectData():: error2 : %v", err)}, 0
	}

	jbd := jsonBulkData{
		arrayMap: make(map[string][]string),
	}

	var checkSlice []string

	// 해당 값을 form 에 맞춰서 입력하기

	for i := 0; i < cnt; i++ {

		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".pi", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".pi"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".ci", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".ci"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".mi", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".mi"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".name", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".name"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".hp", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".hp"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".email", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".email"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".birth", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".birth"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".gender", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".gender"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".use_yn", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".use_yn"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".collect_yn", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".collect_yn"))
		appendArrayGRJString(jbd.arrayMap, "__ARRAY__users|"+strconv.Itoa(i)+".sync_dt", jsonMap.Find("collect_"+strconv.Itoa(agencyID)+"."+strconv.Itoa(i)+".sync_dt"))

	}
	retJMap.Update("count", cnt)

	// fmt.Println("[CollectAPI][collectData] _INFO : convertSingleJsonData [jbd.arrayMap : ", jbd.arrayMap, "]")

	jString := reBuildJFormCheckBox(retJMap, checkSlice)
	retJMap, err = jsonlib.NewJsonMapFromBytes([]byte(jString))
	if nil != err {
		return &perr.Error{ERROR_CODE_JSON_PARSE, fmt.Errorf("JsonSerializer::NewJsonMapFromBytes():: error3 : %v", err)}, 0
	}

	jbd.stdKey = retJMap.Find(ci.standardJsonkey)
	jo.bulkMap[jbd.stdKey] = retJMap
	jo.ArrayMap[jbd.stdKey] = append(jo.ArrayMap[jbd.stdKey], jbd)

	return nil, cnt
}

func (jo *jsonObj) createCollectFile(ci *convInst, agencyID int) *perr.Error {

	fmt.Println("[BlabAgent][jsonData] _INFO : createBulkFile Start")
	buffer := &bytes.Buffer{}
	// json 파일 만들기

	for stdKey, slcBD := range jo.ArrayMap {

		data := strings.Replace(jo.bulkMap[stdKey].Print(), collectArrayForm, ci.getArrayFromSliceDRJsonBulkData(slcBD), 1)

		// 버퍼 추가
		buffer.WriteString(fmt.Sprint(data))

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
