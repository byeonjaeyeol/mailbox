package RDBMS

import (
	"database/sql"
	"fmt"
)

type RecvResult struct {
	File_name     string
	Records_num   int
	Documents_num int
	Error_YN      string
	Error_string  string
	Agency_id     int
}

const (
	DB_INSERT_RESULT_FORM string = `INSERT INTO TBL_STAT_RECVFILE_RESULT (idx, reg_dt, file_name, records_num, documents_num, 
		error_YN, error_string, agency_id) VALUES (null, now(), '%s', %v, %v, '%s', '%s', %v)`
)

func NewRecvResult() *RecvResult {
	rr := RecvResult{
		File_name:     "",
		Records_num:   0,
		Documents_num: 0,
		Error_YN:      "",
		Error_string:  "",
		Agency_id:     0,
	}
	return &rr
}

func (rr *RecvResult) SetRecvResult(fileName string, recordsNum int, documentsNum int, errorYN string, errorString string, agencyID int) {
	rr.File_name = fileName
	rr.Records_num = recordsNum
	rr.Documents_num = documentsNum
	rr.Error_YN = errorYN
	rr.Error_string = errorString
	rr.Agency_id = agencyID
}

func (rr *RecvResult) RegRecvResult(db *sql.DB) error {
	query := fmt.Sprintf(DB_INSERT_RESULT_FORM, rr.File_name, rr.Records_num, rr.Documents_num, rr.Error_YN, rr.Error_string, rr.Agency_id)
	_, err := db.Exec(query)
	if nil != err {
		return fmt.Errorf("RDBMS::RegRecvResult()::db query error : %v, query : %v", err, query)
	}
	return nil
}
