package HttpUtil

type ReqInfo struct {
	Protocol  string
	Method    string
	URL       string
	reqHeader map[string]string
	reqBody   []byte
	User      string
	Passwd    string
}

func NewReqInfo() *ReqInfo {
	r := &ReqInfo{
		Protocol:  "",
		Method:    "",
		URL:       "",
		reqHeader: make(map[string]string, 0),
		reqBody:   make([]byte, 0, 0),
		User:      "",
		Passwd:    "",
	}
	return r
}

func (r *ReqInfo) SetProtocol(p string) {
	r.Protocol = p
}

func (r *ReqInfo) SetMethod(m string) {
	r.Method = m
}

func (r *ReqInfo) GetMethod() string {
	return r.Method
}

func (r *ReqInfo) SetURL(url string) {
	r.URL = url
}

func (r *ReqInfo) GetURL() string {
	return r.URL
}

func (r *ReqInfo) AppendHeader(k string, v string) {
	r.reqHeader[k] = v
}

func (r *ReqInfo) SetBody(body []byte) {
	r.reqBody = body
}

func (r *ReqInfo) SetAuth(u string, p string) {
	r.User = u
	r.Passwd = p
}
