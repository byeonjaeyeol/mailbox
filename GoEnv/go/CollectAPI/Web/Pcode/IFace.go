package Pcode

import (
	"errors"
	"fmt"
	"strings"
	"time"

	//"reflect"
	//"runtime"

	json "../../../../common/JsonSerializer"
	"../../../../common/Logger"
	ierr "../../IF_Error"
	"../../RDBMS"
)

func Pcode_Member_Signup(ci string, reqBody *json.JsonMap, tm RDBMS.TxManager) (*json.JsonMap, *ierr.IF_Error) {
	var pcodeRes *json.JsonMap
	var memberRes *json.JsonMap
	var pcodeInfo *json.JsonMap
	var err error
	var perr *ierr.IF_Error
	var pcode string
	var mi string
	var national_info string

	findPcodeProc := fmt.Sprintf("CALL SP_IF_GET_PCODE('%v')", ci)
	pcodeRes, err = tm.TXMysqlSelect(findPcodeProc, "TBL_PCODE")
	if nil != err {
		return nil, &ierr.IF_Error{"10002", "ERROR : get pcode sp exec. error", err}
	}

	findMemberProc := fmt.Sprintf("CALL SP_IF_GET_MEMBER(null, null, '%v')", ci)
	memberRes, err = tm.TXMysqlSelect(findMemberProc, "TBL_EPOSTMEMBER")
	if nil != err {
		return nil, &ierr.IF_Error{"10002", "ERROR : get member sp exec. error", err}
	}

	if pcodeRes.Size("TBL_PCODE") > 1 || memberRes.Size("TBL_EPOSTMEMBER") > 1 {
		return nil, &ierr.IF_Error{"10005", "ERROR : Cannot match ci", err}
	}

	if 0 == pcodeRes.Size("TBL_PCODE") && 0 == memberRes.Size("TBL_EPOSTMEMBER") {
		if "null" == reqBody.Find("national_info") || "" == reqBody.Find("national_info") {
			national_info = "0"
		} else {
			national_info = reqBody.Find("national_info")
		}

		// mi, perr = miGeneration(reqBody.Find("birth"), reqBody.Find("gender"), national_info, reqBody.Find("name"))
		foreigner := "N"
		if national_info != "0" {
			foreigner = "Y"
		}
		mi, perr = miGeneration_v2(reqBody.Find("name"), reqBody.Find("birth"), reqBody.Find("gender"), foreigner, reqBody.Find("base_addr"))
		if nil != perr {
			return nil, perr
		}

		pcode, perr = genPcode_v2("P", "KR", ci, time.Now().Local().String())
		if nil != perr {
			return nil, perr
		}

		signupProc := fmt.Sprintf("CALL SP_IF_SET_SIGNUP('%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v')",
			pcode,
			ci,
			mi,
			reqBody.Find("type"),
			reqBody.Find("hp"),
			reqBody.Find("name"),
			reqBody.Find("password"),
			reqBody.Find("pubKey"),
			reqBody.Find("uuid"),
			reqBody.Find("birth"),
			reqBody.Find("email"),
			reqBody.Find("gender"),
			reqBody.Find("marketing_ok"))
		pcodeInfo, err = tm.TXMysqlSelect(signupProc, "PCODE_INFO")
		Logger.WriteLog("query", 10, signupProc)
		if nil != err {
			return nil, &ierr.IF_Error{"10002", "ERROR : signup sp exec. error", err}
		}

		return pcodeInfo, nil
	}

	if 0 != pcodeRes.Size("TBL_PCODE") && 0 == memberRes.Size("TBL_EPOSTMEMBER") {
		if "null" == reqBody.Find("national_info") || "" == reqBody.Find("national_info") {
			national_info = "0"
		} else {
			national_info = reqBody.Find("national_info")
		}

		// mi, perr = miGeneration(reqBody.Find("birth"), reqBody.Find("gender"), national_info, reqBody.Find("name"))
		foreigner := "N"
		if national_info != "0" {
			foreigner = "Y"
		}
		mi, perr = miGeneration_v2(reqBody.Find("name"), reqBody.Find("birth"), reqBody.Find("gender"), foreigner, reqBody.Find("base_addr"))
		if nil != perr {
			return nil, perr
		}

		pcode, perr = TXGetPcodeFromCI(ci, tm)
		if nil != perr {
			return nil, perr
		}

		signup2Proc := fmt.Sprintf("CALL SP_IF_SET_SIGNUP2('%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v')",
			pcode,
			reqBody.Find("type"),
			reqBody.Find("hp"),
			reqBody.Find("name"),
			ci,
			mi,
			reqBody.Find("password"),
			reqBody.Find("pubKey"),
			reqBody.Find("uuid"),
			reqBody.Find("birth"),
			reqBody.Find("email"),
			reqBody.Find("gender"),
			reqBody.Find("marketing_ok"))
		pcodeInfo, err = tm.TXMysqlSelect(signup2Proc, "PCODE_INFO")
		Logger.WriteLog("query", 10, signup2Proc)
		if nil != err {
			return nil, &ierr.IF_Error{"10002", "ERROR : signup2 sp exec. error", err}
		}

		return pcodeInfo, nil
	}

	if 0 != pcodeRes.Size("TBL_PCODE") && 0 != memberRes.Size("TBL_EPOSTMEMBER") {
		memberYn := strings.EqualFold(strings.ToLower(memberRes.Find("TBL_EPOSTMEMBER.0.use_yn")), "y")

		if memberYn {
			return nil, &ierr.IF_Error{"10007", "ERROR : already have member error", errors.New("already have member")}
		} else {
			pcode = pcodeRes.Find("TBL_PCODE.0.p_code")

			signup3Proc := fmt.Sprintf("CALL SP_IF_SET_SIGNUP3('%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v', '%v')",
				pcode,
				reqBody.Find("type"),
				reqBody.Find("hp"),
				reqBody.Find("name"),
				reqBody.Find("password"),
				reqBody.Find("email"),
				reqBody.Find("pubKey"),
				reqBody.Find("uuid"),
				reqBody.Find("marketing_ok"))
			pcodeInfo, err = tm.TXMysqlSelect(signup3Proc, "PCODE_INFO")
			Logger.WriteLog("query", 10, signup3Proc)
			if nil != err {
				return nil, &ierr.IF_Error{"10002", "ERROR : signup3 sp exec. error", err}
			}
			return pcodeInfo, nil
		}
	}
	return nil, &ierr.IF_Error{"10009", "ERROR : Pcode_Member_Signup method error", errors.New("method error")}
}

func FindPcodeTableByCi(ci string) (*json.JsonMap, *ierr.IF_Error) {
	findPcodeTableProc := fmt.Sprintf("CALL SP_IF_GET_PCODE('%v')", ci)
	queryRes, err := RDBMS.MysqlSelect(findPcodeTableProc, "TBL_PCODE")
	Logger.WriteLog("query", 10, findPcodeTableProc)
	if nil != err {
		return nil, &ierr.IF_Error{"10002", "ERROR : get pcode table sp exec. error", err}
	}
	return queryRes, nil
}

func GetPcodeFromCI(ci string) (string, *ierr.IF_Error) {
	var pcode string
	var perr *ierr.IF_Error

	findPcodeTableProc := fmt.Sprintf("CALL SP_IF_GET_PCODE('%v')", ci)
	queryRes, err := RDBMS.MysqlSelect(findPcodeTableProc, "TBL_PCODE")
	Logger.WriteLog("query", 10, findPcodeTableProc)
	if nil != err {
		return "", &ierr.IF_Error{"10002", "ERROR : get pcode table sp exec. error", err}
	}

	if 0 == queryRes.Size("TBL_PCODE") || "" == queryRes.Find("TBL_PCODE.0.p_code") || "null" == queryRes.Find("TBL_PCODE.0.p_code") {
		pcode, perr = genPcode_v2("P", "KR", ci, time.Now().Local().String())
		if nil != perr {
			return "", perr
		}

		setPcodeTableProc := fmt.Sprintf("CALL SP_IF_SET_PCODE('%v', '%v')", pcode, ci)
		err = RDBMS.MysqlNonSelect(setPcodeTableProc)
		if nil != err {
			return "", &ierr.IF_Error{"10002", "ERROR : set pcode table sp exec. error", err}
		}
	} else {
		pcode = queryRes.Find("TBL_PCODE.0.p_code")
	}

	return pcode, nil
}

func TXGetPcodeFromCI(ci string, tm RDBMS.TxManager) (string, *ierr.IF_Error) {
	var pcode string
	var perr *ierr.IF_Error

	findPcodeTableProc := fmt.Sprintf("CALL SP_IF_GET_PCODE('%v')", ci)
	queryRes, err := tm.TXMysqlSelect(findPcodeTableProc, "TBL_PCODE")
	if nil != err {
		return "", &ierr.IF_Error{"10002", "ERROR : get pcode table sp exec. error", err}
	}

	if 0 == queryRes.Size("TBL_PCODE") || "" == queryRes.Find("TBL_PCODE.0.p_code") || "null" == queryRes.Find("TBL_PCODE.0.p_code") {
		pcode, perr = genPcode_v2("P", "KR", ci, time.Now().Local().String())
		if nil != perr {
			return "", perr
		}

		setPcodeTableProc := fmt.Sprintf("CALL SP_IF_SET_PCODE('%v', '%v')", pcode, ci)
		err = tm.TXMysqlNonSelect(setPcodeTableProc)
		if nil != err {
			return "", &ierr.IF_Error{"10002", "ERROR : set pcode table sp exec. error", err}
		}
	} else {
		pcode = queryRes.Find("TBL_PCODE.0.p_code")
	}

	return pcode, nil
}
