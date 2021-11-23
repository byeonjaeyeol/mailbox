package main

import (
	blabClient "../../../common/EdocDistCert/Client"
	edcConst "../../../common/EdocDistCert/Const"
	blabModel "../../../common/EdocDistCert/Model/Blab"
	testClient "./TestConfig"
	"log"
	"time"
)

// 전자문서 유통정보 수정 테스트
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	circSlice := []blabModel.BlabEdocDistReadCircRequest{}

	// for idx := 0; idx < 1; idx++ {
	circData := blabModel.BlabEdocDistReadCircRequest{
		EdocNum:  testClient.ClientConfig.Individual.EdocNum,
		ReadDate: time.Now().Format(edcConst.DATE_FORMAT_YYYY_MM_DD_BL_HH_MI_SS),
	}

	circSlice = append(circSlice, circData)
	// }

	appRes, err := blabClient.PatchEdocDistRead(testClient.ClientConfig.Server.BaseUrl, circSlice)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
