package ThreadPool

import (
	"container/list"
	"reflect"
	"runtime"
	"sync/atomic"
	"time"

	"../Task"
)

// Pool : struct Thread Pool
type Pool struct {
	CtrlChannel chan int32

	TaskChannel chan *Task.Task

	Workers list.List

	MaxWorkerSize int32

	IdleWorkerSize int32

	ActiveWorker int32

	TaskChannelSize int32

	IsEventPool bool

	WaitEventChannel chan interface{}
}

// NewPool : Create new thread pool
func NewPool(idleWorkerSize int32, taskChannelSize int32, isEventPool bool) *Pool {
	maxWorker := int32(runtime.NumCPU() * 4)

	p := Pool{
		ActiveWorker:     0,
		MaxWorkerSize:    maxWorker,
		IdleWorkerSize:   idleWorkerSize,
		TaskChannelSize:  taskChannelSize,
		TaskChannel:      make(chan *Task.Task, taskChannelSize),
		IsEventPool:      isEventPool,
		WaitEventChannel: make(chan interface{}),
	}

	p.Workers = *list.New()
	p.Workers.Init()

	p.RunIdle()
	return &p
}

// Close : stop thread pool
func (p *Pool) Close() {
	defer close(p.TaskChannel)
	defer close(p.WaitEventChannel)

	for node := p.Workers.Front(); node != nil; node = p.Workers.Front() {
		w := node.Value.(*Worker)
		w.Close()
		p.Workers.Remove(node)
	}

	p.ActiveWorker = 0
	p.MaxWorkerSize = 0
	p.IdleWorkerSize = 0
	p.TaskChannelSize = 0
}

// RunIdle : run threads as idle count
func (p *Pool) RunIdle() {
	worker := atomic.LoadInt32(&p.ActiveWorker)
	if worker == p.IdleWorkerSize {
		return
	} else if worker > p.IdleWorkerSize {
		return
	} else if worker < p.IdleWorkerSize {
		for i := worker; i < p.IdleWorkerSize; i++ {
			p.IncreaseWorker()
		}
	}
}

func (p *Pool) RunBusy() {
	p.IncreaseWorker()
}

func (p *Pool) IncreaseWorker() {
	var w *Worker
	if p.IsEventPool {
		w = NewWorker(p.TaskChannel, &p.WaitEventChannel)
	} else {
		w = NewWorker(p.TaskChannel, nil)
	}
	p.Workers.PushBack(w)
	atomic.AddInt32(&p.ActiveWorker, 1)
}

// DecreaseWorker : Decrease -1 thread pool worker
func (p *Pool) DecreaseWorker() {
	w := p.FindInactiveWorker()
	if w != nil {
		w.Close()
	}
}

// FindInactiveWorker : Find currently inactive worker
func (p *Pool) FindInactiveWorker() *Worker {
	for node := p.Workers.Front(); node != nil; node = node.Next() {
		w := node.Value.(*Worker)
		isRunning := atomic.LoadInt32(&w.IsTasking)
		if isRunning == 0 {
			return w
		}
	}
	return nil
}

func (p *Pool) WaitEvent(timeout int32) (interface{}, int32) {
	if timeout == -1 {
		select {
		case res := <-p.WaitEventChannel:
			return res, 0
		}
	} else {
		timeoutChannel := time.After(time.Duration(timeout) * time.Millisecond)
		select {
		case res := <-p.WaitEventChannel:
			return res, 0
		case <-timeoutChannel:
			error := make([]interface{}, 1)
			error[0] = "WaitEvent timeout"
			return error, -1
		}
	}
}

func (p *Pool) AddTask(t *Task.Task) {
	p.TaskChannel <- t
}

func (p *Pool) ParseTaskResult(t *Task.Task) []interface{} {
	if true == p.IsEventPool {
		return nil
	}

	res := <-t.ResultChannel
	v := reflect.ValueOf(res)
	ret := make([]interface{}, v.Len())

	for i := 0; i < v.Len(); i++ {
		ret[i] = v.Index(i).Interface()
	}
	return ret
}
