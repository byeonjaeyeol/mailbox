package Client

import (
	blabModel "../../../common/EdocDistCert/Model/Blab"
	edcModel "../Model"
	"bytes"
	"encoding/json"
	"errors"
	"github.com/google/go-querystring/query"
	"io"
	"io/ioutil"
	"log"
	"mime"
	"mime/multipart"
	"net/http"
	"os"
	"reflect"
	"strconv"
	"strings"
	"time"
)

func ClientCallWithReader(method string, url string, contentType string, reader *bytes.Reader, toObj interface{}) (*blabModel.BlabResponse, error) {
	var req *http.Request
	var err error

	if reader != nil {
		req, err = http.NewRequest(method, url, reader)
	} else {
		// reader가 nil인 경우와 상수로 nil을 전달하는 경우 결과가 달라서 분리함
		// reader가 nil이면 http.NewRequest 진행 중 segmetation violation 오류 발생
		req, err = http.NewRequest(method, url, nil)
	}

	if err != nil {
		log.Println("err=", err)
		return nil, err
	}

	log.Printf("Blab EdocDistCert URL=%+v\n", url)
	// TODO: 보안 장치 마련 필요
	// Header.Set을 하면 자동으로 key의 찻자와 단어별 첫자를 대문자도 바꾸어 문제가 발생한다.
	// 변환을 하지 못하게 하기 위해 별도 처리했음
	/*
		req.Header["platform-id"] = []string{ClientConfig.PlatformId}
		req.Header["client-id"] = []string{ClientConfig.ClientId}
		req.Header["client-secret"] = []string{ClientConfig.ClientSecret}
		req.Header["req-UUID"] = []string{uuid.New().String()}
		req.Header["req-date"] = []string{time.Now().Format(Const.DATE_FORMAT_YYYY_MM_DD_BL_HH_MI_SS)}
	*/
	/*
		if ClientConfig.AccessToken != "" {
			req.Header["Authorization"] = []string{"Bearer " + ClientConfig.AccessToken}
		}
	*/

	req.Header["Content-Type"] = []string{contentType}
	log.Printf("req.Header=%+v\n", req.Header)
	client := &http.Client{Timeout: 180 * time.Second}
	res, err := client.Do(req)
	if err != nil {
		log.Println("err=", err)
		return nil, err
	}

	defer res.Body.Close()
	log.Printf("resHeader=%+v\n", res.Header)
	if res.StatusCode != http.StatusOK {
		err = errors.New("Request failed with response code: " + strconv.Itoa(res.StatusCode))
		log.Println("err=", err)
		return nil, err
	}

	blabRes := &blabModel.BlabResponse{}
	mediaType, params, _ := mime.ParseMediaType(res.Header.Get("Content-Type"))
	if strings.Contains(mediaType, "multipart") {
		multipartReader := multipart.NewReader(res.Body, params["boundary"])

		for {
			part, err := multipartReader.NextPart()
			defer func() {
				if part != nil {
					part.Close()
				}
			}()

			if err != nil {
				if err == io.EOF {
					break
				}
				log.Println("err=", err)
				return nil, err
			}

			if part == nil {
				log.Println("err=", err)
				return nil, err
			}

			log.Printf("part=%+v", part)
			log.Printf("part.FileName=%+v", part.FileName())
			log.Printf("part.Header=%+v\n", part.Header)
			partHeader := part.Header
			log.Printf("Conetent=Type=%+v\n", partHeader.Get("Content-Type"))
			if strings.Contains(partHeader.Get("Content-Type"), "application/json") {
				log.Printf("toObjType=%+v\n", reflect.TypeOf(toObj))
				if toObj != nil {
					blabRes = &blabModel.BlabResponse{}
					blabRes.Data = toObj
					_, err = edcModel.ReadToObj(part, blabRes)
					if err != nil {
						log.Printf("err=%+v\n", err)
						return nil, err
					}
				} else {
					resBodyBytes, err := ioutil.ReadAll(part)
					if err != nil {
						log.Println("err=", err)
						return nil, err
					}

					blabRes.Data = make(map[string]interface{})
					json.Unmarshal(resBodyBytes, blabRes)
				}
			} else {
				fileName := part.FileName()
				f, _ := os.Create(fileName)
				defer f.Close()

				_, err := io.Copy(f, part)
				if err != nil {
					log.Println("err=", err)
					return nil, err
				}
			}
		}
	} else {
		if toObj != nil {
			blabRes.Data = toObj
			_, err := edcModel.ReadToObj(res.Body, blabRes)
			if err != nil {
				log.Println("err=", err)
				return nil, err
			}
		} else {
			resBodyBytes, err := ioutil.ReadAll(res.Body)
			if err != nil {
				log.Println("err=", err)
				return nil, err
			}

			blabRes.Data = make(map[string]interface{})
			json.Unmarshal(resBodyBytes, blabRes)
		}
	}

	log.Printf("blabRes=%+v\n", blabRes)
	return blabRes, err
}

func ClientCall(method string, url string, queryParam interface{}, bodyParam interface{}, toObj interface{}) (*blabModel.BlabResponse, error) {
	var dataBuffer []byte
	var reader *bytes.Reader
	var err error
	var newUrl string

	log.Printf("reqData:queryParam=%+v\n", queryParam)
	log.Printf("reqData:bodyParam=%+v\n", bodyParam)
	if queryParam != nil {
		v, err := query.Values(queryParam)
		if err != nil {
			log.Println("err=", err)
			return nil, err
		}

		log.Println("query=", v.Encode())
		newUrl = url + "?" + v.Encode()
	} else {
		newUrl = url
	}

	if bodyParam != nil {
		dataBuffer, err = json.Marshal(bodyParam)
		if err != nil {
			log.Println("err=", err)
			return nil, err
		}
		if dataBuffer != nil {
			reader = bytes.NewReader(dataBuffer)
		}
	}

	return ClientCallWithReader(method, newUrl, "application/json", reader, toObj)
}
