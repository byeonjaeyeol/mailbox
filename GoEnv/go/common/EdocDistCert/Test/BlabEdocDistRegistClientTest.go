package main

import (
	blabClient "../../../common/EdocDistCert/Client"
	edcConst "../../../common/EdocDistCert/Const"
	blabModel "../../../common/EdocDistCert/Model/Blab"
	testClient "./TestConfig"
	"fmt"
	"log"
	"strconv"
	"time"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig

	today := time.Now().Format(edcConst.DATE_FORMAT_YYYYMMDD)
	nowTime := time.Now().Format(edcConst.DATE_FORMAT_HHMISS)

	fmt.Println("today=", today, " nowTime=", nowTime)

	circSlice := []blabModel.BlabEdocDistRegistCircRequest{}

	for idx := 0; idx < 1; idx++ {
		tempEdocNum := fmt.Sprintf("%8s_%10s_%6s%07d",
			today, "devmns1234", nowTime, (idx + 1))
		orderStr := strconv.Itoa(idx + 1)
		circData := blabModel.BlabEdocDistRegistCircRequest{
			// edocNum 형식
			// edocNum은 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
			// 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로,
			// 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
			EdocNum:        tempEdocNum,
			Subject:        "subject_" + orderStr,
			SendEaddr:      clientConfig.Company.Eaddr,
			RecvEaddr:      clientConfig.Individual.Eaddr,
			SendPlatformId: clientConfig.Auth.PlatformId,
			RecvPlatformId: clientConfig.Auth.PlatformId,
			SendDate:       time.Now().Format(edcConst.DATE_FORMAT_YYYY_MM_DD_BL_HH_MI_SS),
			RecvDate:       time.Now().Format(edcConst.DATE_FORMAT_YYYY_MM_DD_BL_HH_MI_SS),
			// ReadDate:       time.Now().Format(edcConst.DATE_FORMAT_YYYY_MM_BL_HH_MI_SS),
			ContentHash: "ContentHash_" + orderStr,
			FileHashes:  []string{"fileHash1", "fileHash2"},
		}

		circSlice = append(circSlice, circData)
	}

	appRes, err := blabClient.PostEdocDistRegist(clientConfig.Server.BaseUrl, circSlice)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
