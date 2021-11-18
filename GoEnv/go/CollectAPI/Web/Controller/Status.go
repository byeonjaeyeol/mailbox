package InterfaceWebController

import (
	"fmt"
	"net/http"
	"syscall"
	"time"

	"github.com/julienschmidt/httprouter"

	"../../Config"
	ProcMemory "../../ProcMemory"

	"../../../common/Logger"
	"../../../common/WaitObject"
)

// @GET: /
// ServerHealth : print Server Health
func ServerHealth(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	defer r.Body.Close()
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)

	w.Header().Add("Content-Type", "text/plain")

	fmt.Fprint(w, "status             : Running\n")
	fmt.Fprint(w, fmt.Sprintf("version            : %v\n", Config.GetValue("server.version")))
	fmt.Fprint(w, fmt.Sprintf("service start time : %v\n", ProcMemory.GetModuleStartTime()))
	fmt.Fprint(w, fmt.Sprintf("service uptime     : %v\n", ProcMemory.GetModuleUptime()))

	Logger.WriteAccessLog("webaccess", 10, r, tmBegin, r.Method, r.RequestURI)
}

// @GET: /reload
// Reload
func Reload(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)

	w.Header().Add("Content-Type", "text/plain")
	WaitObject.SendSignal(syscall.SIGHUP)
	fmt.Fprint(w, "call reload\n")

	Logger.WriteAccessLog("webaccess", 10, r, tmBegin, r.Method, r.RequestURI)
}

// @GET: /shutdown
// Shutdown
func Shutdown(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)

	w.Header().Add("Content-Type", "text/plain")
	WaitObject.SendSignal(syscall.SIGINT)
	fmt.Fprint(w, "Start Shutdown\n")

	Logger.WriteAccessLog("webaccess", 10, r, tmBegin, r.Method, r.RequestURI)
}
