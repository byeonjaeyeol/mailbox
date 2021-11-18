package InterfaceWebController

import (
	"fmt"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"

	"../../../common/HttpUtil"
	json "../../../common/JsonSerializer"
	"../../../common/Logger"
	"../../Model"
	"../../RDBMS"
)

// @POST : "collect"
func CollectWeb(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	defer r.Body.Close()
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)

	var agency_id string
	var startDate string
	var endDate string

	var findCollectProc string
	var queryRes *json.JsonMap
	var err error

	// result data
	res := Model.NewResult()
	errCode := res.Result.Find("result.code")
	errMsg := res.Result.Find("result.description")

	// request body parser
	reqBody, err := HttpUtil.RequestBodyParser(r)
	if nil != err {
		errCode, errMsg = "10001", "ERROR : Request body error"
		goto _ERROR
	}

	agency_id = reqBody.Find("agency_id")
	if "" == agency_id || "null" == agency_id {
		errCode, errMsg = "10004", "ERROR : agency_id param cannot be null"
		goto _ERROR
	}

	startDate = reqBody.Find("startdate")
	if "" == startDate || "null" == startDate {
		errCode, errMsg = "10004", "ERROR : startDate param cannot be null"
		goto _ERROR
	}

	endDate = reqBody.Find("enddate")
	if "" == endDate || "null" == endDate {
		errCode, errMsg = "10004", "ERROR : endDate param cannot be null"
		goto _ERROR
	}

	findCollectProc = fmt.Sprintf("CALL SP_IF_GET_MYDOCUMENT_API('%v','%v','%v')", agency_id, startDate, endDate)
	queryRes, err = RDBMS.MysqlSelect(findCollectProc, "TBL_MYDOCUMENT")
	// fmt.Println("queryRes", queryRes)
	Logger.WriteLog("query", 10, findCollectProc)
	if nil != err {
		errCode, errMsg = "10002", "ERROR : findCollectProc list sp exec."
		goto _ERROR
	}

	res.AddData("data.count", queryRes.Size("TBL_MYDOCUMENT"))
	res.AddData("data.users", queryRes.Find_Iface("TBL_MYDOCUMENT"))

	goto _RESULT

_ERROR:
	Logger.WriteLog("error", 10, r.Method, r.RequestURI, errMsg)
	Logger.WriteLog("error", 200, err)
	res.SetResult(errCode, errMsg)
	goto _RESULT

_RESULT:
	// Write access Log
	Logger.WriteAccessLog("access", 10, r, tmBegin, errCode, agency_id)
	fmt.Println("[BlabAgent][Router] _INFO : Web::CollecttWeb")
	// write result body
	fmt.Fprint(w, res.ToString())

}
