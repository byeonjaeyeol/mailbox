package Convert

import (
	"database/sql"
	"fmt"
	"strings"

	"../../common/Logger"
	"../RDBMS"
)

func (ci *convInst) insertRecvResultStat(co *convObj, samFile string, errCode string) {
	//todo check sql.open
	db, err := sql.Open(RDBMS.GetSqlInfo(), RDBMS.GetOpenDatabaseInfo())

	if nil != err {
		Logger.WriteLog("error", 10, fmt.Errorf("Failed Insert result to Database::Convert::convertFile()::convertBulk()::insertRecvResultStat()::sql.Open() error : %v", err))
		return
	}
	defer db.Close()

	oPath := ci.getOriginalFileName(samFile)
	errorYN, errorString := errorResultProc(errCode)

	rr := RDBMS.NewRecvResult()
	rr.SetRecvResult(oPath, co.recordLength, co.documentLength, errorYN, errorString, ci.agencyID)

	err = rr.RegRecvResult(db)
	if nil != err {
		Logger.WriteLog("error", 10, fmt.Errorf("Failed Insert result to Database::Convert::convertFile()::convertBulk()::insertRecvResultStat()::RegRecvResult() error : %v", err))
		return
	}
}

func (ci *convInst) getOriginalFileName(path string) string {
	return strings.Replace(path, ci.baseDirectory+"/", "", 1)
}
