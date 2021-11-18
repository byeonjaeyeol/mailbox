package Convert

import (
	"errors"
	"strconv"
	"strings"
	"time"

	"../Config"
)

type convInst struct {
	frequency        int
	backupBufferSize int
	compareTerm      int
	monitoringFlag   string

	orgCode        string
	deptCode       string
	maxArrayLength int
	maxBulkLength  int
	processingTime string
	agencyID       int

	standardJsonkey   string
	encoding          string
	baseDirectory     string
	outputPath        string
	backupDirectory   string
	optionDirectory   string
	templateDirectory string

	StopChannel chan interface{}
}

func (ci *convInst) convInit() error {
	// collect init
	ci.orgCode = Config.GetValue("collect.agency.orgcode")
	ci.deptCode = Config.GetValue("collect.agency.deptcode")
	ci.processingTime = Config.GetValue("collect.agency.proctime")
	ci.standardJsonkey = Config.GetValue("collect.reqid")
	ci.encoding = Config.GetValue("collect.encoding")
	ci.baseDirectory = Config.GetValue("collect.basedir")
	ci.outputPath = Config.GetValue("collect.outputpath")
	ci.backupDirectory = Config.GetValue("collect.backupdir")
	ci.optionDirectory = Config.GetValue("collect.optiondir")
	ci.templateDirectory = Config.GetValue("collect.templatedir")
	ci.monitoringFlag = Config.GetValue("collect.monitoring")

	tmp, err := strconv.Atoi(Config.GetValue("collect.freq_sec"))
	if nil != err {
		return errors.New("collect frequency error : " + err.Error())
	}
	ci.frequency = tmp

	tmp, err = strconv.Atoi(Config.GetValue("collect.buffersize"))
	if nil != err {
		return errors.New("collect bufferSize error : " + err.Error())
	}
	ci.backupBufferSize = tmp

	tmp, err = strconv.Atoi(Config.GetValue("collect.compareterm"))
	if nil != err {
		return errors.New("collect compareTerm error : " + err.Error())
	}
	ci.compareTerm = tmp

	tmp, err = strconv.Atoi(Config.GetValue("collect.agency.maxarraylength"))
	if nil != err {
		return errors.New("collect agency maxArrayLength error : " + err.Error())
	}
	ci.maxArrayLength = tmp

	tmp, err = strconv.Atoi(Config.GetValue("collect.agency.maxbulklength"))
	if nil != err {
		return errors.New("collect agency maxBulkLength error : " + err.Error())
	}
	ci.maxBulkLength = tmp

	tmp, err = strconv.Atoi(Config.GetValue("collect.agency.db_idx"))
	if nil != err {
		return errors.New("collect agency index error : " + err.Error())
	}
	ci.agencyID = tmp

	return nil
}

func (ci *convInst) isProcTime() bool {
	for _, ptime := range strings.Split(ci.processingTime, ",") {
		pt, _ := strconv.Atoi(strings.ReplaceAll(ptime, " ", ""))

		t := time.Now()
		if t.Hour() == pt {
			return true
		}
	}
	return false
}

func (ci *convInst) checkMoniteringFlag() bool {
	if "Y" == ci.monitoringFlag {
		return true
	}
	return false
}

func checkSAMFileError(errCode string) bool {
	if ERROR_CODE_JSON_PARSE == errCode || ERROR_CODE_DATA_FORMAT == errCode || ERROR_CODE_DATA_INVALID == errCode {
		return true
	}
	return false
}

func errorResultProc(errCode string) (string, string) {
	var error_YN string
	var error_string string

	switch errCode {
	case "0":
		error_YN = "N"

	case ERROR_CODE_JSON_PARSE:
		error_YN = "Y"
		error_string = "Json 형식 변환 과정 오류"

	case ERROR_CODE_DATA_FORMAT:
		error_YN = "Y"
		error_string = "데이터 서식 불일치"

	case ERROR_CODE_DATA_INVALID:
		error_YN = "Y"
		error_string = "유효하지 않은 데이터 입력"

	case ERROR_CODE_DB:
		error_YN = "Y"
		error_string = "데이터베이스 오류"

	case ERROR_CODE_ETC:
		error_YN = "Y"
		error_string = "기타 오류"
	}

	return error_YN, error_string
}
