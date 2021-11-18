package Authorization

import (
	"fmt"
	"sync"

	jsonlib "../../common/JsonSerializer"
)

var instance *authorPolicy
var once sync.Once

type authorPolicy struct {
	enable    bool
	timeout   int64
	authorMap map[string]author
	bm        *blackListManager

	mutex *sync.Mutex
}

type author struct {
	uri        string
	agent      string
	ipList     []ipAddrRange
	hmacEnable bool
}

type ipAddrRange struct {
	from string
	to   string
}

type blackListManager struct {
	stopChannel   chan interface{}
	frequency_sec int

	blackList         map[string]int64
	blackList_TimeOut int64

	failedList         map[string]failedLog
	failedList_TimeOut int64
	limitFailedCount   int
}

type failedLog struct {
	failedCount    int
	lastAccessTime int64
}

func getInstance() *authorPolicy {
	once.Do(func() {
		instance = &authorPolicy{
			authorMap: make(map[string]author),
			mutex:     &sync.Mutex{},
			bm: &blackListManager{
				blackList:   make(map[string]int64),
				failedList:  make(map[string]failedLog),
				stopChannel: make(chan interface{}),
			},
		}
	})
	return instance
}

func Initialize(filePath string) error {
	au := getInstance()

	jMap, err := jsonlib.NewJsonMapFromFile(filePath)
	if nil != err {
		return fmt.Errorf("Open Json File Failed - path : %v, error : %v", filePath, err)
	}

	err = authorPolicyInit(jMap)
	if nil != err {
		return fmt.Errorf("Author Init Error - path : %v, error : %v", filePath, err)
	}

	err = blackListManagerInit(jMap)
	if nil != err {
		return fmt.Errorf("BlackList Init Error- path : %v, error : %v", filePath, err)
	}

	// go routine
	go au.bm.timeoutThread()

	return nil
}

func Finalize() {
	au := getInstance()

	au.bm.stopChannel <- 1
	<-au.bm.stopChannel

	close(au.bm.stopChannel)
}
