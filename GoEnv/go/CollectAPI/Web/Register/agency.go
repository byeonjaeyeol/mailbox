package regs

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"

	"../../Config"
	"../../Model"

	"../../../../common/HttpUtil"
	"../../../../common/Logger"
)

//	GET "/regs/agency/:org"
func RegAgency(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	tmBegin := time.Now().Local().UnixNano() / int64(time.Millisecond)
	res := Model.NewResult()

	// Write access log
	defer func() {
		error_code := res.Result.Find("result.code")
		Logger.WriteAccessLog("access", 10, r, tmBegin, error_code, "")
		r.Body.Close()
	}()

	org := p.ByName("org")

	for {
		code, msg := CallTemplate(org)
		if 200 != code {
			res.SetResult(fmt.Sprint(code), msg)
			break
		}

		code, msg = CallOrg(org)
		if 200 != code {
			res.SetResult(fmt.Sprint(code), msg)
			break
		}

		break
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, X-Requested-With")
	w.Header().Set("Access-Control-Allow-Credentials", "true")

	fmt.Fprint(w, res.ToString())
}

func CallTemplate(org string) (int, string) {
	var body string = `{
	"index_patterns": "",
	"settings": {
		"number_of_shards": 5,
		"default_pipeline": "set_emb_default"
	},
	"mappings": {
		"_doc": {
			"properties": {
					"status.time.@registed": {"type": "date" },
					"status.time.@dispatched": {"type": "date"},
					"status.time.@read": {"type": "date"},
					"status.time.@analysised": {"type": "date"},
					"binding.reserved.essential.dispatching.@res-time": {"type": "date"},
					"binding.reserved.essential.dispatching.@app-time": {"type": "date"}
			}
		}
	}
}`

	var url string = fmt.Sprintf(`%v://%v:%v/_template/%v`,
		Config.GetValue("elasticsearch.protocol"),
		Config.GetValue("elasticsearch.ip"),
		Config.GetValue("elasticsearch.port"),
		org)

	res, err := call("POST", url, []byte(body))
	defer res.Body.Close()
	if nil != err {
		return 10001, "ERROR : Cannot connect es server"
	}
	if 200 != res.StatusCode {
		return res.StatusCode, res.Status
	}

	return 200, "success"
}

func CallOrg(org string) (int, string) {
	var url string = fmt.Sprintf(`%v://%v:%v/%v-000001`,
		Config.GetValue("elasticsearch.protocol"),
		Config.GetValue("elasticsearch.ip"),
		Config.GetValue("elasticsearch.port"),
		org)

	var body string = fmt.Sprintf(`{"aliases": {"%v": {}}}`, org)

	res, err := call("PUT", url, []byte(body))
	defer func() {
		res.Body.Close()
		res = nil
	}()

	if nil != err {
		return 10001, "ERROR : Cannot connect es server"
	}

	_, err = ioutil.ReadAll(res.Body)
	if err != nil {
		return 10001, "ERROR : Cannot connect es server"
	}

	if 200 != res.StatusCode {
		return res.StatusCode, res.Status
	}
	return 200, "success"
}

func call(m string, u string, b []byte) (*http.Response, error) {
	r := HttpUtil.NewReqInfo()

	r.SetMethod(m)

	r.AppendHeader("Content-type", "application/json")

	r.SetAuth(Config.GetValue("elasticsearch.user"), Config.GetValue("elasticsearch.password"))

	r.SetURL(u)

	r.SetBody(b)

	return HttpUtil.SendRequest(r)
}
