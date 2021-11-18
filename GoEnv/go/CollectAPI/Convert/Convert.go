package Convert

import (
	"sync"
	"time"

	jsonlib "../../common/JsonSerializer"
)

var instance *convInst
var once sync.Once

func getInstance() *convInst {
	once.Do(func() {
		instance = &convInst{}
	})
	return instance
}

func Initialize() error {
	err := getInstance().convInit()
	if nil != err {
		return err
	}
	return nil
}

func GetFrequency() time.Duration {
	return time.Duration(getInstance().frequency)
}

func GetBackupBufferSize() int {
	return getInstance().backupBufferSize
}

func RunConvertFile() {
	ci := getInstance()
	ci.StopChannel = make(chan interface{})

	for {

		if ci.isProcTime() {
			ci.convertFile()
		}

		if waitForChannel() {
			break
		}
	}

	ci.StopChannel <- 1
}

func RunConvertWeb(jsonData *jsonlib.JsonMap, count int) string {
	ci := getInstance()
	ci.StopChannel = make(chan interface{})

	for {

		if count > 0 {

			if nil == jsonData {
				return "convert Error jsonData is null"
			}

			convertResult := ci.convertWeb(jsonData, count)

			return convertResult
		}

		if waitForWebChannel() {
			break
		}
	}

	ci.StopChannel <- 1

	return ""
}

func waitForChannel() bool {
	select {
	case <-getInstance().StopChannel:
		return true
	case <-time.After(time.Second * GetFrequency()):
	}
	return false
}

func waitForWebChannel() bool {
	select {
	case <-getInstance().StopChannel:
		return true
	}
	return false
}

func Fin() {
	ci := getInstance()

	ci.StopChannel <- 1

	<-ci.StopChannel

	close(ci.StopChannel)
}
