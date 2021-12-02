package Logger

import (
	"fmt"
	"sync"

	"../Util"
)

var FORMAT_TEXT_FILE string = "textfile"
var FORMAT_STD_OUT string = "stdout"

// haebo 2021-12-02 yaml tag 추가

type LogObject struct {
	Name         string `json:"name" yaml:"name"`
	Path         string `json:"path" yaml:"path"`
	Level        int32  `json:"level" yaml:"level"`
	Format       string `json:"format" yaml:"format"`
	TmCreated    int64
	RotationCnt  int32 `json:"rotationCnt" yaml:"rotationCnt"`
	RotationFreq int64 `json:"rotationFreq" yaml:"rotationFreq"`
}

// LoggerObject object : slice of Log
type LoggerObject struct {
	Logs []LogObject `json:"logs" yaml:"logs"`
}

var instance *LoggerObject
var once sync.Once

// GetInstance : instance
func GetInstance() *LoggerObject {
	once.Do(func() {
		instance = &LoggerObject{}
	})
	return instance
}

func (o *LoggerObject) _tryRotate(i32Index int32, i64TmCurrent int64) bool {

	if o.Logs[i32Index].RotationCnt == 0 {
		return false
	}

	strMetaFilePath := fmt.Sprintf("%v/%v.meta", o.Logs[i32Index].Path, o.Logs[i32Index].Name)

	if o.Logs[i32Index].TmCreated == 0 {
		if Util.ExistPath(strMetaFilePath) == true {
			strCTime, _ := ReadFromMetaFile(strMetaFilePath)
			o.Logs[i32Index].TmCreated, _ = Util.StringToI64(strCTime)
		} else {
			o.Logs[i32Index].TmCreated = i64TmCurrent
			WriteToMetaFile(Util.I64ToString(o.Logs[i32Index].TmCreated), strMetaFilePath)
		}
	}

	if o.Logs[i32Index].TmCreated > 0 {
		i64TempCTime := (o.Logs[i32Index].TmCreated / o.Logs[i32Index].RotationFreq) * o.Logs[i32Index].RotationFreq
		i64TempCurTime := (i64TmCurrent / o.Logs[i32Index].RotationFreq) * o.Logs[i32Index].RotationFreq

		if i64TempCTime < i64TempCurTime {
			strLastFilePath := fmt.Sprintf("%v/%v.txt.%v", o.Logs[i32Index].Path, o.Logs[i32Index].Name, o.Logs[i32Index].RotationCnt)
			if Util.ExistPath(strLastFilePath) == true {
				Util.Remove(strLastFilePath)
			}

			var i32 int32
			for i32 = o.Logs[i32Index].RotationCnt - 1; i32 >= 0; i32-- {
				var strNextFilePath string
				var strPreFilePath string
				if i32 == 0 {
					strPreFilePath = fmt.Sprintf("%v/%v.txt", o.Logs[i32Index].Path, o.Logs[i32Index].Name)
					strNextFilePath = fmt.Sprintf("%v/%v.txt.%v", o.Logs[i32Index].Path, o.Logs[i32Index].Name, i32+1)
					//strPreFilePath = o.Logs[i32Index].Path + "/" + o.Logs[i32Index].Name + ".txt"
					//strNextFilePath = o.Logs[i32Index].Path + "/" + o.Logs[i32Index].Name + ".txt." + I32ToString(i32+1)
					o.Logs[i32Index].TmCreated = i64TmCurrent
					WriteToMetaFile(fmt.Sprintf("%v", o.Logs[i32Index].TmCreated), strMetaFilePath)
					//I64ToString(i64TmCreated), strMetaFilePath)
				} else {
					strPreFilePath = fmt.Sprintf("%v/%v.txt.%v", o.Logs[i32Index].Path, o.Logs[i32Index].Name, i32)
					strNextFilePath = fmt.Sprintf("%v/%v.txt.%v", o.Logs[i32Index].Path, o.Logs[i32Index].Name, i32+1)
					//strPreFilePath = o.Logs[i32Index].Path + "/" + o.Logs[i32Index].Name + ".txt." + I32ToString(i32)
					//strNextFilePath = o.Logs[i32Index].Path + "/" + o.Logs[i32Index].Name + ".txt." + I32ToString(i32+1)
				}

				//fmt.Println("PRE:" + strPreFilePath)
				//fmt.Println("NEXT:" + strNextFilePath)
				if Util.ExistPath(strPreFilePath) == true {
					if Util.Rename(strPreFilePath, strNextFilePath) == false {
						fmt.Println("rename error")
					}
				}
			}
			return true
		}
	} else {
		fmt.Println("New LogFile.....")
	}
	return false
}
