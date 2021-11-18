package Convert

import (
	"fmt"
	"strings"

	jsonlib "../../common/JsonSerializer"
	"../../common/Util"
	"../Utils"
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  CheckBox
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func (no *noticeObj) appendCheckBoxString(checkSlice *[]string, key string, data string) {
	var res string
	key = strings.Replace(key, "__CHECKBOX__", "", 1)

	if 0 == strings.Compare(data, no.jCheck.Find(key+".trueval")) {
		res = fmt.Sprintf(checkedForm, no.jCheck.Find(key+".truekey"), no.jCheck.Find(key+".truedesc"))
		res += ","
		res += fmt.Sprintf(unCheckedForm, no.jCheck.Find(key+".falsekey"), no.jCheck.Find(key+".falssdesc"))
	} else {
		res = fmt.Sprintf(unCheckedForm, no.jCheck.Find(key+".truekey"), no.jCheck.Find(key+".truedesc"))
		res += ","
		res += fmt.Sprintf(checkedForm, no.jCheck.Find(key+".falsekey"), no.jCheck.Find(key+".falssdesc"))
	}

	*checkSlice = append(*checkSlice, res)
}

func reBuildJFormCheckBox(jForm *jsonlib.JsonMap, checkSlice []string) string {
	jFormString := jForm.Print()

	checkBox := `"controls" : { "input" : { `
	for i, v := range checkSlice {
		checkBox += v

		if i != len(checkSlice)-1 {
			checkBox += ","
		}
	}
	checkBox += "}}"

	jFormString = strings.Replace(jFormString, `"controls":""`, checkBox, 1)
	return jFormString
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Array
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func (ci *convInst) getArrayFromSliceBulkData(slcBD []bulkData) string {
	var result string

	arrMap := make(map[string][]string)
	for i, bd := range slcBD {
		if i >= ci.maxArrayLength {
			break
		}

		for aName, slc := range bd.arrayMap {
			arStr := "{"
			for i, v := range slc {
				arStr += v
				if i < len(slc)-1 {
					arStr += ","
				} else {
					arStr += "}"
				}
			}
			arrMap[aName] = append(arrMap[aName], arStr)
		}
	}

	idx := 0
	for aName, slc := range arrMap {
		arStr := fmt.Sprintf(`"%v":[`, aName)
		for i, v := range slc {
			arStr += v
			if i < len(slc)-1 {
				arStr += ","
			} else {
				arStr += "]"
			}
		}

		result += arStr
		if idx < len(arrMap)-1 {
			result += ","
		}

		idx++
	}

	return result
}

func (ci *convInst) getArrayFromSliceJsonBulkData(slcBD []jsonBulkData) string {
	var result string

	arrMap := make(map[string][]string)
	for i, jbd := range slcBD {
		if i >= ci.maxArrayLength {
			break
		}

		for aName, slc := range jbd.arrayMap {
			arStr := "{"
			for i, v := range slc {
				arStr += v
				if i < len(slc)-1 {
					arStr += ","
				} else {
					arStr += "}"
				}
			}
			arrMap[aName] = append(arrMap[aName], arStr)
		}
	}

	idx := 0
	for aName, slc := range arrMap {
		arStr := fmt.Sprintf(`"%v":[`, aName)
		for i, v := range slc {
			arStr += v
			if i < len(slc)-1 {
				arStr += ","
			} else {
				arStr += "]"
			}
		}

		result += arStr
		if idx < len(arrMap)-1 {
			result += ","
		}

		idx++
	}

	return result
}

func (ci *convInst) getArrayFromSliceDRJsonBulkData(slcBD []jsonBulkData) string {
	var result string

	// fmt.Println("[formatUtils] slcBD :[", slcBD, "]")

	arrMap := make(map[string][]string)
	for i, jbd := range slcBD {

		// fmt.Println("[formatUtils] slcBD for i [", i, "]")
		// fmt.Println("[formatUtils] slcBD for jdb.arrayMap [", jbd.arrayMap, "]")

		if i >= ci.maxArrayLength {
			break
		}

		for aName, slc := range jbd.arrayMap {

			// fmt.Println("[formatUtils] slcBD for aName 0 [", aName, "]")
			// fmt.Println("[formatUtils] slcBD for aName 0 slc [", slc, "]")
			// fmt.Println("[formatUtils] slcBD for aName 1 len(slc) [", len(slc), "]")

			if aName == "users" {

				arStr := "{"
				for i, v := range slc {
					grjArray := strings.Split(v, ".")

					// fmt.Println("**********************************", i, "**********************************", len(grjArray))

					// fmt.Println("----------------------------------", i, "----------------------------------", v, i%11)

					if len(grjArray) > 2 {
						arStr += grjArray[1] + "." + grjArray[2]
					} else {
						arStr += grjArray[1]
					}

					if i < len(slc)-1 {
						if i%11 == 10 {
							arStr += "},{"
						} else {
							arStr += ","
						}
					} else {
						arStr += "}"
					}

				}

				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 1 [", arrMap[aName], "]")
				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 1 arStr [", arStr, "]")

				arrMap[aName] = append(arrMap[aName], arStr)

				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 2 [", arrMap[aName], "]")
				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 2 arStr [", arStr, "]")

			} else {
				arStr := "{"
				for i, v := range slc {
					arStr += v
					if i < len(slc)-1 {
						arStr += ","
					} else {
						arStr += "}"
					}
				}
				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 3 [", arrMap[aName], "]")
				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 3 arStr [", arStr, "]")

				arrMap[aName] = append(arrMap[aName], arStr)

				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 4 [", arrMap[aName], "]")
				// fmt.Println("[formatUtils] slcBD for for arrMap[aName] 4 arStr [", arStr, "]")
			}

		}
	}

	idx := 0
	for aName, slc := range arrMap {

		// fmt.Println("[formatUtils] slcBD for aName 2[", aName, "] slc [", slc, "] len(slc) [", len(slc), "]")
		if aName == "dr_list" {
			arStr := fmt.Sprintf(`"%v":`, aName)
			for i, v := range slc {
				arStr += v
				if i < len(slc)-1 {
					arStr += ","
				} else {
					arStr += ""
				}
			}
			result += arStr
		} else {
			arStr := fmt.Sprintf(`"%v":[`, aName)
			for i, v := range slc {
				arStr += v
				if i < len(slc)-1 {
					arStr += ","
				} else {
					arStr += "]"
				}
			}
			result += arStr
		}

		if idx < len(arrMap)-1 {
			result += ","
		}

		idx++
	}

	return result
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Formatting
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func appendArrayString(arrayMap map[string][]string, key string, data string) {
	key = strings.Replace(key, "__ARRAY__", "", 1)
	s := strings.Split(key, ".")
	key = s[0]
	arrayMap[key] = append(arrayMap[key], fmt.Sprintf(`"%v":"%v"`, s[1], data))
}

func appendArrayGRJString(arrayMap map[string][]string, key string, data string) {
	key = strings.Replace(key, "__ARRAY__", "", 1)
	s := strings.Split(key, ".")
	slist := strings.Split(s[0], "|")
	key = slist[0]
	arrayMap[key] = append(arrayMap[key], fmt.Sprintf(`"%v"."%v":"%v"`, slist[1], s[1], data))
	// arrayMap[key] = append(arrayMap[key], fmt.Sprintf(`"%v":"%v"`, s[1], data))
}

func modFormatGwanriNo(key, data string) (string, string) {
	key = strings.Replace(key, "__FORMAT__", "", 1)
	idx := len(data)

	if strings.Contains(key, ES_DATA_IJGWANRINO) {
		if idx != len(strings.ReplaceAll(FORM_IJGWANRINO, "-", "")) {
			return key, data
		}
		data = Utils.SplitControlNum(data, FORM_IJGWANRINO)
	}

	if strings.Contains(key, ES_DATA_GYGWANRINO) {
		if idx != len(strings.ReplaceAll(FORM_GYGWANRINO, "-", "")) {
			return key, data
		}
		data = Utils.SplitControlNum(data, FORM_GYGWANRINO)
	}

	return key, data
}

func appendFlagContents(flagMap map[string][]string, key string, data string) {
	key = strings.Replace(key, "__FLAG__", "", 1)

	idx := strings.IndexAny(key, ":")
	code := key[0:idx]
	key = key[idx+1:]

	flagMap[code] = append(flagMap[code], fmt.Sprintf("%v:%v", key, data))
}

func updateFlagContents(jForm *jsonlib.JsonMap, flagMap map[string][]string) {
	dispClass := jForm.Find(ES_DISPATCHING_CLASS)

	for code, contents := range flagMap {
		if code == dispClass {
			for _, str := range contents {
				idx := strings.IndexAny(str, ":")
				key := str[0:idx]
				data := str[idx+1:]

				jForm.Update(key, data)
			}
			break
		}
	}
}

func modFormatStandardKey(deptCode, data string) string {
	return fmt.Sprintf("%s-%s", deptCode, data)
}

func (ci *convInst) encryptData(jsonMap *jsonlib.JsonMap) error {
	dataVal := jsonMap.Find(ES_BINDING_DATA)
	dataHash := Util.Sha256(dataVal)
	jsonMap.Update(ES_DATA_HASH, dataHash)

	// data encrypt
	if 0 == strings.Compare(ci.encoding, "encrypt") {
		encData, err := Util.Encrypt(encryptKey, dataVal)
		if nil != err {
			return fmt.Errorf("Util()::Encrypt():: error : %v", err)
		}
		jsonMap.Update(ES_BINDING_DATA, encData)
	}

	return nil
}

func modUnstructuredDataDMType(key string, data string) (string, string) {
	key = strings.Replace(key, "__DMTYPE__", "", 1)

	if 0 == strings.Compare("01", data) {
		data = DMTYPE_01
	} else if 0 == strings.Compare("02", data) {
		data = DMTYPE_02
	} else {
		data = ""
	}

	return key, data
}
