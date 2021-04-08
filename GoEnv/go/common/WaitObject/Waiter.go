package WaitObject

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"../Concurrent"
	"../Task"
)

type waitObject struct {
	counter         Concurrent.CounterInt64
	SigResult       os.Signal
	sigEventChannel chan os.Signal
}

var instance *waitObject
var once sync.Once

func GetInstance() *waitObject {
	once.Do(func() {
		instance = &waitObject{}
	})
	return instance
}

func Add() {
	GetInstance().counter.Increase()
}

func Remove() {
	GetInstance().counter.Decrease()
}

func GetSignal() os.Signal {
	return GetInstance().SigResult
}

func SendSignal(sig os.Signal) {
	GetInstance().sigEventChannel <- sig
}

func Waiting(t *Task.Task) {
	Add()
	GetInstance().sigEventChannel = make(chan os.Signal, 1)
	go GetInstance().handleSignals()

_START_SECTION:
	select {
	case <-time.After(time.Second):
		if 0 == GetInstance().counter.Get() {
			goto _EXIT
		}
		if nil != t {
			t.SetIgnore(true)
			t.InvokeTask(nil)
		} else {
			// do nothing
		}
		goto _START_SECTION
	}
_EXIT:
}

func Stop() {
	fmt.Println("[WaitObject::Stop] Catch signal :", GetInstance().SigResult)
	GetInstance().counter.Reset(0)
}

func (w *waitObject) handleSignals() {
	signal.Notify(w.sigEventChannel, syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP)
	for sig := range w.sigEventChannel {
		switch sig {
		case syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP:
			w.SigResult = sig
			Stop()
			return
		}
	}
}

func WaitForSignal(i32Timeout int) int32 {
	w := GetInstance()
	w.sigEventChannel = make(chan os.Signal, 1)

	var retv int32

	signal.Notify(w.sigEventChannel,
		syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP, syscall.SIGQUIT, syscall.SIGSEGV)

	select {
	case <-time.After(time.Second * time.Duration(i32Timeout)):
		retv = 0
		goto _EXIT

	case <-w.sigEventChannel:
		for sig := range w.sigEventChannel {
			switch sig {
			case syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP, syscall.SIGQUIT, syscall.SIGSEGV:
				w.SigResult = sig
				retv = i32convert(sig)
				goto _EXIT
			}
		}
	}
	retv = -1
_EXIT:
	close(w.sigEventChannel)
	return retv
}

func i32convert(sig os.Signal) int32 {
	switch sig := sig.(type) {
	case syscall.Signal:
		i := int32(sig)
		if i < 0 || i >= 65 {
			return -1
		}
		return i
	default:
		return -1
	}
}
