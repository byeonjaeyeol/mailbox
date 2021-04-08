package ThreadPool

import (
	"sync/atomic"

	"../Task"
	"../Util"
)

type Worker struct {
	UUID string

	TaskChannel chan *Task.Task

	TaskEventChannel *chan interface{}

	IsTasking int32

	StopChannel chan bool
}

func NewWorker(t chan *Task.Task, e *chan interface{}) *Worker {
	w := Worker{
		UUID:             Util.GenerateUuid(),
		TaskChannel:      t,
		TaskEventChannel: e,
		StopChannel:      make(chan bool),
		IsTasking:        0,
	}
	go w.WorkRoutine()
	return &w
}

func (w *Worker) Close() {
	w.StopChannel <- true
	<-w.StopChannel
	defer close(w.StopChannel)
	w.UUID = ""
	w.IsTasking = 0
}

func (w *Worker) WorkRoutine() {
_SELECT_SECTION:
	select {
	case <-w.StopChannel:
		w.StopChannel <- true
		goto _EXIT
	case task := <-w.TaskChannel:
		atomic.AddInt32(&w.IsTasking, 1)
		task.InvokeTask(w.TaskEventChannel)
		atomic.AddInt32(&w.IsTasking, -1)
		goto _SELECT_SECTION
	}
_EXIT:
}

func (w *Worker) IsRunning() int32 {
	return atomic.LoadInt32(&w.IsTasking)
}
