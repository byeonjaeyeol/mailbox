package Config

import (
	"sync"

	json "../../common/JsonSerializer"
)

type Config struct {
	jsonMap *json.JsonMap
}

var instance *Config
var once sync.Once

func GetInstance() *Config {
	once.Do(func() {
		instance = &Config{}
	})
	return instance
}

func Initialize(filename string) (err error) {
	c := GetInstance()
	c.jsonMap, err = json.NewJsonMapFromFile(filename)
	return err
}

func GetValue(k string) string {
	return GetInstance().jsonMap.Find(k)
}

func GetValue_Pretty(k string) string {
	return GetInstance().jsonMap.Find_Pretty(k)
}

func GetValue_withKey(k string) string {
	return GetInstance().jsonMap.Find_withKey(k)
}

func GetIFace(k string) interface{} {
	return GetInstance().jsonMap.Find_Iface(k)
}
