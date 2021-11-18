package WebSession

//
// SessionMap : Session map struct
//
type SessionMap struct {
	SessionMap map[string]SessionData
}

func NewSessionMap() *SessionMap {
	m := &SessionMap{
		SessionMap: make(map[string]SessionData, 0),
	}
	return m
}
