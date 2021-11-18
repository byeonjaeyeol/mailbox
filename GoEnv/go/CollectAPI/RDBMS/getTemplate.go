package RDBMS

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func GetTemplateCode(agencyID int) []string {
	//todo check sql.open
	//db, err := sql.Open("mysql", "root:1010@tcp(127.0.0.1:3306)/EMAILBOX")
	db, err := sql.Open(GetSqlInfo(), GetOpenDatabaseInfo())

	// if there is an error opening the connection, handle it
	if err != nil {
		fmt.Print(err.Error())
	}
	defer db.Close()

	// 테스트를 위해 00004 적용
	// results, err := db.Query("SELECT template_code FROM TBL_TEMPLATE WHERE agency_id=?", agencyID)
	results, err := db.Query("SELECT template_code FROM TBL_TEMPLATE WHERE agency_id=? and idx='55'", agencyID)

	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}

	codes := make([]string, 0)
	for results.Next() {
		var code string
		if err := results.Scan(&code); err != nil {
			// Check for a scan error.
			// Query rows will be closed with defer.
			fmt.Print(err)
		}
		codes = append(codes, code)

	}
	//fmt.Print(codes)
	return codes
}
