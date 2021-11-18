package RDBMS

import (
	"database/sql"
	"fmt"
	"log"
	"strconv"
	"strings"

	cjson "../../common/JsonSerializer"
	"../Config"

	_ "github.com/go-sql-driver/mysql"
)

type mysql struct {
	connString string
}

func conn() (*sql.DB, error) {
	return sql.Open("mysql", Config.GetValue("database.connector"))
}

func BuildProcedure(name, args string) string {
	return fmt.Sprintf("CALL %v(%v)", name, args)
}

func MysqlNonSelect(q string) error {
	db, err := conn()
	if nil != err {
		db.Close()
		return err
	}

	// query
	row, err := db.Query(q)
	// close db
	defer func() {
		if nil != row {
			row.Close()
		}
		if nil != db {
			db.Close()
		}
	}()

	if nil != err {
		return err
	}

	return err
}

func MysqlSelect(q string, rootKey string) (*cjson.JsonMap, error) {
	db, err := conn()
	if nil != err {
		db.Close()
		return nil, err
	}
	// query
	rows, err := db.Query(q)
	// close db
	defer func() {
		if nil != rows {
			rows.Close()
		}
		if nil != db {
			db.Close()
		}
	}()

	if nil != err {
		return nil, err
	}

	allData := make([]map[string]interface{}, 0, 0)
	types, err := rows.ColumnTypes()
	cols := make([]interface{}, len(types))
	colPtrs := make([]interface{}, len(types))

	for i := 0; i < len(types); i++ {
		colPtrs[i] = &cols[i]
	}
	cnt := 0
	for rows.Next() {
		colData := make(map[string]interface{})

		err = rows.Scan(colPtrs...)
		if err != nil {
			log.Fatal(err)
		}

		for i, col := range cols {
			if nil == col {
				colData[types[i].Name()] = nil
				continue
			}

			if 0 == strings.Compare(types[i].DatabaseTypeName(), "BIGINT") ||
				0 == strings.Compare(types[i].DatabaseTypeName(), "INT") {
				k, _ := strconv.Atoi(string((col).([]uint8)[:]))
				colData[types[i].Name()] = k
			} else {
				colData[types[i].Name()] = string((col).([]uint8)[:])
			}
		}
		allData = append(allData, colData)
		cnt++
	}

	j, err := cjson.NewJsonMapFromBytes([]byte("{}"))
	if nil != err {
		fmt.Println(err)
		return nil, err
	}
	j.Insert(rootKey, allData)

	return j, nil
}
