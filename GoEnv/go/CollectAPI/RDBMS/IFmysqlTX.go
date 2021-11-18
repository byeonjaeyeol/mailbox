package RDBMS

import (
	"database/sql"
	"fmt"
	"log"
	"strconv"
	"strings"

	"../Config"

	cjson "../../common/JsonSerializer"

	_ "github.com/go-sql-driver/mysql"
)

type TxManager struct {
	Tx *sql.Tx
	Db *sql.DB
}

func (tm *TxManager) TXBegin() error {
	var err error
	tm.Db, err = sql.Open("mysql", Config.GetValue("database.connector"))
	if nil != err {
		return err
	}

	tm.Tx, err = tm.Db.Begin()
	if nil != err {
		return err
	}

	return err
}

func (tm *TxManager) TXMysqlNonSelect(q string) error {
	_, err := tm.Tx.Exec(q)
	if nil != err {
		return err
	}

	return err
}

func (tm *TxManager) TXMysqlSelect(q string, rootKey string) (*cjson.JsonMap, error) {
	rows, err := tm.Tx.Query(q)
	if nil != err {
		return nil, err
	}

	defer rows.Close()

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
