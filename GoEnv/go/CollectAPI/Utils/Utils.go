package Utils

import (
	"crypto/rand"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"time"

	"github.com/djimenez/iconv-go"
)

func GetRandomString(length int) string {
	b := make([]byte, length)
	if _, err := rand.Read(b); err != nil {
		panic(err)
	}
	s := fmt.Sprintf("%X", b)

	return s
}

func GetSliceFromFile(path, lineFeed string) ([]string, error) {
	bytes, err := ioutil.ReadFile(path)

	if nil != err {
		return nil, err
	}
	return strings.Split(string(bytes), lineFeed), nil
}

func EncodeString(input, from, to string) (string, error) {
	converter, err := iconv.NewConverter(from, to)
	if nil != err {
		return "", fmt.Errorf("iconv::NewConverter() error : %v", err)
	}
	output, err := converter.ConvertString(input)
	if nil != err {
		return "", fmt.Errorf("converter::ConvertString() error : %v, input : %v, output : %v", err, input, output)
	}

	return output, nil
}

func SplitDelimiter(input, delimiter string) []string {
	return strings.Split(input, delimiter)
}

func SplitControlNum(input, controlKey string) string {
	var key []string
	var val []string

	key = SplitDelimiter(controlKey, "-")
	for _, str := range key {
		idx := len(str)
		val = append(val, input[0:idx])
		input = input[idx:]
	}

	var output string
	for i, str := range val {
		if i < len(val)-1 {
			str += "-"
		}
		output += str
	}

	return output
}

func GetDate() string {
	return time.Now().Format("2006.01.02")
}

func CheckDone(dateSlice []string) bool {
	today := GetDate()
	for _, d := range dateSlice {
		if d == today {
			return true
		}
	}
	return false
}

func CollectCheckDone(dateSlice []string) bool {
	today := GetDate()
	for _, d := range dateSlice {
		cd := strings.Split(d, "(")
		if cd[0] == today {
			return true
		}
	}
	return false
}

func WriteDone(fName string) error {
	f, err := os.OpenFile(fName, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("OpenFile() : %v", err)
	}
	f.WriteString(GetDate() + "\r\n")
	f.Close()

	return nil
}

func WriteWebDone(fName string, count string) error {
	f, err := os.OpenFile(fName, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("OpenFile() : %v", err)
	}
	f.WriteString(GetDate() + "(" + count + ") \r\n")
	f.Close()

	return nil
}

func UnlockFile(pathSlice []string) error {
	for _, pathLock := range pathSlice {
		path := strings.Replace(pathLock, ".lock", "", 1)
		err := os.Rename(pathLock, path)
		if nil != err {
			return fmt.Errorf("os.Rename() : %v, oldname : %v, newname : %v", err, pathLock, path)
		}
	}

	return nil
}

func RmlockFile(pathSlice []string) error {
	for _, pathLock := range pathSlice {
		err := os.Remove(pathLock)
		if nil != err {
			return err
		}
	}

	return nil
}
