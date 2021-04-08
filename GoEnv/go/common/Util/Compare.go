package Util

func CompareUnixTime(stime int64, dtime int64) int64 {
	return dtime - stime
}
