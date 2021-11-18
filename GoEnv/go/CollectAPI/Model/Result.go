package Model

import (
	json "../../common/JsonSerializer"
)

type WebResult struct {
	Result *json.JsonMap
}

func NewResult() *WebResult {
	r := &WebResult{}

	base := `{"result" : {}, "data" : {}}`
	r.Result, _ = json.NewJsonMapFromBytes([]byte(base))

	r.Result.Insert("result.code", "200")

	r.Result.Insert("result.description", "success")

	return r
}

func (r *WebResult) SetResult(code string, msg string) {
	r.Result.Update("result.code", code)
	r.Result.Update("result.description", msg)
}

func (r *WebResult) AddData(k string, v interface{}) {
	if v == nil {
		v = "[]"
	}
	r.Result.Insert(k, v)
}

func (r *WebResult) AddResult(k string, v []map[string]interface{}) {
	r.Result.Insert(k, v)
}

func (r *WebResult) ToString() string {
	return r.Result.PPrint()
}
