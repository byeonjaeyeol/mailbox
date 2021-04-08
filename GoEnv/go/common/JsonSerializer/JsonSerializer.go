package JsonSerializer

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"os"
)

// GetJsonBytes : Get bytes from json file
func GetJsonBytes(fileName string) ([]byte, error) {
	jsonFile, e := os.Open(fileName)
	if nil != e {
		return nil, e
	}
	defer jsonFile.Close()
	jsonBytes, e := ioutil.ReadAll(jsonFile)
	if nil != e {
		return nil, e
	}
	return jsonBytes, e
}

// ToJson : object(struct) to json bytes
func ToJson(_obj interface{}) ([]byte, error) {
	jsonBytes, err := json.Marshal(_obj)
	if err != nil {
		return nil, err
	}
	return jsonBytes, nil
}

func ToJsonString(_obj interface{}) string {
	jsonBytes, err := json.Marshal(_obj)
	if err != nil {
		return ""
	}
	return string(jsonBytes)
}

// FromJson : json bytes to object(struct)
func FromJson(_byte []byte, _obj interface{}) error {
	err := json.Unmarshal(_byte, &_obj)
	return err
}

// PrettyPrint_Byte : pretty-print byte to json string
func PrettyPrint_Byte(src []byte) (string, error) {
	var dst bytes.Buffer
	err := json.Indent(&dst, src, "", "  ")
	if nil != err {
		return "", err
	}
	return dst.String(), nil
}

// PrettyPrint_String : pretty-print string to json string
func PrettyPrint_String(src string) (string, error) {
	var dst bytes.Buffer
	err := json.Indent(&dst, []byte(src), "", "  ")
	if nil != err {
		return "", err
	}
	return dst.String(), nil
}
