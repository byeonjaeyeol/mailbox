package RDBMS

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func GetAgencyID() []string {
	db, err := sql.Open(GetSqlInfo(), GetOpenDatabaseInfo())

	// if there is an error opening the connection, handle it
	if err != nil {
		fmt.Print(err.Error())
	}
	defer db.Close()

	results, err := db.Query("SELECT agency_id FROM TBL_MYDOCUMENT WHERE agency_id is not null GROUP BY agency_id")

	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}

	agency_id := make([]string, 0)
	for results.Next() {
		var code string
		if err := results.Scan(&code); err != nil {
			// Check for a scan error.
			// Query rows will be closed with defer.
			fmt.Print(err)
		}
		agency_id = append(agency_id, code)

	}
	return agency_id
}
