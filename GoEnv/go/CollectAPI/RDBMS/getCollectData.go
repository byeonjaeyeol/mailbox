package RDBMS

import (
	"database/sql"
	"fmt"
	"strconv"

	jsonlib "../../common/JsonSerializer"
	_ "github.com/go-sql-driver/mysql"
)

func GetCollectData(agencyID int) (*jsonlib.JsonMap, int, error) {
	var strQuery string
	var sdate string
	var edate string

	sdate = "null"
	edate = "null"

	db, err := sql.Open(GetSqlInfo(), GetOpenDatabaseInfo())

	// if there is an error opening the connection, handle it
	if err != nil {
		fmt.Print(err.Error())
	}
	defer db.Close()

	strQuery = fmt.Sprintf("CALL SP_IF_GET_MYDOCUMENT_API('%v','%v','%v')", agencyID, sdate, edate)

	results, err := db.Query(strQuery)
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}

	allData := make([]map[string]interface{}, 0, 0)
	types, err := results.ColumnTypes()
	cols := make([]interface{}, len(types))
	colPtrs := make([]interface{}, len(types))

	for i := 0; i < len(types); i++ {
		colPtrs[i] = &cols[i]
	}
	cnt := 0
	for results.Next() {
		colData := make(map[string]interface{})

		err = results.Scan(colPtrs...)
		if err != nil {
			fmt.Println(err)
		}

		for i, col := range cols {
			if nil == col {
				colData[types[i].Name()] = nil
				continue
			}

			colData[types[i].Name()] = string((col).([]uint8)[:])

		}
		allData = append(allData, colData)
		cnt++
	}

	j, err := jsonlib.NewJsonMapFromBytes([]byte("{}"))
	if nil != err {
		fmt.Println(err)
		return nil, cnt, err
	}
	j.Insert("collect_"+strconv.Itoa(agencyID), allData)

	return j, cnt, nil
}
