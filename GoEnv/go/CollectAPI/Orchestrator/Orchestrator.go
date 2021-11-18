package Orchestrator

import (
	"fmt"
	"time"

	"../../common/Logger"

	"../AutoRemove"
	"../Config"
	"../Convert"
	"../RDBMS"
	"../WebSession"

	ProcMemory "../ProcMemory"
	InterfaceWeb "../Web"
)

func Start() error {
	err := Config.Initialize("config.json")
	if nil != err {
		fmt.Println("[CollectAPI][Orchestrator] _ERROR : Load config failed")
		return err
	}
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Load config success")

	err = Logger.LoadConfig_json(Config.GetValue_withKey("logs"))
	if nil != err {
		fmt.Println("[CollectAPI][Orchestrator] _ERROR : Load logger failed")
		return err
	}
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Load logger success")

	err = Convert.Initialize()
	if nil != err {
		fmt.Println("[CollectAPI][Orchestrator] _ERROR : Initialize Convert failed")
		return err
	}
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize Convert success")

	err = AutoRemove.Initialize()
	if nil != err {
		fmt.Println("[CollectAPI][Orchestrator] _ERROR : Initialize AutoRemove failed")
		return err
	}
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize AutoRemove success")

	ProcMemory.Init()
	Logger.WriteLog("convert", 10, "[CollectAPI][Orchestrator]::Start - memory initialize")
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize ProcMemory success")

	WebSession.Init()
	Logger.WriteLog("convert", 10, "[CollectAPI][Orchestrator]::Start - web session initialize")
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize WebSession success")

	InterfaceWeb.Route()
	Logger.WriteLog("convert", 10, "[CollectAPI][Orchestrator]::Start - web service initialize")
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize InterfaceWeb Route success")

	RDBMS.Initialize()
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Initialize RDBMS success")

	Run()

	return nil
}

func Run() {
	fmt.Println("[CollectAPI][Orchestrator] _INFO : Run() start")
	go Convert.RunConvertFile()
	go AutoRemove.RunFileRemover()

	go func() {
		for {
			AutoRemove.RunFileRemover()
			time.Sleep(AutoRemove.GetFrequency() * time.Hour)
		}
	}()

}

func Stop() {
	Convert.Fin()

	ProcMemory.Fin()

	InterfaceWeb.Stop()

	WebSession.Fin()

	AutoRemove.Fin()
}
