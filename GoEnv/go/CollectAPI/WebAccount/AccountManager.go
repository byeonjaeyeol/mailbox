package WebAccount

import (
	"fmt"
	"strconv"
	"sync"
	"time"

	HttpReq "../../common/Http"
	"../../common/Logger"
	"../../common/Util"
	"../Config"
	ierr "../IF_Error"
	"../RDBMS"
)

func (m *AccountManager) timeoutThread() {
_START_SECTION:
	select {
	case <-time.After(time.Second * time.Duration(m.sessionIntv)):
		m.findTimeout()
		goto _START_SECTION

	case <-m.stopChannel:
		goto _EXIT
	}

_EXIT:
	m.stopChannel <- 1
}

func (m *AccountManager) findTimeout() {
	sTime := time.Now().Unix()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// defer UnLock
	////////////////////////////////////////////////////////////////////////////////////
	for k, v := range m.accounts {
		dTime := v.timeStamp
		// remove session
		if m.sessionDuration < sTime-dTime {
			Logger.WriteLog("dev", 250, "[Account Timeout] pcode :", k)
			delete(m.accounts, k)
		}
	}
}

//
// AccountManager : Account Management sturct
//
type AccountManager struct {
	mutex       *sync.Mutex
	stopChannel chan interface{}

	accounts        map[string]*AccountData
	sessionDuration int64
	sessionIntv     int64
	maxAccounts     int
}

type AccountData struct {
	timeStamp int64
	pCodeIdx  int64
	hashKey   string
}

// account manager instance
var accountInstance *AccountManager
var accountOnce sync.Once

func getInstance() *AccountManager {
	accountOnce.Do(func() {
		accountInstance = &AccountManager{}
	})
	return accountInstance
}

func Init() {
	m := getInstance()

	m.maxAccounts, _ = strconv.Atoi(Config.GetValue("web_account.max_account"))
	m.accounts = make(map[string]*AccountData, m.maxAccounts)
	m.stopChannel = make(chan interface{})
	m.sessionDuration, _ = Util.StringToI64(Config.GetValue("web_account.timeout_sec"))
	m.sessionIntv, _ = Util.StringToI64(Config.GetValue("web_account.frequency_sec"))

	m.mutex = &sync.Mutex{}

	go m.timeoutThread()
}

func Fin() {
	m := getInstance()

	m.stopChannel <- 1

	<-m.stopChannel

	close(m.stopChannel)
}

func addAccount(pcode string) (string, *ierr.IF_Error) {
	m := getInstance()

	data, err := getNewAccount(pcode)
	if nil != err {
		return "", err
	}

	m.accounts[pcode] = data

	return data.hashKey, nil
}

func GetHmacHashKey(pcode string) (string, error) {
	m := getInstance()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	var HashKey string
	var ierr *ierr.IF_Error

	if data, exists := m.accounts[pcode]; exists {
		updateAccountTimestamp(pcode)
		return data.hashKey, nil
	}

	if m.maxAccounts <= len(m.accounts) {
		data, err := getNewAccount(pcode)
		if nil != err {
			return "", err
		}
		HashKey = data.hashKey
	} else {
		HashKey, ierr = addAccount(pcode)
		if nil != ierr {
			return "", ierr.Err
		}
	}

	return HashKey, nil
}

// GetPcodeIdx : return AccountData pcodeIdx
func GetPcodeIdx(pcode string) (int64, error) {
	m := getInstance()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	if data, exists := m.accounts[pcode]; exists {
		updateAccountTimestamp(pcode)
		return data.pCodeIdx, nil
	} else {
		// GET DATA, NO SAVE
		data, err := getNewAccount(pcode)
		if nil != err {
			return 0, fmt.Errorf(err.Error())
		}
		return data.pCodeIdx, nil
	}
}

func updateAccountTimestamp(pcode string) {
	m := getInstance()

	m.accounts[pcode].timeStamp = time.Now().Local().Unix()
}

func getNewAccount(pcode string) (*AccountData, *ierr.IF_Error) {

	getAccountProc := fmt.Sprintf("CALL SP_IF_GET_MEMBER('%v', null, null)", pcode)
	Logger.WriteLog("query", 10, getAccountProc)
	queryRes, err := RDBMS.MysqlSelect(getAccountProc, "TBL_EPOSTMEMBER")
	if nil != err {
		errCode := "10002"
		errMsg := "[REQUEST AUTH ERROR] : get member account sp exec. error"
		Logger.WriteLog("error", 10, errCode, errMsg)

		return nil, &ierr.IF_Error{errCode, errMsg, nil}
	}

	// check queryRes null
	if queryRes.Size("TBL_EPOSTMEMBER") == 0 {
		errCode := "10005"
		errMsg := fmt.Sprintf("[REQUEST AUTH ERROR] : Cannot match pcode : %v", pcode)
		Logger.WriteLog("error", 10, errCode, errMsg)

		return nil, &ierr.IF_Error{errCode, errMsg, nil}
	}

	pcodeIdx, _ := Util.StringToI64(queryRes.Find("TBL_EPOSTMEMBER.0.p_code_idx"))
	password := queryRes.Find("TBL_EPOSTMEMBER.0.password")

	d := &AccountData{
		timeStamp: time.Now().Local().Unix(),
		pCodeIdx:  pcodeIdx,
		hashKey:   password,
	}

	Logger.WriteLog("dev", 250, "[Account create] pcode :", pcode, ", pcodeIdx :", pcodeIdx)
	return d, nil
}

func UpdateHmacHashKey(pcode, password string) error {
	m := getInstance()
	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	if _, exists := m.accounts[pcode]; !exists {
		return nil
	}

	m.accounts[pcode].hashKey = password

	err := syncWebAccount(pcode, password)
	if nil != err {
		return fmt.Errorf("[ERROR] cannot syncWebAccount ::: pcode : %v, %v", pcode, err)
	}

	return nil
}

func syncWebAccount(pcode, password string) error {
	url := fmt.Sprintf("%s://%s:%s/sync/account",
		Config.GetValue("sync.protocol"),
		Config.GetValue("sync.host"),
		Config.GetValue("sync.port"))

	str := fmt.Sprintf(`{ "pcode" : "%v", "password" : "%v" }`, pcode, password)
	k := "1234567890123456"

	hash, err := Util.Encrypt(k, str)
	body := fmt.Sprintf(`{ "data" : "%v"}`, hash)

	req, err := HttpReq.NewHttpRequestString("POST", url, body)
	if nil != err {
		return fmt.Errorf("Failed Create New Http Request - url : %v, body : %v, error : %v", url, body, err)
	}
	defer func() {
		req.Close = true
		req = nil
	}()

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

func SyncWebAccount(pcode, password string) {
	m := getInstance()
	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	if _, exists := m.accounts[pcode]; exists {
		m.accounts[pcode].hashKey = password
	} else {
		// do nothing
	}
}
