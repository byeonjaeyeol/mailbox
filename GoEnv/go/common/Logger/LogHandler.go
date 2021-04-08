package Logger

import (
	"fmt"
	"os"
	"path/filepath"
	"sync"
	"time"
)

var lockMutex sync.Mutex

// WriteToMetaFile : write to meta file
func WriteToMetaFile(strText string, strLogFile string) {
	lockMutex.Lock()
	defer lockMutex.Unlock()
	f, e := os.OpenFile(strLogFile, os.O_CREATE|os.O_WRONLY, 0666)
	if e != nil {
		fmt.Println(e)
		return
	}
	defer f.Close()
	f.WriteString(strText)
}

// ReadFromMetaFile : read from meta file
func ReadFromMetaFile(strLogMetaFile string) (string, error) {
	lockMutex.Lock()
	defer lockMutex.Unlock()
	f, e := os.OpenFile(strLogMetaFile, os.O_CREATE|os.O_RDWR, 0644)
	if e != nil {
		fmt.Println(e)
		return "", e
	}
	defer f.Close()
	buffer := make([]byte, 10)
	_, e = f.Read(buffer)
	if e != nil {
		return "", e
	}
	return string(buffer), nil
}

// WriteFile : write log at file
func WriteFile(text string, logFile string) {
	lockMutex.Lock()
	defer lockMutex.Unlock()
	f, e := os.OpenFile(logFile, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if e != nil {
		fmt.Println(e)
		return
	}
	defer f.Close()
	f.WriteString(text)
}

// WriteConsole : write log at stanadard output buffer
func WriteConsole(text string) {
	fmt.Println(text)
}

// FindNameIdx : Find log information index
func FindNameIdx(strName string, o *LoggerObject) int {
	for idx, log := range o.Logs {
		if strName == log.Name {
			return idx
		}
	}
	return -1
}

// BuildString : Build Log string from args
func BuildString(args ...interface{}) string {
	var text string

	t := time.Now().Local()
	_, procName := filepath.Split(os.Args[0])
	text = "[" + fmt.Sprint(t.Format("2006-01-02 15:04:05 -0700")) + "]"
	text += "[" + fmt.Sprint(procName) + "]"
	text += "[" + fmt.Sprint(os.Getpid()) + "]"

	for i := range args {
		text += fmt.Sprintf("%v ", args[i])
	}
	text += fmt.Sprintf("\r\n")

	return text
}

// CompileLogstring : Compile Log string from args
func CompileLogstring(args ...interface{}) string {
	var strText string
	localTime := time.Now().Local()

	for i := range args {
		if i > 0 {
			strText += "\t"
		}
		strText += fmt.Sprintf("%v", args[i])
	}
	return localTime.Format("2006-01-02 15:04:05") + "\t" + strText[1:len(strText)-1] + "\r\n"
}

// PreCreatePath : create log path when is not exist
func PreCreatePath(o *LogObject) error {
	logDir := filepath.Dir(o.Path)
	if _, serr := os.Stat(logDir); serr != nil {
		merr := os.MkdirAll(logDir, os.ModePerm)
		if merr != nil {
			return merr
		}
	} else {
		return serr
	}
	return nil
}
