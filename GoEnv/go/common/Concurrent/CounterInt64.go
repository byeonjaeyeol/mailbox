package Concurrent

import "sync/atomic"

type CounterInt64 struct {
	atomicValue int64
}

func (c *CounterInt64) Increase() {
	atomic.AddInt64(&c.atomicValue, 1)
}

func (c *CounterInt64) Decrease() {
	atomic.AddInt64(&c.atomicValue, -1)
}

func (c *CounterInt64) Get() int64 {
	return atomic.LoadInt64(&c.atomicValue)
}

func (c *CounterInt64) Reset(resetValue int64) {
	atomic.StoreInt64(&c.atomicValue, resetValue)
}
