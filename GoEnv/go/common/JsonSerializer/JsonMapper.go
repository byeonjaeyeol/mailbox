package JsonSerializer

import (
	"fmt"
	"os"
	"reflect"
)

// JsonMap : Json Map Struct
type JsonMap struct {
	JsonMap map[string]interface{}
}

type Action struct {
	do    int
	param interface{}
}

func NewJsonMapFromFile(fileName string) (*JsonMap, error) {
	j := &JsonMap{
		JsonMap: make(map[string]interface{}),
	}
	jsonBytes, e := GetJsonBytes(fileName)
	if nil != e {
		return j, e
	}
	e = j.build(jsonBytes)
	return j, e
}

func NewJsonMapFromBytes(bytes []byte) (*JsonMap, error) {
	j := &JsonMap{
		JsonMap: make(map[string]interface{}),
	}
	e := j.build(bytes)
	return j, e
}

func (j *JsonMap) BuildMap(jsonString string) map[string]interface{} {
	var jsonMap map[string]interface{}
	err := FromJson([]byte(jsonString), &jsonMap)
	if nil != err {
		return nil
	}
	return jsonMap
}

func (j *JsonMap) BuildSlice(jsonString string) []interface{} {
	var jsonSlice []interface{}
	err := FromJson([]byte(jsonString), &jsonSlice)
	if nil != err {
		return nil
	}
	return jsonSlice
}

func (j *JsonMap) Print() string {
	b, _ := ToJson(j.JsonMap)
	return string(b)
}

func (j *JsonMap) PPrint() string {
	b, _ := ToJson(j.JsonMap)
	str, _ := PrettyPrint_Byte(b)
	//fmt.Println(str)
	return str
}

func (j *JsonMap) Save(fileName string, isPrettyPrint bool) error {
	fp, err := os.Create(fileName)
	if nil != err {
		return err
	}
	defer fp.Close()

	if true == isPrettyPrint {
		jsonString := j.PPrint()
		fp.WriteString(jsonString)
	} else {
		jsonString := j.Print()
		fp.WriteString(jsonString)
	}

	return err
}

func (j *JsonMap) Size(k string) int {
	act := Action{
		do:    0,
		param: nil,
	}
	v := j.search_json_root(k, act)

	switch reflect.TypeOf(v) {
	case JsonMapType:
		sub := v.(map[string]interface{})
		return len(sub)
	case SliceType:
		sub := v.([]interface{})
		return len(sub)
	case SliceMapType:
		sub := v.([]map[string]interface{})
		return len(sub)
	case nil:
		return 0
	default:
		return 1
	}
}

func (j *JsonMap) Find(k string) string {
	act := Action{
		do:    0,
		param: nil,
	}
	v := j.search_json_root(k, act)
	b, _ := ToJson(v)

	if StringType == reflect.TypeOf(v) {
		b = b[1 : len(b)-1]
	}

	return string(b)
}

func (j *JsonMap) Find_Pretty(k string) string {
	act := Action{
		do:    0,
		param: nil,
	}
	v := j.search_json_root(k, act)

	b, _ := ToJson(v)
	retString, _ := PrettyPrint_Byte(b)
	return retString
}

func (j *JsonMap) Find_Iface(k string) interface{} {
	act := Action{
		do:    0,
		param: nil,
	}
	v := j.search_json_root(k, act)

	return v
}

func (j *JsonMap) Find_withKey(k string) string {
	v := j.Find(k)
	return fmt.Sprintf(`{"%s" : %s}`, k, v)

}

func (j *JsonMap) Update(k string, v interface{}) {
	act := Action{
		do:    1,
		param: v,
	}
	j.search_json_root(k, act)
}

func (j *JsonMap) Remove(k string) {
	act := Action{
		do:    2,
		param: nil,
	}
	j.search_json_root(k, act)
}

func (j *JsonMap) Insert(k string, v interface{}) {
	act := Action{
		do:    3,
		param: v,
	}
	j.search_json_root(k, act)
}

func (j *JsonMap) AddSubjson(k string, v map[string]interface{}) {
	//j.Insert(k, JsonMapType)
	if nil == v {
		j.Insert(k, make(map[string]interface{}))
	} else {
		j.Insert(k, v)
	}
}

func (j *JsonMap) AddSubSlice(k string, v []interface{}) {
	if nil == v {
		j.Insert(k, make([]interface{}, 0, 0))
	} else {
		j.Insert(k, v)
	}
}
