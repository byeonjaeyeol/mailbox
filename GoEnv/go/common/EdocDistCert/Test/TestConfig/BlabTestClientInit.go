package TestConfig

import (
	edocValidator "../../Validator"
	"fmt"
)

func BlabTestClientInit() error {
	edocValidator.InitEdocDistCertValidator()
	err := LoadTestClientConfig()
	if err != nil {
		fmt.Printf("err=%+v\n", err)
		return err
	}

	return nil
}
