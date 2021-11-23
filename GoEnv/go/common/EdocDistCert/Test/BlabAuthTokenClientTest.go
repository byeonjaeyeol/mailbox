package main

import (
	blabModel "../../../common/EdocDistCert/Model/Blab"
	blabClient "../Client"
	testConfig "./TestConfig"
	"fmt"
	"log"
)

// 중계자 Access Token 발급 및 갱신 테스트
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testConfig.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testConfig.ClientConfig

	if clientConfig.Auth.GrantType != 0 && clientConfig.Auth.GrantType != 1 {
		fmt.Println("grantType이 없거나 잘못 되었습니다.")
		return
	}

	if clientConfig.Auth.ClientId == "" {
		fmt.Println("clientId가 없습니다.")
		return
	}

	var appRes *blabModel.BlabResponse
	if clientConfig.Auth.ClientSecret != "" {
		appRes, err = blabClient.PostAuthToken(clientConfig.Server.BaseUrl, clientConfig.Auth.GrantType, clientConfig.Auth.ClientId, clientConfig.Auth.ClientSecret, "")
	} else if clientConfig.Auth.RefreshToken != "" {
		appRes, err = blabClient.PostAuthToken(clientConfig.Server.BaseUrl, clientConfig.Auth.GrantType, clientConfig.Auth.ClientId, "", clientConfig.Auth.RefreshToken)
	} else {
		fmt.Println("clientSecret 또는 refreshToken이 없습니다.")
		return
	}

	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
