package Model

import (
	edcValidator "../Validator"
	"encoding/json"
	"io"
	"log"
)

func ReadToObjWithValidator(iord io.Reader, obj interface{}) (interface{}, error) {
	if err := json.NewDecoder(iord).Decode(obj); err != nil {
		return nil, err
	}

	log.Printf("obj=%+v\n", obj)
	validator := edcValidator.EdocDistCertValidator
	err := validator.ValidateStruct(obj)
	if err != nil {
		validator.LogError(err)
		return nil, err
	}

	return obj, nil
}

func ReadToObj(iord io.Reader, obj interface{}) (interface{}, error) {
	if err := json.NewDecoder(iord).Decode(obj); err != nil {
		return nil, err
	}

	log.Printf("obj=%+v\n", obj)

	return obj, nil
}
