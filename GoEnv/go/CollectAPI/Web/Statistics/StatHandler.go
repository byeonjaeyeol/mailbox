package Stats

import (
	"errors"
	"fmt"
	"net/http"
	"strings"

	"../../../../common/HttpUtil"
	json "../../../../common/JsonSerializer"
	"../../../../common/Logger"
	"../../Config"
)

func reqBodyChecker(reqBody *json.JsonMap, keys ...string) error {
	for i := range keys {
		if 0 == strings.Compare(reqBody.Find(keys[i]), "null") {
			return errors.New(fmt.Sprintf("ERROR : %v is not null", keys[i]))
		}
	}
	return nil
}

func esQuerySender(jsonBytes []byte, org string) (*http.Response, error) {
	r := HttpUtil.NewReqInfo()

	r.SetMethod("POST")

	r.AppendHeader("Content-Type", "application/json")

	r.SetAuth(Config.GetValue(CONF_KEY_USER), Config.GetValue(CONF_KEY_PASSWORD))

	u := Config.GetValue(CONF_KEY_URL)
	u = strings.Replace(u, "\\u0026", "&", -1)
	u = strings.Replace(u, QUERY_KEY_ORG_CODE, org, -1)
	r.SetURL(u)

	r.SetBody(jsonBytes)

	Logger.WriteLog("dev", 10, "query es stats.", r.GetMethod(), r.GetURL())
	Logger.WriteLog("dev", 10, string(jsonBytes))

	return HttpUtil.SendRequest(r)
}

func jsonBodyMaker(file string, qsMap map[string]string) ([]byte, error) {
	j, err := json.NewJsonMapFromFile(file)
	if nil != err {
		return nil, err
	}
	text := j.PPrint()
	for k, v := range qsMap {
		text = strings.Replace(text, k, v, -1)
	}

	return []byte(text), nil
}

func buildQueryStringMap(reqBody *json.JsonMap) map[string]string {
	qsMap := make(map[string]string, 0)

	for k, v := range keyMap {
		if 0 != strings.Compare(reqBody.Find(k), "null") {
			qsMap[v] = reqBody.Find(k)
		} else if 0 == strings.Compare(k, REQ_KEY_PAGE_FROM) {
			qsMap[v] = "0"
		} else if 0 == strings.Compare(k, REQ_KEY_PAGE_SIZE) {
			qsMap[v] = "20"
		} else if 0 == strings.Compare(k, REQ_KEY_SORT_KEY) {
			qsMap[v] = "status.time.@registed"
		} else if 0 == strings.Compare(k, REQ_KEY_SORT_ORDER) {
			qsMap[v] = "desc"
		}
	}
	return qsMap
}

func Call(reqBody *json.JsonMap, file string, org string) (*http.Response, error) {
	qsMap := buildQueryStringMap(reqBody)

	bodyBytes, err := jsonBodyMaker(file, qsMap)
	if nil != err {
		return nil, err
	}

	return esQuerySender(bodyBytes, org)
}
