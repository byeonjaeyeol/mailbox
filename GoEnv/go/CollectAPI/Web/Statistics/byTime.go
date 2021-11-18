package Stats

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"../../Model"

	"../../../../common/HttpUtil"
	"../../../../common/Logger"

	"github.com/julienschmidt/httprouter"
)

func ByTime(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)
	res := Model.NewResult()

	defer func() {
		error_code := res.Result.Find("result.code")
		Logger.WriteAccessLog("access", 10, r, tmBegin, error_code, "")
		r.Body.Close()
	}()
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, X-Requested-With")
	w.Header().Set("Access-Control-Allow-Credentials", "true")

	for {
		reqBody, err := HttpUtil.RequestBodyParser(r)
		if nil != err {
			res.SetResult("10001", "ERROR : Request Body Error")
			break
		}

		if err := reqBodyChecker(reqBody, REQ_KEY_ORG_CODE, REQ_KEY_DEPT_CODE, REQ_KEY_GTE, REQ_KEY_LT); nil != err {
			Logger.WriteLog("error", 10, "ES Http Request error :", err)
			res.SetResult("400", err.Error())
			break
		}

		cli_res, err := Call(reqBody, QUERY_FILE_BY_TIME, reqBody.Find(REQ_KEY_ORG_CODE))
		defer func() {
			cli_res.Body.Close()
			cli_res = nil
		}()

		if nil != err {
			Logger.WriteLog("error", 10, "ES Http Request error :", err)
			res.SetResult("400", fmt.Sprintf("ERROR : %v", err))
			break
		}

		bytes, _ := ioutil.ReadAll(cli_res.Body)
		fmt.Fprintf(w, `%v`, string(bytes))

		return
	}

	fmt.Fprint(w, res.ToString())
}
