package Logger

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"

	"../JsonSerializer"
)

// GetName : attribute name
func GetName(i32Index int32) string {
	return GetInstance().Logs[i32Index].Name
}

// GetRotationFreq : attribute rotation freq
func GetRotationFreq(i32Index int32) int64 {
	return GetInstance().Logs[i32Index].RotationFreq
}

// LoadConfig : read log config file
func LoadConfig(file string) error {
	o := GetInstance()

	jsonFile, err := os.Open(file)
	if nil != err {
		return err
	}
	defer jsonFile.Close()

	val, err := ioutil.ReadAll(jsonFile)
	if nil != err {
		return err
	}

	c := LoggerObject{}
	err = JsonSerializer.FromJson(val, &c)
	if nil != err {
		return err
	}

	o.Logs = c.Logs

	for _, log := range o.Logs {
		if FORMAT_STD_OUT == log.Format {
			continue
		}
		cerr := PreCreatePath(&log)
		if nil != cerr {
			return cerr
		}
	}
	return nil
}

// LoadConfig : read log config file
func LoadConfig_json(jsonString string) error {
	o := GetInstance()
	c := LoggerObject{}
	err := JsonSerializer.FromJson([]byte(jsonString), &c)
	if nil != err {
		return err
	}

	o.Logs = c.Logs

	for _, log := range o.Logs {
		if FORMAT_STD_OUT == log.Format {
			continue
		}
		cerr := PreCreatePath(&log)
		if nil != cerr {
			return cerr
		}
	}
	return nil
}

// WriteLog : write log text/json
func WriteLog(strName string, i32Level int32, args ...interface{}) {
	o := GetInstance()
	idx := FindNameIdx(strName, o)
	if idx == -1 {
		return
	}

	if o.Logs[idx].Level < i32Level {
		return
	}

	logText := CompileLogstring(args)

	if FORMAT_TEXT_FILE == o.Logs[idx].Format {
		dt := time.Now().Local()
		logFileExtIdx := strings.LastIndex(o.Logs[idx].Path, ".")
		logFile := string(o.Logs[idx].Path[0:logFileExtIdx]) + "." + fmt.Sprint(dt.Format("2006-01-02")) + ".log"
		WriteFile(logText, logFile)
	} else if FORMAT_STD_OUT == o.Logs[idx].Format {
		WriteConsole(logText)
	}
}

// WriteLog : write log text/json
func WriteLogr(strName string, i32Level int32, args ...interface{}) {
	o := GetInstance()

	idx := FindNameIdx(strName, o)
	if idx == -1 {
		return
	}

	if o.Logs[idx].Level < i32Level {
		return
	}

	var i64TmCurrent int64
	i64TmCurrent = time.Now().Unix()
	if o._tryRotate(int32(idx), i64TmCurrent) == false {

	}

	strText := CompileLogstring(args)

	if FORMAT_TEXT_FILE == o.Logs[idx].Format {
		strFilePath := fmt.Sprintf("%v/%v.txt", o.Logs[idx].Path, o.Logs[idx].Name)
		// write file log
		WriteFile(strText, strFilePath)
	} else if FORMAT_STD_OUT == o.Logs[idx].Format {
		// write stdout log
		WriteConsole(strText)
	}
}

func WriteAccessLog(logName string, logLevel int32, r *http.Request, tmBegin int64, error_code string, pcode string) {
	tmEnd := time.Now().Local().UnixNano() / int64(time.Millisecond)
	tmTaken := tmEnd - tmBegin

	logText := fmt.Sprintf("%v\t%v\t%v\t%v\t%v\t%v\t%v",
		r.Method,
		r.RequestURI,
		tmTaken,
		r.Header.Get("content-length"),
		error_code,
		pcode,
		r.Header.Get("User-Agent"),
	)

	// write log
	WriteLogr(logName, logLevel, logText)
}
