package RDBMS

import (
	"../Config"
)

const (
	DB_OPEN_FORM string = `%v:%v@tcp(%v:%v)/%v`
)

type dbInst struct {
	sql string

	user     string
	password string
	ip       string
	port     string
	db_name  string
}

func (db *dbInst) dbInit() {
	db.sql = Config.GetValue("database.sql")
	db.user = Config.GetValue("database.connect.user")
	db.password = Config.GetValue("database.connect.password")
	db.ip = Config.GetValue("database.connect.ip")
	db.port = Config.GetValue("database.connect.port")
	db.db_name = Config.GetValue("database.connect.db_name")
}
