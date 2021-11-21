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
		log.Fatal(err)
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
		io.Copy(mediaPart, bytes.NewReader(mediaData))
	}

	writer.Close()

	url := baseUrl + "/api/eaddr/user/company"
	contentType := "multipart/mixed; boundary=" + writer.Boundary()
	appRes, err := ClientCallWithReader(http.MethodPost, url, contentType, bytes.NewReader(multipartBody.Bytes()), &blabModel.BlabCommonResponse{})
	return appRes, err
}
