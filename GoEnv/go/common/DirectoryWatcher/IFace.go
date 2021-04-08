package DirectoryWatcher

type Watcher interface {
	Init(m interface{})

	Start()

	Stop()
}
