package InterfaceWebController

import (
	"fmt"
	"net/http"
	"runtime"

	"github.com/julienschmidt/httprouter"

	json "../../../common/JsonSerializer"
	"../../../common/Util"
	"../../Config"
)

// @GET : "/status"
func GetStatus(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)

	status, err := Util.StringToI64(Config.GetValue("server.status"))
	if nil != err {
		status = 1
	}

	data, _ := json.NewJsonMapFromBytes([]byte(`{"blab_webconvert" : {}}`))
	data.Insert("blab_webconvert.mobile_ver", Config.GetValue("server.mobile_ver"))
	data.Insert("blab_webconvert.version", Config.GetValue("server.version"))
	data.Insert("blab_webconvert.status", status)
	data.Insert("blab_webconvert.memory", CreateMemoryInfo(&m))

	// write data
	fmt.Fprint(w, data.PPrint())
}

func CreateMemoryInfo(m *runtime.MemStats) map[string]string {

	j := make(map[string]string)

	j["alloc"] = fmt.Sprint(m.Alloc)
	j["totalAlloc"] = fmt.Sprint(m.TotalAlloc)
	j["system"] = fmt.Sprint(m.Sys)
	j["numGC"] = fmt.Sprint(m.NumGC)

	return j
}
