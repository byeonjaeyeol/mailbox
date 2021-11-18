package main

import (
	"flag"
	"fmt"
	"os"
	"runtime"
	"strconv"
	"syscall"
	"time"

	"../common/Task"
	"../common/WaitObject"

	Orchestrator "./Orchestrator"
)

var pidFile string
var version string

func main() {
	pidFile = "CollectAPI.pid"
	version = "B.2021.11.11.01"
	os.Remove(pidFile)

	pVersion := flag.Bool("version", false, "Print version")
	pStart := flag.Bool("start", false, "Start service")

	flag.Parse()

	if *pVersion {
		fmt.Println("CollectAPI version :", version)
		return

	} else if *pStart {
		if _, err := os.Stat(pidFile); os.IsNotExist(err) {
			// do nothing
			fmt.Println("[", pidFile, "] file. OK.")
		} else {
			fmt.Println("please check [", pidFile, "] file. exit.")
			return
		}

		f, e := os.OpenFile(pidFile, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if e != nil {
			fmt.Println(e)
			return
		}
		f.WriteString(strconv.FormatInt(int64(os.Getpid()), 10))
		f.Close()

		StartService()

	} else {
		usage()
		PrintMemUsage()
	}

	os.Remove(pidFile)
}

func StartService() {
_START_PROC:
	err := Orchestrator.Start()
	if nil != err {
		fmt.Println("[CollectAPI] _CRITICAL : Service initialize error -", err)
		return
	}

	t := Task.NewTask(MainTask{}, "Run")
	t.SetIgnore(true)

	WaitObject.Waiting(nil)
	Orchestrator.Stop()

	// reload : goto _START_PROC
	if syscall.SIGHUP == WaitObject.GetSignal() {
		time.Sleep(time.Second * 10)
		fmt.Println("[CollectAPI] _INFO : restart service...")
		fmt.Println()
		goto _START_PROC
	} else {
		os.Remove(pidFile)
	}
}

type MainTask struct{}

func (m MainTask) Run() {
	PrintMemUsage()
}

func PrintMemUsage() {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	fmt.Printf("Alloc = %v MiB", m.Alloc)
	fmt.Printf("\tTotalAlloc = %v MiB", m.TotalAlloc)
	fmt.Printf("\tSys = %v MiB", m.Sys)
	fmt.Printf("\tNumGC = %v\n", m.NumGC)

}

func usage() {
	fmt.Println("[CollectAPI Usage]")
	fmt.Println("release:", version)
	fmt.Println("\noption:")
	fmt.Println("\t\t-start")
	fmt.Println("\t\t-version")
	fmt.Println("\nrun:")
	fmt.Println("\t\tex) ./CollectAPI [option]")
}
