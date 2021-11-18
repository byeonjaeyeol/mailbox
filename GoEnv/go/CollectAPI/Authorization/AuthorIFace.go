package Authorization

import (
	"bytes"
	"fmt"
	"net/http"
	"strings"

	//	"time"

	"../../common/Util"
	"../WebAccount"
)

type fromHeader struct {
	remoteIP         string
	userAgent        string
	originRequestURI string

	pCode    string
	hmacHash string
	gmtDate  string
	method   string
	version  string
}

func SyncBlackList(ip string, regDt int64) {
	au := getInstance()
	if _, bExist := au.bm.blackList[ip]; bExist {
		return
	}
	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	au.mutex.Lock()
	au.bm.blackList[ip] = regDt
	au.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////
}

func CheckAPIAuthor(req *http.Request) bool {
	if !getInstance().enable {
		return true
	}

	fh := fromHeader{}
	fh.parseHeaderData(req)
	loggingAuthor(&fh, "CheckAPIAuthor Entry", nil, 300)
	defer loggingAuthor(&fh, "CheckAPIAuthor Exit", nil, 300)

	if isExistBlackList(fh.remoteIP) {
		loggingAuthor(&fh, "Blocked IP - BLACKLIST ", nil, 10)
		return false
	}

	reqURI := parseURI(req.RequestURI)

	// 웹포탈 허용
	if strings.Contains(reqURI, "/stats") {
		return true
	}

	for {
		if b, err := isTimeOutRequest(fh.gmtDate); b {
			loggingAuthor(&fh, "isTimeOutRequest", err, 10)
			break
		}

		ipChk, agentChk := fh.checkPolicy(reqURI)
		if !ipChk && !agentChk {
			loggingAuthor(&fh, "be Against IP And Agent Policy", nil, 10)
			break
		}

		if !ipChk {
			loggingAuthor(&fh, "be Against IP Policy", nil, 10)
			break
		}

		if !agentChk {
			loggingAuthor(&fh, "be Against Agent Policy", nil, 10)
			break
		}

		if b, err := fh.authenticationByHmac256(reqURI); !b {
			loggingAuthor(&fh, "Failed HMAC Authentication", err, 10)
			break
		}

		return true
	}

	loggingAuthor(&fh, "addFailedAuthLog Result", addFailedAuthLog(fh.remoteIP), 10)
	return false
}

func (fh *fromHeader) authenticationByHmac256(reqURI string) (bool, error) {
	if !getInstance().authorMap[reqURI].hmacEnable {
		return true, nil
	}

	hashKey, err := WebAccount.GetHmacHashKey(fh.pCode)
	if nil != err {
		return false, fmt.Errorf("GetHmacHashKey Error : %v", err)
	}

	message := fmt.Sprintf("%s\n%s\n%s\n%s", fh.method, fh.gmtDate, reqURI, fh.pCode)
	hash := computeHmac256(message, hashKey)
	if 0 == strings.Compare(hash, fh.hmacHash) {
		return true, nil
	} else {
		return false, fmt.Errorf("Invalid HMAC HASH")
	}
}

func (fh *fromHeader) checkPolicy(reqURI string) (ipCheck bool, agentCheck bool) {
	if 0 == strings.Compare(reqURI, "") {
		return false, false
	}

	policy := getInstance().authorMap[reqURI]

	agentCheck = true
	if 0 != strings.Compare(policy.agent, "") {
		if 0 != strings.Compare(policy.agent, fh.userAgent) {
			agentCheck = false
		}
	}

	if 0 < len(policy.ipList) {
		for _, v := range policy.ipList {
			if Util.IpBetween(v.from, v.to, fh.remoteIP) {
				ipCheck = true
			}
		}
	}

	if 0 == len(policy.ipList) {
		ipCheck = true
	}

	return ipCheck, agentCheck
}

func (fh *fromHeader) parseHeaderData(req *http.Request) {
	fh.method = req.Method
	fh.gmtDate = req.Header.Get("Date")
	fh.originRequestURI = req.RequestURI
	fullAgent := req.Header.Get("User-Agent")

	if "" == req.Header.Get("X-Forwarded-For") {
		ip_port := strings.Split(req.RemoteAddr, ":")
		fh.remoteIP = ip_port[0]
	} else {
		fh.remoteIP = req.Header.Get("X-Forwarded-For")
	}

	if strings.Contains(fullAgent, "POSTOK_") {
		fh.userAgent = strings.ToLower(strings.SplitN(fullAgent, "_", 2)[0])
		fh.version = strings.SplitN(fullAgent, "_", 2)[1]
	} else {
		fh.userAgent = strings.ToLower(fullAgent)
		fh.version = ""
	}

	pAuth := req.Header.Get("Authorization")
	if 0 != strings.Compare(pAuth, "") && strings.Contains(pAuth, ":") {
		pcode_author := strings.Split(pAuth, ":")
		if 2 == len(pcode_author) {
			fh.pCode = pcode_author[0]
			fh.hmacHash = pcode_author[1]
		}
	}
}

func CheckVersion(req *http.Request) int64 {
	fullAgent := req.Header.Get("User-Agent")

	if strings.Contains(fullAgent, "POSTOK") && strings.Contains(fullAgent, "_") {
		verRes := parseVersion(req)

		return verRes
	}

	return 200
}

func parseVersion(req *http.Request) int64 {
	fullAgent := req.Header.Get("User-Agent")

	agtSlice := strings.SplitN(fullAgent, "_", 2)
	verStr := agtSlice[1]
	verSlice := strings.SplitN(verStr, ".", 3)

	var s string
	var buf bytes.Buffer
	for i, v := range verSlice {
		if i == 0 {
			buf.WriteString(v)

		} else {
			var str string
			if len(v) == 1 {
				str = fmt.Sprintf("00%v", v)
			} else if len(v) == 2 {
				str = fmt.Sprintf("0%v", v)
			} else {
				str = fmt.Sprintf("%v", v)
			}
			buf.WriteString(str)
		}
	}

	s = buf.String()

	version, err := Util.StringToI64(s)
	if nil != err {
		fh := &fromHeader{}
		fh.parseHeaderData(req)
		loggingAuthor(fh, "Failed to Parse Mobile Version", err, 10)
		return 0

	} else if version > 1002009 && version < 1002015 { // v1.2.10 ~ v1.2.14
		fh := &fromHeader{}
		fh.parseHeaderData(req)
		loggingAuthor(fh, "wrong version : v1.2.10 ~ v1.2.14", err, 10)
		return 1

	} else if version <= 1002009 {
		fh := &fromHeader{}
		fh.parseHeaderData(req)
		loggingAuthor(fh, "wrong version : lower than v1.2.9", err, 10)
		return 2

	}

	return 200
}

func FindBlackList(ip string) map[string]int64 {
	au := getInstance()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	au.mutex.Lock()
	defer au.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	bl := au.bm.blackList

	if 0 != len(bl) {
		if "" == ip {
			return bl

		} else {
			if _, exists := bl[ip]; exists {
				res := map[string]int64{
					ip: bl[ip],
				}
				return res
			}
		}
	}

	return nil
}

func DeleteBlackList(ip string) error {
	au := getInstance()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	au.mutex.Lock()
	defer au.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	bl := au.bm.blackList

	if 0 != len(bl) {
		if "" == ip {
			return fmt.Errorf("Error : ip cannot be null.")

		} else {
			if _, exists := bl[ip]; exists {
				delete(bl, ip)
			} else {
				return fmt.Errorf("Error : cannot find ip.")
			}
		}
	} else {
		return fmt.Errorf("Error : blacklist is null.")
	}

	return nil
}
