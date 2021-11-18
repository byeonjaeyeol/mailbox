package InterfaceWebController

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"../../../common/HttpUtil"
	"../../../common/Logger"
	"../../Config"
	"../../Model"
	"github.com/julienschmidt/httprouter"

	"../../Convert"
)

// @POST : "myagency/save"
func ConvertWeb(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	defer r.Body.Close()
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)

	var AuthorizationCode string
	var orgCode string
	var deptCode string

	// result data
	res := Model.NewResult()
	errCode := res.Result.Find("result.code")
	errMsg := res.Result.Find("result.description")

	for {
		// request body parser
		reqBody, err := HttpUtil.RequestBodyParser(r)
		if nil != err {
			Logger.WriteLog("error", 10, r.Method, r.RequestURI, "Request body error")
			Logger.WriteLog("error", 200, err)
			res.SetResult("10001", "ERROR : Request body error")
			break
		}

		// 인증 코드 확인 orgcode / deptcode
		AuthorizationCode = strings.Split(r.Header.Get("Authorization"), ":")[0]
		orgCode = strings.Split(AuthorizationCode, "-")[0]
		deptCode = strings.Split(AuthorizationCode, "-")[1]
		fmt.Println("[BlabAgent][WebConvert] _INFO : Web::ConvertWeb - AuthorizationCode : ", AuthorizationCode)
		configOrgCode := fmt.Sprintf("%v", Config.GetValue("convert.agency.orgcode"))
		configDeptCode := fmt.Sprintf("%v", Config.GetValue("convert.agency.deptcode"))
		fmt.Println("[BlabAgent][WebConvert] _INFO : Web::ConvertWeb - ConfigAuthorizationCode : ", configOrgCode, "-", configDeptCode)

		if 0 != strings.Compare(orgCode, configOrgCode) {
			errCode, errMsg = "90002", "orgCode Error"
			fmt.Println("[BlabAgent][WebConvert] _Error : Web::ConvertWeb - orgCode : ", errMsg)
			Logger.WriteLog("error", 10, r.Method, r.RequestURI, err)
			res.SetResult(errCode, errMsg)
			break
		}

		if 0 != strings.Compare(deptCode, configDeptCode) {
			errCode, errMsg = "90002", "deptCode Error"
			fmt.Println("[BlabAgent][WebConvert] _Error : Web::ConvertWeb - deptCode : ", errMsg)
			Logger.WriteLog("error", 10, r.Method, r.RequestURI, err)
			res.SetResult(errCode, errMsg)
			break
		}

		// 메세지 카운트와 배열 갯수 비교
		count := reqBody.Find("count")
		msg := reqBody.Size("msg")
		fmt.Println("[BlabAgent][WebConvert] _INFO : Web::ConvertWeb - count : ", count, "msg : ", msg)

		if 0 != strings.Compare(count, strconv.Itoa(msg)) {
			errCode, errMsg = "10004", "count msg length Error"
			fmt.Println("[BlabAgent][WebConvert] _Error : Web::ConvertWeb - msg : ", errMsg)
			Logger.WriteLog("error", 10, r.Method, r.RequestURI, err)
			res.SetResult(errCode, errMsg)
			break
		}

		// array type check
		// for i := 0; i < msg; i++ {
		// 	fmt.Println("[BlabAgent][WebConvert] _INFO : Web::ConvertWeb - msg for i : ", i)
		// }

		// json 파일을 생성
		// Convert.RunConvertWeb(reqBody, msg)

		convertWeb := Convert.RunConvertWeb(reqBody, msg)
		if 0 != strings.Compare(convertWeb, "") {
			errCode, errMsg = "10004", "Convert Error"
			fmt.Println("convertWeb", convertWeb)
			fmt.Println("[BlabAgent][WebConvert] _Error : Web::ConvertWeb - convert error : ", errMsg)
			res.SetResult(errCode, errMsg)
			break
		}

		// Write Log
		defer func() {
			error_code := res.Result.Find("result.code")
			Logger.WriteAccessLog("webaccess", 10, r, tmBegin, error_code, orgCode)
		}()

		break
	}

	fmt.Println("[BlabAgent][Router] _INFO : Web::ConvertWeb - for end ")
	// write result body
	fmt.Fprint(w, res.ToString())
}
