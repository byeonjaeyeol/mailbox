package AutoRemove

import (
	"sync"
	"time"
)

var instance *rmConfig
var once sync.Once

func getInstance() *rmConfig {
	once.Do(func() {
		instance = &rmConfig{}
	})
	return instance
}

func Initialize() error {
	err := getInstance().rmInit()
	if nil != err {
		return err
	}
	return nil
}

func GetFrequency() time.Duration {
	return time.Duration(getInstance().frequency)
}

func RunFileRemover() {
	rc := getInstance()
	rc.StopChannel = make(chan interface{})

	for {
		for _, v := range rc.rmList {
			v.removeFile()
		}

		if waitForChannel() {
			break
		}
	}

	rc.StopChannel <- 1
}

func waitForChannel() bool {
	select {
	case <-getInstance().StopChannel:
		return true
	case <-time.After(time.Hour * GetFrequency()):
	}
	return false
}

func Fin() {
	rc := getInstance()

	rc.StopChannel <- 1

	<-rc.StopChannel

	close(rc.StopChannel)
}
