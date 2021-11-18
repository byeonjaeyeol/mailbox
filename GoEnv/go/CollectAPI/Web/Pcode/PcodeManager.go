package Pcode

import (
	"errors"
	"fmt"
	"strings"

	"../../../../common/Util"
	ierr "../../IF_Error"
)

func generatePcode(memberType string) (string, *ierr.IF_Error) {
	uuid := Util.GenerateUuid()
	pcode := strings.ReplaceAll(uuid, "-", "")

	switch memberType {
	case "P":
		pcode = fmt.Sprint("P", pcode, "KR")
	case "C":
		pcode = fmt.Sprint("C", pcode, "KR")
	case "T":
		pcode = fmt.Sprint("T", pcode, "KR")
	default:
		return "", &ierr.IF_Error{"10006", "ERROR : Generate pcode error", errors.New("MemberType param error")}
	}

	return pcode, nil
}

func genPcode_v2(memberType string, contryCode string, seeds ...string) (string, *ierr.IF_Error) {
	if 0 != strings.Compare(memberType, "P") &&
		0 != strings.Compare(memberType, "C") &&
		0 != strings.Compare(memberType, "T") {
		return "", &ierr.IF_Error{"10006", "ERROR : Generate pcode error", errors.New("MemberType param error")}
	}

	var keys string
	for i := range seeds {
		keys += fmt.Sprintf("%v", seeds[i])
	}

	fnvHashString := Util.FNV1a64(keys)
	result := memberType + fnvHashString + contryCode

	return result, nil
}

func genPcode_v3(memberType string, contryCode string, ci string, birth string) (string, *ierr.IF_Error) {
	if 0 != strings.Compare(memberType, "P") &&
		0 != strings.Compare(memberType, "C") &&
		0 != strings.Compare(memberType, "T") {
		return "", &ierr.IF_Error{"10006", "ERROR : Generate pcode error", errors.New("MemberType param error")}
	}

	var keys string
	keys = ci[:76] + birth + ci[76:]

	HashString := Util.Sha256(keys)
	result := memberType + HashString + contryCode

	return result, nil
}


