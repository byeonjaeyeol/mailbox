package ThreadPool

import (
	"../Task"
)

func AddTask(p *Pool, t *Task.Task) {
	p.TaskChannel <- t
}

func GetWorkerCount(p *Pool) int {
	return p.Workers.Len()
}
