package RDBMS

import (
	"fmt"
	"sync"
)

var instance *dbInst
var once sync.Once

func getInstance() *dbInst {
	once.Do(func() {
		instance = &dbInst{}
	})
	return instance
}

func Initialize() {
	getInstance().dbInit()
}

func GetSqlInfo() string {
	return getInstance().sql
}

func GetOpenDatabaseInfo() string {
	return fmt.Sprintf(DB_OPEN_FORM, getInstance().user, getInstance().password,
		getInstance().ip, getInstance().port, getInstance().db_name)
}
