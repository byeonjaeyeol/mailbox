package ProcMemory

import (
	"fmt"
	"sync"
	"time"

	"../../common/Util"
)

type Memory struct {
	startTime int64
}

var instance *Memory
var once sync.Once

func GetInstance() *Memory {
	once.Do(func() {
		instance = &Memory{}
	})
	return instance
}

func Init() {
	m := GetInstance()
	m.startTime = time.Now().Unix()
}

func Fin() {
	// do nothing
}

func GetModuleStartTime() string {
	time, _ := Util.I64UnixTimeTo(GetInstance().startTime)
	return time
}

func GetModuleUptime() string {
	return fmt.Sprintf("%v", time.Since(time.Unix(GetInstance().startTime, 0)))
}
