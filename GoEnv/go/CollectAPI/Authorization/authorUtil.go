package Authorization

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"strconv"
	"strings"
	"time"

	jsonlib "../../common/JsonSerializer"
	"../../common/Logger"
	"../../common/Util"
)

func loggingAuthor(fh *fromHeader, desc string, err error, level int32) {
	authorInfo := fmt.Sprintf("[Author Info] PCode : %v, UserAgent : %v, RemoteIP : %v, URI : %v, USER_VERSION : %v",
		fh.pCode, fh.userAgent, fh.remoteIP, fh.originRequestURI, fh.version)

	description := "  [DESC] : " + desc
	var errString string
	if nil != err {
		errString = "  [Error] : " + err.Error()
	}

	Logger.WriteLog("author", level, authorInfo, description, errString)
}

func computeHmac256(message string, key string) string {
	k := []byte(key)
	h := hmac.New(sha256.New, k)
	h.Write([]byte(message))
	return base64.StdEncoding.EncodeToString(h.Sum(nil))
}

func parseURI(reqURI string) string {
	var ret string
	for {
		_, bExist := getInstance().authorMap[reqURI]
		if bExist {
			ret = reqURI
			break
		}

		idx := strings.LastIndexAny(reqURI, "/")
		if 0 > idx {
			break
		}
		reqURI = reqURI[:idx]
	}

	return ret
}

func isTimeOutRequest(reqGmtDate string) (bool, error) {

	t, err := time.Parse(time.RFC1123, reqGmtDate)
	if nil != err {
		return true, fmt.Errorf("Time Parse Error - %v", err)
	}

	reqTime := t.Unix()
	nowTime := time.Now().Unix()

	if getInstance().timeout < nowTime-reqTime {
		return true, fmt.Errorf("TimeOut - req gmt time : %v", reqGmtDate)
	}

	return false, nil
}

func convertIPlist2Slice(text string) (ipRange []ipAddrRange, err error) {
	var slcIPAddr []string

	if strings.Contains(text, ",") {
		slcIPAddr = strings.Split(text, ",")
	} else if 0 < len(text) {
		slcIPAddr = append(slcIPAddr, text)
	}

	for _, s := range slcIPAddr {
		idx := strings.IndexAny(s, "~")
		if 0 > idx {
			return nil, fmt.Errorf("Input IPAddr Data is Not Range - Data : %v", text)
		}

		ip := ipAddrRange{}
		if !Util.IsIPv4Addr(s[:idx]) {
			return nil, fmt.Errorf("IPAddr Format Error - Data : %v", s[:idx])
		}
		ip.from = s[:idx]

		if !Util.IsIPv4Addr(s[idx+1:]) {
			return nil, fmt.Errorf("IPAddr Format Error - Data : %v", s[idx+1:])
		}
		ip.to = s[idx+1:]

		ipRange = append(ipRange, ip)
	}

	return ipRange, nil
}

func authorPolicyInit(jMap *jsonlib.JsonMap) error {
	au := getInstance()

	if 0 == strings.Compare("true", jMap.Find("config.enable")) {
		au.enable = true
	}

	n64, err := strconv.ParseInt(jMap.Find("config.request_timeout_min"), 10, 64)
	if nil != err {
		return fmt.Errorf("Convert to Integer Error - key : config.request_timeout_min, Value : %v, Error : %v", jMap.Find("config.request_timeout_min"), err)
	}
	au.timeout = n64 * 60

	for i := 0; i < jMap.Size("list"); i++ {
		key := fmt.Sprintf("list.%v.", i)
		uri := jMap.Find(key + "uri")
		agent := strings.ToLower(jMap.Find(key + "agent"))
		ip := jMap.Find(key + "ip")

		var hmacEnable bool
		if 0 == strings.Compare("true", jMap.Find(key+"hmac")) {
			hmacEnable = true
		}

		if 0 == strings.Compare(uri, "null") || 0 == strings.Compare(agent, "null") || 0 == strings.Compare(ip, "null") {
			return fmt.Errorf("Json Format Error -  array Key : %v", key)
		}

		slc, err := convertIPlist2Slice(ip)
		if nil != err {
			return fmt.Errorf("Convert IP Addr Failed - jsonKey : %v , error : %v", key, err)
		}

		_, bExist := au.authorMap[uri]
		if bExist {
			return fmt.Errorf("URI Already Exists - Key : %v, URI : %v", key, uri)
		} else {
			au.authorMap[uri] = author{
				uri:        uri,
				agent:      agent,
				ipList:     slc,
				hmacEnable: hmacEnable,
			}
		}
	}

	return nil
}

func blackListManagerInit(jMap *jsonlib.JsonMap) error {
	au := getInstance()

	n, err := strconv.Atoi(jMap.Find("config.frequency_sec"))
	if nil != err {
		return fmt.Errorf("frequency_sec Convert to Integer Error : %v, Value : %v", err, jMap.Find("config.frequency_sec"))
	}
	au.bm.frequency_sec = n

	n64, err := strconv.ParseInt(jMap.Find("config.blackList_timeout_hour"), 10, 64)
	if nil != err {
		return fmt.Errorf("blackList_timeout_hour Convert to Integer64 Error : %v, Value : %v", err, jMap.Find("config.blackList_timeout_hour"))
	}
	au.bm.blackList_TimeOut = n64 * 60 * 60

	n64, err = strconv.ParseInt(jMap.Find("config.failedList_timeout_min"), 10, 64)
	if nil != err {
		return fmt.Errorf("failedList_timeout_min Convert to Integer64 Error : %v, Value : %v", err, jMap.Find("config.failedList_timeout_min"))
	}
	au.bm.failedList_TimeOut = n64 * 60

	n, err = strconv.Atoi(jMap.Find("config.limit_failed_count"))
	if nil != err {
		return fmt.Errorf("limit_failed_count Convert to Integer Error : %v, Value : %v", err, jMap.Find("config.limit_failed_count"))
	}
	au.bm.limitFailedCount = n

	return nil

}
