package Pcode

import (
	"fmt"
	"testing"
)

func TestGenPcode_v3(t *testing.T) {
	pcode, _ := genPcode_v3("P", "KR", "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08d0992081afa23651fabc5432", "19900815")
	fmt.Printf("pcode = %s \n", pcode)
}

func TestMiGeneration(t *testing.T) {
	name := "유창욱"
	birth := "19900815";
	gender := "1";
	foreigner := "N"
	address := "서울시 영등포구";

	mi, err := miGeneration_v2(name, birth, gender, foreigner, address)
	fmt.Printf("mi = %s \n", mi)
	fmt.Printf("err = %s \n", err)
}