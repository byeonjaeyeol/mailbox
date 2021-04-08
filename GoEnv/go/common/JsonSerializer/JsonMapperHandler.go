package JsonSerializer

import (
	"reflect"
	"strconv"
	"strings"
)

var StringType = reflect.TypeOf(string(""))
var Float64Type = reflect.TypeOf(float64(1))
var JsonMapType = reflect.TypeOf((map[string]interface{})(nil))
var SliceType = reflect.TypeOf([]interface{}(nil))
var SliceMapType = reflect.TypeOf([]map[string]interface{}(nil))

var Token = "."

func (j *JsonMap) build(_byte []byte) error {
	err := FromJson(_byte, &j.JsonMap)
	return err
}

func (j JsonMap) search_json_root(k string, act Action) interface{} {
	splitKey := strings.Split(k, ".")

	if "" == k || "root" == k {
		return j.JsonMap
	}

	v := j.JsonMap[splitKey[0]]

	if 1 < len(splitKey) {
		switch reflect.TypeOf(v) {
		case JsonMapType:
			v := j.search_json_map_r(v, splitKey, 1, act)
			return v

		case SliceType:
			v := j.search_json_slice_r(v, splitKey, 1, act)
			return v

		case SliceMapType:
			v := j.search_json_slice_map_r(v, splitKey, 1, act)
			return v
		}
	}

	if act.do == 1 {
		j.JsonMap[splitKey[0]] = act.param

	} else if act.do == 2 {
		delete(j.JsonMap, splitKey[0])

	} else if act.do == 3 {
		v := j.JsonMap[splitKey[0]]

		if SliceType == reflect.TypeOf(act.param) {
			if nil == v {
				j.JsonMap[splitKey[0]] = make([]interface{}, 0, 0)
			}
		} else {
			if nil == v {
				j.JsonMap[splitKey[0]] = act.param
			} else if SliceType == reflect.TypeOf(v) {
				j.JsonMap[splitKey[0]] = append(j.JsonMap[splitKey[0]].([]interface{}), act.param)
			}
		}
	}

	return v
}

func (j *JsonMap) search_json_slice_map_r(sub interface{}, splitKey []string, idx int, a Action) interface{} {
	data := sub.([]map[string]interface{})
	arrayIdx, _ := strconv.Atoi(splitKey[idx])

	if 0 != len(data) {
		v := data[arrayIdx]

		if idx+1 < len(splitKey) {
			switch reflect.TypeOf(v) {
			case JsonMapType:
				v := j.search_json_map_r(v, splitKey, idx+1, a)
				return v

			case SliceType:
				v := j.search_json_slice_r(v, splitKey, idx+1, a)
				return v
			}
		}
	}

	if a.do == 1 {
		data[arrayIdx] = a.param.(map[string]interface{})

	} else if a.do == 2 {
		data = j.removeSliceMapElement(data, arrayIdx)

	} else if a.do == 3 {
		data = append(data, a.param.(map[string]interface{}))
	}
	return data[arrayIdx]
}

func (j *JsonMap) search_json_slice_r(sub interface{}, splitKey []string, idx int, a Action) interface{} {
	data := sub.([]interface{})
	arrayIdx, _ := strconv.Atoi(splitKey[idx])

	if 0 != len(data) {
		v := data[arrayIdx]

		if idx+1 < len(splitKey) {
			switch reflect.TypeOf(v) {
			case JsonMapType:
				v := j.search_json_map_r(v, splitKey, idx+1, a)
				return v

			case SliceType:
				v := j.search_json_slice_r(v, splitKey, idx+1, a)
				return v
			}
		}
	}

	if a.do == 1 {
		data[arrayIdx] = a.param

	} else if a.do == 2 {
		data = j.removeSliceElement(data, arrayIdx)

	} else if a.do == 3 {
		if len(data) == 0 {
			data = append(data, a.param)
		} else {
			v := data[arrayIdx]
			if nil == v {
				if SliceType == reflect.TypeOf(v) {
					subData := v.([]interface{})
					subData = append(subData, a.param)
				} else {
					data[arrayIdx] = a.param
				}
			}
		}
	}
	// find
	return data[arrayIdx]
}

func (j *JsonMap) search_json_map_r(sub interface{}, splitKey []string, idx int, a Action) interface{} {
	data := sub.(map[string]interface{})
	v := data[splitKey[idx]]

	if idx+1 < len(splitKey) {
		switch reflect.TypeOf(v) {
		case JsonMapType:
			v := j.search_json_map_r(v, splitKey, idx+1, a)
			return v

		case SliceType:
			v := j.search_json_slice_r(v, splitKey, idx+1, a)
			return v
		}
	}

	if a.do == 1 {
		data[splitKey[idx]] = a.param
	} else if a.do == 2 {
		delete(data, splitKey[idx])
	} else if a.do == 3 {
		v := data[splitKey[idx]]
		if nil == v {
			if SliceType == reflect.TypeOf(v) {
				subData := v.([]interface{})
				subData = append(subData, a.param)
			} else {
				data[splitKey[idx]] = a.param
			}
		}
	}

	return v
}

func (j *JsonMap) removeSliceElement(s []interface{}, index int) []interface{} {
	copy(s[index:], s[index+1:])
	s[len(s)-1] = nil
	s = s[:len(s)-1]
	return s
}

func (j *JsonMap) removeSliceMapElement(s []map[string]interface{}, index int) []map[string]interface{} {
	copy(s[index:], s[index+1:])
	s[len(s)-1] = nil
	s = s[:len(s)-1]
	return s
}
