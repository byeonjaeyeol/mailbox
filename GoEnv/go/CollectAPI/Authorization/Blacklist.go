package Authorization

import (
	"fmt"
	"time"

	HttpReq "../../common/Http"
	"../Config"
)

func (bm *blackListManager) timeoutThread() {
_START_SECTION:
	select {
	case <-time.After(time.Second * time.Duration(bm.frequency_sec)):
		bm.findTimeOut()
		goto _START_SECTION
	case <-bm.stopChannel:
		goto _EXIT
	}

_EXIT:
	bm.stopChannel <- 1
}

func (bm *blackListManager) findTimeOut() {
	au := getInstance()
	sTime := time.Now().Unix()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	au.mutex.Lock()
	defer au.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////
	for k, v := range bm.blackList {
		if bm.blackList_TimeOut < sTime-v {
			delete(bm.blackList, k)
			delete(bm.failedList, k)
		}
	}

	for k, v := range bm.failedList {
		if bm.failedList_TimeOut < sTime-v.lastAccessTime {
			delete(bm.failedList, k)
		}
	}
}

func isExistBlackList(ip string) bool {
	_, bExist := getInstance().bm.blackList[ip]
	return bExist
}

func addFailedAuthLog(ip string) error {
	au := getInstance()
	isBlackList := false
	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	au.mutex.Lock()
	defer au.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////
	if isExistBlackList(ip) {
		return nil
	}

	fl := au.bm.failedList
	limit := au.bm.limitFailedCount
	fTime := time.Now().Local().Unix()

	flog := failedLog{
		failedCount:    1,
		lastAccessTime: fTime,
	}

	if val, bExist := fl[ip]; bExist {
		if limit <= val.failedCount {
			au.bm.blackList[ip] = fTime
			isBlackList = true
			delete(fl, ip)
		} else {
			flog.failedCount = val.failedCount + 1
			fl[ip] = flog
		}
	} else {
		fl[ip] = flog
	}

	if !isBlackList {
		return nil
	}

	return syncBlackList(ip, fTime)
}

func syncBlackList(ip string, regdt int64) error {
	url := fmt.Sprintf("%s://%s:%s/sync/blacklist",
		Config.GetValue("sync.protocol"),
		Config.GetValue("sync.host"),
		Config.GetValue("sync.port"))

	body := fmt.Sprintf(`{ "ip" : "%v", "regdt" : "%v" }`, ip, regdt)

	req, err := HttpReq.NewHttpRequestString("POST", url, body)
	if nil != err {
		return fmt.Errorf("Failed Create New Http Request - url : %v, body : %v, error : %v", url, body, err)
	}

	t := time.Now()
	now := t.Local().Format(time.RFC1123)

	HttpReq.SetHeader(req, "User-Agent", "Interface")
	HttpReq.SetHeader(req, "Date", now)
	err = HttpReq.DialSimpleRequest(req, 10)
	if nil != err {
		return fmt.Errorf("Failed DialRequest - url : %v, body : %v, error : %v", url, body, err)
	}

	return nil
}
