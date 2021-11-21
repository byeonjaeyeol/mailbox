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
		log.Fatal(err)
	}

	part.Write(metadataBytes)

	mediaFiles := make(map[string]string)
	mediaFiles["biz-doc.jpg"] = bizDocFilePath
	mediaFiles["reg-doc.jpg"] = regDocFilePath

	if registType != 0 {
		for docFileName, filePath := range mediaFiles {
			mediaData, _ := ioutil.ReadFile(filePath)
			mediaHeader := textproto.MIMEHeader{}
			mediaHeader.Set("Content-Type", "image/jpeg")
			mediaHeader.Set("Content-Disposition", fmt.Sprintf("form-data; name=\"file\"; filename=\"%s\"", docFileName))
			mediaPart, _ := writer.CreatePart(mediaHeader)
			io.Copy(mediaPart, bytes.NewReader(mediaData))
		}
	}

	writer.Close()
	url := baseUrl + "/api/eaddr/company"
	contentType := "multipart/mixed; boundary=" + writer.Boundary()
	appRes, err := ClientCallWithReader(http.MethodPost, url, contentType, bytes.NewReader(multipartBody.Bytes()), &blabModel.BlabCommonResponse{})
	return appRes, err
}
