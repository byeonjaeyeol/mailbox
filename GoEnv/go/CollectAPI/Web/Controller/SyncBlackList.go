package InterfaceWebController

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"../../../common/Logger"
	"../../Authorization"
	"github.com/julienschmidt/httprouter"
)

func SyncBlackList(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	defer func() {
		r.Body.Close()
	}()
	if nil == r.Body {
		Logger.WriteLog("author", 10, "Web::Controller::SyncBlackList - nil body")
		return
	}

	var reqBody map[string]interface{}
	err := json.NewDecoder(r.Body).Decode(&reqBody)
	if nil != err {
		Logger.WriteLog("author", 10, "Web::Controller::SyncBlackList - Json Decoder Error : ", err)
		return
	}

	ip := reqBody["ip"]
	regDt := reqBody["regdt"]
	if nil == ip || nil == regDt {
		Logger.WriteLog("author", 10, "Web::Controller::SyncBlackList - Invalid Json Data")
		return
	}

	regDt_n64, err := strconv.ParseInt(fmt.Sprintf("%v", regDt), 10, 64)
	if nil != err {
		Logger.WriteLog("author", 10, "Web::Controller::SyncBlackList - Parse regdt string to int64 : ", regDt_n64, ", Error : ", err)
		return
	}

	Authorization.SyncBlackList(fmt.Sprintf("%v", ip), regDt_n64)
}
