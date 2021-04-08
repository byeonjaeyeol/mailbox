package DirectoryWatcher

type WatcherBase struct {
	BasePath        string
	BackupPath      string
	RemoveDuration  int
	RunningInterval int64
	WhiteList       []string

	IsRunning          bool
	StopChannel        chan interface{}
	BackupTimeChannel  chan interface{}
	RunningTimeChannel chan interface{}
}

func (w *WatcherBase) Init(m interface{}) {
	newMap := m.(map[string]interface{})
	w.BasePath = newMap["base"].(string)
	w.BackupPath = newMap["backup"].(string)
	w.RemoveDuration = int(newMap["duration_day"].(float64))
	w.RunningInterval = int64(newMap["frequencey_sec"].(float64))
	for _, v := range newMap["whitelist"].([]interface{}) {
		w.WhiteList = append(w.WhiteList, v.(string))
	}

	w.IsRunning = false
}

func (w *WatcherBase) Start() {
	w.IsRunning = true
}

func (w *WatcherBase) Stop() {
	w.IsRunning = false

	defer close(w.StopChannel)
	defer close(w.RunningTimeChannel)
	defer close(w.BackupTimeChannel)
}
