package JsonSerializer_test

import (
	"fmt"
	"testing"

	json "./JsonSerializer"
)

func ASSERT(e error) {
	if nil != e {
		panic(e)
	}
}

func Test_Main(t *testing.T) {
	fmt.Println("[TEST::Test_Main] Initialize from file")
	jsonMap, e := json.NewJsonMapFromFile("_sample_data.json")
	ASSERT(e)
	fmt.Println()

	fmt.Println("[TEST::Test_Main] PPrint")
	jsonMap.PPrint()
	fmt.Println()

	// FIND VALUE
	fmt.Println("[TEST::Test_Main] FIND VALUE from key")
	fmt.Println("sender :", jsonMap.Find("sender"))
	fmt.Println("subkey.subvalue1 :", jsonMap.Find("subkey.subvalue1"))
	// if slice, please insert index
	fmt.Println("data.1.type :", jsonMap.Find("data.1.type"))
	fmt.Println("data.2.da :", jsonMap.Find("data.2.da"))
	fmt.Println("uncontained_value :", jsonMap.Find("uncontained_value"))
	fmt.Println()

	// VALUE SIZE
	fmt.Println("[TEST::Test_Main] Get VALUE SIZE from key")
	fmt.Println("sender :", jsonMap.Size("sender"))
	fmt.Println("subkey.subvalue1 :", jsonMap.Size("subkey.subvalue1"))
	// if slice, please insert index
	fmt.Println("data.1.type :", jsonMap.Size("data.1.type"))
	fmt.Println("data.2.da :", jsonMap.Size("data.2.da"))
	fmt.Println("uncontained_value :", jsonMap.Size("uncontained_value"))
	fmt.Println()

	// UPDATE VALUE
	fmt.Println("[TEST::Test_Main] UPDATE VALUE from key")
	fmt.Println("=== before")
	fmt.Println("sender :", jsonMap.Find("sender"))
	fmt.Println("sendtime :", jsonMap.Find("sendtime"))

	jsonMap.Update("sender", "new sender")
	jsonMap.Update("sendtime", 2019)

	fmt.Println("=== after")
	fmt.Println("sender :", jsonMap.Find("sender"))
	fmt.Println("sendtime :", jsonMap.Find("sendtime"))
	fmt.Println()

	// INSERT VALUE
	fmt.Println("[TEST::Test_Main] INSERT KEY with value")
	fmt.Println("=== before")
	fmt.Println("subkey :", jsonMap.Find("subkey"))

	jsonMap.Insert("subkey.insertedKey", "New Inserted Key")
	jsonMap.Insert("subkey.insertedValue", 4096)

	fmt.Println("=== after")
	fmt.Println("subkey :", jsonMap.Find("subkey"))
	fmt.Println()

	// Remove KEY/VALUE
	fmt.Println("[TEST::Test_Main] DELETE KEY")
	jsonMap.Remove("sender")
	jsonMap.Remove("subkey")
	jsonMap.Remove("data.0")
	jsonMap.PPrint()
}
