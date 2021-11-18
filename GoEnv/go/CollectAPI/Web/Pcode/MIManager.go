package Pcode

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"
	"regexp"
	"strings"

	"../../../../common/Util"
	ierr "../../IF_Error"
)

type personalInfo struct {
	birth        string
	gender       string
	nationalInfo string
	name         string
	foreigner	 string
	address		 string
}

func miGeneration(birth, gender, nationalInfo, name string) (string, *ierr.IF_Error) {
	pi := personalInfo{}
	pi.birth = replBirthForm(birth)
	pi.gender = gender
	pi.nationalInfo = nationalInfo
	pi.name = replName(name)

	err := checkSetInfo(pi)
	if nil != err {
		return "", &ierr.IF_Error{"10006", "ERROR : Generate mi error", err}
	}

	mi := getMi(pi)

	return mi, nil
}

func miGeneration_v2(name, birth, gender, foreigner, address string) (string, *ierr.IF_Error) {
	pi := personalInfo{}
	pi.birth = replBirthForm_v2(birth)
	pi.gender = strings.ToUpper(gender)
	pi.foreigner = foreigner
	pi.name = replName(name)
	pi.address = address[:6]

	err := checkSetInfo_v2(pi)
	if nil != err {
		return "", &ierr.IF_Error{"10006", "ERROR : Generate mi error", err}
	}

	mi := getMi_v2(pi)

	return mi, nil
}

func replBirthForm(brith string) string {
	b := strings.ReplaceAll(brith, "-", "")
	return b[2:]
}

func replBirthForm_v2(brith string) string {
	b := strings.ReplaceAll(brith, "-", "")
	return b
}

func replName(name string) string {
	re := regexp.MustCompile(`[^가-힣a-zA-Z]*`)
	rp := re.ReplaceAllString(name, "")
	return strings.ToLower(rp)
}

func checkSetInfo(pi personalInfo) error {
	switch {
	case 6 != len(pi.birth):
		return errors.New("Birth type mismatch")

	case "1" != pi.gender && "2" != pi.gender:
		return errors.New("Gender type mismatch")

	case "0" != pi.nationalInfo && "1" != pi.nationalInfo:
		return errors.New("Nationalinfo type mismatch")

	case "" == pi.name:
		return errors.New("Name type mismatch")
	}
	return nil
}

func checkSetInfo_v2(pi personalInfo) error {
	switch {
	case 8 != len(pi.birth):
		fmt.Printf("birth = %s \n", pi.birth)		
		return errors.New("Birth type mismatch")

	case "1" != pi.gender && "2" != pi.gender:
		return errors.New("Gender type mismatch")

	case "Y" != pi.foreigner && "N" != pi.foreigner:
		return errors.New("Nationalinfo type mismatch")

	case "" == pi.name:
		return errors.New("Name type mismatch")

	case "" == pi.address:
		return errors.New("Address type mismatch")
	}
	return nil
}

func getMi(pi personalInfo) string {
	data := fmt.Sprintf("%s|%s|%s|%s", pi.birth, pi.gender, pi.nationalInfo, pi.name)
	return computeHmac256(data, getCriptoKey(pi))
}

func getMi_v2(pi personalInfo) string {
	keys := fmt.Sprintf("%s%s%s%s%s", pi.name, pi.birth, pi.gender, pi.foreigner, pi.address)
	fmt.Printf("key = %s \n", keys)
	HashString := Util.Sha256(keys)
	result := "M" + HashString + "KR"

	return result
}

func getCriptoKey(pi personalInfo) string {
	return fmt.Sprintf("%s_%s", pi.birth, pi.name)
}

func computeHmac256(message string, key string) string {
	k := []byte(key)
	h := hmac.New(sha256.New, k)
	h.Write([]byte(message))
	return base64.StdEncoding.EncodeToString(h.Sum(nil))
}
