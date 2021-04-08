package DirectoryWatcher

import (
	"os"
	"path/filepath"
	"strings"
	"time"

	"../Util"
)

func (w *WatcherBase) Backup(fileList []string) {
	for _, v := range fileList {
		backupFile := strings.Replace(v, w.BasePath, w.BackupPath, -1)
		Util.Mkdir(filepath.Dir(backupFile))
		os.Rename(v, backupFile)
		os.Chtimes(backupFile, time.Now(), time.Now())
	}
}

func (w *WatcherBase) RemoveBackup(fileList []string) {
	sTime := time.Now().Unix()

	duration := w.day2sec(w.RemoveDuration)

	for _, v := range fileList {
		stat, e := os.Stat(v)
		if nil != e {
			continue
		}
		dTime := stat.ModTime().Unix()

		if duration < sTime-dTime {
			os.Remove(v)
		}
	}
}

func (w *WatcherBase) day2sec(day int) int64 {
	return int64(day * 24 * 60 * 60)
}
