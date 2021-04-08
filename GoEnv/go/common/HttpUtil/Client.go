package HttpUtil

import (
	"bytes"
	"crypto/tls"
	"net/http"
	"time"
)

func SendReq(r *ReqInfo) (*http.Response, error) {
	req, err := http.NewRequest(r.Method, r.URL, bytes.NewReader(r.reqBody))
	if nil != err {
		return nil, err
	}

	for k, v := range r.reqHeader {
		req.Header.Add(k, v)
	}

	tr := &http.Transport{
		DisableKeepAlives: true,
	}

	cli := &http.Client{
		Transport: tr,
		Timeout:   time.Second * 60,
	}

	req.Close = true

	return cli.Do(req)
}

func SendRequest(r *ReqInfo) (*http.Response, error) {
	req, err := http.NewRequest(r.Method, r.URL, bytes.NewReader(r.reqBody))
	if nil != err {
		return nil, err
	}

	defer func() {
		req.Close = true
	}()

	req.SetBasicAuth(r.User, r.Passwd)

	for k, v := range r.reqHeader {
		req.Header.Add(k, v)
	}

	tr := &http.Transport{
		DisableKeepAlives: true,
		TLSClientConfig:   &tls.Config{InsecureSkipVerify: true},
	}

	cli := &http.Client{
		Transport: tr,
		Timeout:   time.Second * 60,
	}

	return cli.Do(req)
}
