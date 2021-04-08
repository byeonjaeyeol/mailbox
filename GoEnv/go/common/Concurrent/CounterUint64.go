package Concurrent

import "sync/atomic"

type CounterUint64 struct {
	atomicValue uint64
}

func (c *CounterUint64) Increase() {
	atomic.AddUint64(&c.atomicValue, 1)
}

func (c *CounterUint64) Get() uint64 {
	return atomic.LoadUint64(&c.atomicValue)
}

func (c *CounterUint64) Reset(resetValue uint64) {
	atomic.StoreUint64(&c.atomicValue, resetValue)
}
