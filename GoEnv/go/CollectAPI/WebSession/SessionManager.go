package WebSession

import (
	"sync"
	"time"

	"../../common/Logger"
	"../../common/Util"
	"../Config"
)

func (m *SessionManager) timeoutThread() {
_START_SECTION:
	select {
	case <-time.After(time.Second * time.Duration(m.sessionIntv)):
		m.findTimeout()
		goto _START_SECTION

	case <-m.StopChannel:
		goto _EXIT
	}

_EXIT:
	m.StopChannel <- 1
}

func (m *SessionManager) findTimeout() {
	sTime := time.Now().Unix()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// defer UnLock
	////////////////////////////////////////////////////////////////////////////////////
	for k, v := range m.Sessions.SessionMap {
		dTime := v.TimeStamp
		// remove session
		if m.sessionDuration < sTime-dTime {
			Logger.WriteLog("dev", 250, "[Session Timeout] session :", k, "pcode :", v.PCode)
			delete(m.Sessions.SessionMap, k)
			delete(m.PCodes, v.PCode)
		}
	}
}

//
// SessionManager : Session Management sturct
//
type SessionManager struct {
	mutex           *sync.Mutex
	Sessions        *SessionMap
	StopChannel     chan interface{}
	sessionDuration int64
	sessionIntv     int64

	PCodes map[string]string
}

// session manager instance
var sessionInstance *SessionManager
var sessionOnce sync.Once

func GetInstance() *SessionManager {
	sessionOnce.Do(func() {
		sessionInstance = &SessionManager{}
	})
	return sessionInstance
}

func Init() {
	m := GetInstance()

	m.Sessions = NewSessionMap()
	m.PCodes = make(map[string]string)
	m.StopChannel = make(chan interface{})
	m.sessionDuration, _ = Util.StringToI64(Config.GetValue("web_session.timeout_sec"))
	m.sessionIntv, _ = Util.StringToI64(Config.GetValue("web_session.frequency_sec"))

	m.mutex = &sync.Mutex{}

	go m.timeoutThread()
}

func Fin() {
	m := GetInstance()

	m.StopChannel <- 1

	<-m.StopChannel

	close(m.StopChannel)
}

func AddSession(pcode string, pcodeIdx int64) string {
	m := GetInstance()

	if 0 != len(m.PCodes[pcode]) {
		UpdateSessionTimestamp(m.PCodes[pcode])
		Logger.WriteLog("dev", 250, "[Session create] duplicate Session :", m.PCodes[pcode], "pcode :", pcode)

		return m.PCodes[pcode]
	}

	k := Util.GenerateUuid()
	d := SessionData{
		PCode:     pcode,
		TimeStamp: time.Now().Local().Unix(),
		PCodeIdx:  pcodeIdx,
	}
	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// defer UnLock
	////////////////////////////////////////////////////////////////////////////////////

	m.Sessions.SessionMap[k] = d
	m.PCodes[pcode] = k

	Logger.WriteLog("dev", 250, "[Session create] Session :", k, "pcode :", d.PCode, "pcodeIdx :", d.PCodeIdx)
	return k
}

func FindSession(k string) string {
	m := GetInstance()

	if d, ok := m.Sessions.SessionMap[k]; ok {
		UpdateSessionTimestamp(k)
		return d.PCode
	}
	return ""
}

func FindSessionPcodeIdx(k string) int64 {
	m := GetInstance()

	if d, ok := m.Sessions.SessionMap[k]; ok {
		UpdateSessionTimestamp(k)
		return d.PCodeIdx
	}
	return 0
}

func RemoveSession(k string) {
	m := GetInstance()

	Logger.WriteLog("dev", 250, "[Session Remove] Session :", k, "pcode :", m.Sessions.SessionMap[k].PCode)

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// defer UnLock
	////////////////////////////////////////////////////////////////////////////////////

	delete(m.PCodes, m.Sessions.SessionMap[k].PCode)

	delete(m.Sessions.SessionMap, k)
}

func UpdateSessionTimestamp(k string) {
	m := GetInstance()

	////////////////////////////////////////////////////////////////////////////////////
	// Lock
	m.mutex.Lock()
	defer m.mutex.Unlock()
	// UnLock
	////////////////////////////////////////////////////////////////////////////////////

	d := m.Sessions.SessionMap[k]
	d.TimeStamp = time.Now().Local().Unix()
	m.Sessions.SessionMap[k] = d
}
