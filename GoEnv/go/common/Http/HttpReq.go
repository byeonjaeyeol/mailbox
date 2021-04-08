package HttpReq

import (
	"bytes"
	"crypto/tls"
	"io/ioutil"
	"net/http"
	"time"

	jsonlib "../JsonSerializer"
)

func NewHttpRequest(method string, url string, body []byte) (*http.Request, error) {
	req, err := http.NewRequest(method, url, bytes.NewReader(body))
	if nil != err {
		return nil, err
	}
	return req, nil
}

func NewHttpRequestString(method string, url string, body string) (*http.Request, error) {
	req, err := http.NewRequest(method, url, bytes.NewBufferString(body))
	if nil != err {
		return nil, err
	}
	return req, nil
}

func SetAuth4Request(req *http.Request, username string, password string) {
	req.SetBasicAuth(username, password)
}

func SetHeader(req *http.Request, key string, value string) {
	req.Header.Add(key, value)
}

func DialRequest(req *http.Request, i64Timeout int64) (*jsonlib.JsonMap, error) {
	req.Header.Add("Content-Type", "application/json")
	client := newHttpClient(req, i64Timeout)
	defer func() {
		req.Close = true
		client = nil
	}()

	resp, err := client.Do(req)
	if nil != err {
		return nil, err
	}
	defer func() {
		resp.Body.Close()
		resp = nil
	}()

	bytes, _ := ioutil.ReadAll(resp.Body)
	jsonMap, _ := jsonlib.NewJsonMapFromBytes(bytes)

	return jsonMap, nil
}

func DialSimpleRequest(req *http.Request, i64Timeout int64) error {
	req.Header.Add("Content-Type", "application/json")
	client := newHttpClient(req, i64Timeout)
	defer func() {
		req.Close = true
		client = nil
	}()

	resp, err := client.Do(req)

	if resp != nil {
		defer func() {
			resp.Body.Close()
			resp = nil
		}()
	}

	if err != nil {
		return err
	}

	_, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	return nil
}

func newHttpClient(req *http.Request, i64Timeout int64) *http.Client {
	tr := &http.Transport{
		DisableKeepAlives: true,
		TLSClientConfig:   &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{
		Transport: tr,
		Timeout:   time.Second * time.Duration(i64Timeout),
	}
	return client
}
