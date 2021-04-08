package HttpUtil

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"net/http"

	cjson "../JsonSerializer"
)

// RequestBodyParser : parse request body
func RequestBodyParser(r *http.Request) (*cjson.JsonMap, error) {
	defer func() {
		r.Close = true
		r.Body.Close()
	}()

	if nil == r.Body {
		return nil, nil
	}

	var reqBody map[string]interface{}
	err := json.NewDecoder(r.Body).Decode(&reqBody)
	if nil != err {
		return nil, err
	}

	jsonBytes, err := cjson.ToJson(reqBody)
	if nil != err {
		return nil, err
	}

	jsonBody, err := cjson.NewJsonMapFromBytes(jsonBytes)
	if nil != err {
		return nil, err
	}

	return jsonBody, nil
}

func ResponseBodyParser(res *http.Response) (*cjson.JsonMap, error) {
	defer func() {
		res.Body.Close()
	}()

	if http.StatusOK == res.StatusCode {
		b, _ := ioutil.ReadAll(res.Body)
		jsonBody, err := cjson.NewJsonMapFromBytes(b)
		if nil != err {
			return nil, err
		} else {
			return jsonBody, err
		}
	} else {
		return nil, errors.New(res.Status)
	}
}

// ResponseParser : parse http response
func ResponseParser(res *http.Response) (string, string) {
	defer func() {
		res.Body.Close()
	}()

	if http.StatusOK == res.StatusCode {
		b, _ := ioutil.ReadAll(res.Body)
		return res.Status, string(b)
	}
	return res.Status, ""
}
