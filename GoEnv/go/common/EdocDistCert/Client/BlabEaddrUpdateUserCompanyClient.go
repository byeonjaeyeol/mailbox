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

// PostEaddrUpdateUserCompany 법인 공인전자주소 소유자정보 수정
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- eaddr string : 이용자 공인전자주소
//	- name string : 이용자 명
//	- updDate string : 중계자시스템에서 이용자 정보가 변경된 일시
//	- bizDocFilePath string : 사업자등록증 사본 파일
//	- regDocFilePath string : 공인전자주소 등록 신청서 파일
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabCommonResponse
//  - error
func PostEaddrUpdateUserCompany(baseUrl string, compEaddr string, compName string, updDate string, bizDocFilePath string, regDocFilePath string) (*blabModel.BlabResponse, error) {
	data := blabModel.BlabEaddrUpdateUserCompanyRequest{Eaddr: compEaddr, Name: compName, UpdDate: updDate}

	metadataBytes, _ := json.Marshal(data)
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

	for docFilename, docFilePath := range mediaFiles {
		mediaData, _ := ioutil.ReadFile(docFilePath)
		mediaHeader := textproto.MIMEHeader{}
		mediaHeader.Set("Content-Type", "image/jpeg")
		mediaHeader.Set("Content-Disposition", fmt.Sprintf("form-data; name=\"file\"; filename=\"%s\"", docFilename))
		mediaPart, _ := writer.CreatePart(mediaHeader)
		_, err = io.Copy(mediaPart, bytes.NewReader(mediaData))
		if err != nil {
			log.Printf("err=%+v\n", err)
			return nil, err
		}
	}

	writer.Close()

	url := baseUrl + "/api/eaddr/user/company"
	contentType := "multipart/mixed; boundary=" + writer.Boundary()
	appRes, err := ClientCallWithReader(http.MethodPost, url, contentType, bytes.NewReader(multipartBody.Bytes()), &blabModel.BlabCommonResponse{})
	if err != nil {
		log.Printf("err=%+v\n", err)
		return nil, err
	}
	return appRes, err
}
