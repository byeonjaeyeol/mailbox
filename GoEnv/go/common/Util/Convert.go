package Util

import (
	"strconv"
	"time"
)

func I64UnixTimeTo(i64Time int64) (string, error) {
	str := strconv.FormatInt(i64Time, 10)
	i, err := strconv.ParseInt(str, 10, 64)
	if err != nil {
		return "", err
	}
	t := time.Unix(i, 0)
	return t.Format("2006-01-02 15:04:05"), nil
}

func StringUnixTimeToString(strTime string) (string, error) {
	i, err := strconv.ParseInt(strTime, 10, 64)
	if err != nil {
		return "", err
	}
	t := time.Unix(i, 0)
	return t.Format("2006-01-02 15:04:05"), nil
}

func StringToI64(str string) (int64, error) {
	i, err := strconv.ParseInt(str, 10, 64)
	if err != nil {
		return 0, err
	}
	return i, nil
}

func StringToINT(str string) (int, error) {
	i, err := strconv.Atoi(str)
	if err != nil {
		return 0, err
	}
	return i, nil
}

func StringToI32(str string) (int32, error) {
	i, err := StringToI64(str)
	if err != nil {
		return 0, err
	}
	return int32(i), nil
}

func I64ToString(i64 int64) string {
	return strconv.FormatInt(i64, 10)
}

func I32ToString(i32 int32) string {
	return strconv.FormatInt(int64(i32), 10)
}
