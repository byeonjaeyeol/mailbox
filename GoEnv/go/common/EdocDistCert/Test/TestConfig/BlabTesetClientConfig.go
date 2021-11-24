package TestConfig

import (
	blabClient "../../Client"
	ifError "../../IF_Error"
	edcValidator "../../Validator"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
)

type ClientConfigServerType struct {
	BaseHost string `yaml:"baseHost" validate:"required"`
	BasePort string `yaml:"basePort" validate:"required"`
	BaseUrl  string `yaml:"baseUrl" validate:"required"`
}

type ClientConfigUserType struct {
	Idn          string `yaml:"idn"`
	Name         string `yaml:"name"`
	Eaddr        string `yaml:"eaddr"`
	RegDate      string `yaml:"regDate"`
	UpdDate      string `yaml:"updDate"`
	EaddrDelDate string `yaml:"eaddrDelDate"`
	EdocNum      string `yaml:"edocNum"`
	Reason       string `yaml:"reason"`
}

type ClientAuthInfoType struct {
	GrantType    int8   `yaml:"grantType"`
	PlatformId   string `yaml:"platformId"`
	ClientId     string `yaml:"clientId"`
	ClientSecret string `yaml:"clientSecret"`
	RefreshToken string `yaml:"refreshToken"`
}

type ClientConfigType struct {
	FileSavePath string                 `yaml:"fileSavePath"`
	Auth         ClientAuthInfoType     `yaml:"auth"`
	Individual   ClientConfigUserType   `yaml:"individual"`
	Company      ClientConfigUserType   `yaml:"company"`
	Server       ClientConfigServerType `yaml:"server" validate:"required"`
}

var ClientConfig ClientConfigType

func LoadTestClientConfig() error {
	byteValue, err := ioutil.ReadFile("TestConfig/BlabClientConfig.yml")
	if err != nil {
		log.Printf("err=%+v\n", err)
		return err
	}
	err = yaml.Unmarshal(byteValue, &ClientConfig)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return err
	}

	validator := edcValidator.EdocDistCertValidator
	err = validator.ValidateStruct(ClientConfig)
	if err != nil {
		validator.LogError(err)
		return &ifError.BlabError{ErrCode: "Config-Error", ErrMsg: validator.GetErrorMsg(err)}
	}

	blabClient.SetFileSavePath(ClientConfig.FileSavePath)
	return nil
}
