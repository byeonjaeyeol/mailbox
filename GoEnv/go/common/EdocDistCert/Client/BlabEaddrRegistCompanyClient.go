package Client

import (
	blabModel "../Model/Blab"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"mime/multipart"
	"net/http"
	"net/textproto"
)

// PostEaddrRegistCompany 법인 공인전자주소 등록
// 법인은 사업자등록증사본(biz-doc.jpg)와 공인전자주소 등록 신청서(reg-doc.jpg)가 첨부되어야 함
// * 법인일 경우 idn에 사업자등록번호가 입력되는데 하이픈(‘-’)을 사용하지 않는다.
// * 공인전자주소는 중계자플랫폼內에서 유일한값이며 영문대소문자구분을 하지 않는다.
// * 개인 이외의 이용자명은 사업자등록증에 표기된 법인명(단체명)으로 등록해야 한다.
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- idn string : 이용자 고유번호(개인: CI, 법인: 사업자번호)
//	- eaddr string : 이용자 공인전자주소
//	- name string : 이용자 명
//	- type int8 : 이용자 구분 값(0: 개인, 1: 법인, 2:국가기관, 3: 공공기관, 4: 지자체, 9:기타)
//	- regDate string : 이용자의 공인전자주소 서비스 가입일시
//	- bizDocFilePath string : 사업자등록증 사본 파일
//	- regDocFilePath string : 공인전자주소 등록 신청서 파일
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabCommonResponse
//  - error
func PostEaddrRegistCompany(baseUrl string, idn string, eaddr string, name string, registType int8, regDate string, bizDocFilePath string, regDocFilePath string) (*blabModel.BlabResponse, error) {
	reqData := blabModel.BlabEaddrRegistRequest{Idn: idn, Eaddr: eaddr, Name: name, Type: registType, RegDate: regDate}

	log.Printf("reqData=%+v\n", reqData)

	metadataBytes, _ := json.Marshal(reqData)
	// buff := bytes.NewBuffer(pbytes)

	multipartBody := &bytes.Buffer{}
	writer := multipart.NewWriter(multipartBody)

	metadataHeader := textproto.MIMEHeader{}
	metadataHeader.Set("Content-Type", "application/json")
	metadataHeader.Set("Content-Disposition", fmt.Sprintf("form-data; name=\"msg\""))
	part, err := writer.CreatePart(metadataHeader)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return nil, err
	}

	part.Write(metadataBytes)

	mediaFiles := make(map[string]string)
	mediaFiles["biz-doc.jpg"] = bizDocFilePath
	mediaFiles["reg-doc.jpg"] = regDocFilePath

	if registType != 0 {
		for docFileName, filePath := range mediaFiles {
			mediaData, err := ioutil.ReadFile(filePath)
			if err != nil {
				log.Printf("err=%+v\n", err)
				return nil, err
			}
			mediaHeader := textproto.MIMEHeader{}
			mediaHeader.Set("Content-Type", "image/jpeg")
			mediaHeader.Set("Content-Disposition", fmt.Sprintf("form-data; name=\"file\"; filename=\"%s\"", docFileName))
			mediaPart, _ := writer.CreatePart(mediaHeader)
			_, err = io.Copy(mediaPart, bytes.NewReader(mediaData))
			if err != nil {
				log.Printf("err=%+v\n", err)
				return nil, err
			}
		}
	}

	writer.Close()
	url := baseUrl + "/api/eaddr/company"
	contentType := "multipart/mixed; boundary=" + writer.Boundary()
	appRes, err := ClientCallWithReader(http.MethodPost, url, contentType, bytes.NewReader(multipartBody.Bytes()), &blabModel.BlabCommonResponse{})
	if err != nil {
		log.Printf("err=%+v\n", err)
		return nil, err
	}

	return appRes, err
}
