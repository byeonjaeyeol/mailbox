package Task

import (
	"reflect"
)

// Task struct definition
type Task struct {
	IFace interface{}

	RunnerFunction string

	RunnerParam []interface{}

	ResultChannel chan interface{}

	IgnoreResult bool
}

func NewTask(iFace interface{}, fn string, p ...interface{}) *Task {
	t := Task{
		IFace:          iFace,
		RunnerFunction: fn,
		RunnerParam:    p,
		ResultChannel:  make(chan interface{}),
	}
	return &t
}

func (t *Task) SetIgnore(f bool) {
	t.IgnoreResult = f
}

// InvokeTask : Call task function
func (t *Task) InvokeTask(returnChannel *chan interface{}) {
	inputs := make([]reflect.Value, len(t.RunnerParam))
	for i := range t.RunnerParam {
		inputs[i] = reflect.ValueOf(t.RunnerParam[i])
	}

	res := reflect.ValueOf(t.IFace).MethodByName(t.RunnerFunction).Call(inputs)

	if true == t.IgnoreResult {
		return
	}

	if nil != returnChannel {
		*returnChannel <- res
	} else {
		t.ResultChannel <- res
	}
}

// Close : Close task
func (t *Task) Close() {
	defer close(t.ResultChannel)
	t.IFace = nil
	t.RunnerFunction = ""
	t.RunnerParam = nil
}
