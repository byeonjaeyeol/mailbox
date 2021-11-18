package Convert

import (
	"fmt"

	jsonlib "../../common/JsonSerializer"
	"../../common/Logger"
	"../Utils"

	_ "github.com/go-sql-driver/mysql"
)

func (ci *convInst) convertFile() {

	Logger.WriteLog("convert", 10, "__Entered convertFile() ")

	// doneList date array
	doneList, err := ci.getCollectDoneDate()
	if nil != err {
		Logger.WriteLog("error", 10, fmt.Errorf("Failed Read File Info::Convert::convertFile()::getDoneInfo() : %v", err))
		fmt.Println("[CollectAPI][sam2bulk] _INFO : Today Check Err: ", err)
		return
	}

	// fmt.Println("[CollectAPI][sam2bulk] _INFO : Today Check doneList : ", doneList)
	// fmt.Println("[CollectAPI][sam2bulk] _INFO : Today Check : ", Utils.CollectCheckDone(doneList))

	// 테스트용 숨김
	if Utils.CollectCheckDone(doneList) {
		return
	}

	ci.collectCheckToJson()

	// 파일 생성후 실행
	// err = ci.setDoneDate()
	// if nil != err {
	// 	Logger.WriteLog("error", 10, fmt.Errorf("Failed Write Date to Done::Convert::convertFile()::addDone() : %v", err))
	// 	return
	// }
}

func (ci *convInst) convertWeb(jsonData *jsonlib.JsonMap, count int) string {

	Logger.WriteLog("convert", 10, "__Entered convertWeb() ")

	logKey := Utils.GetRandomString(10)

	Logger.WriteLog("convert", 10, "__Entered jsonWebProc() [Key : ", logKey, "]")

	ci.convertWebJsonData(jsonData, count)

	Logger.WriteLog("convert", 10, "__Convert jsonWebProc Done [Key : ", logKey, "]")

	doneDate := ci.setWebDoneDate(count)
	if nil != doneDate {
		Logger.WriteLog("error", 10, fmt.Errorf("Failed Write Date to Done::Convert::convertWeb()::addDone() : %v", doneDate))
		return "WebDone Write Error"
	}

	return ""
}

func (ci *convInst) collectCheckToJson() {
	logKey := Utils.GetRandomString(10)
	Logger.WriteLog("collect", 10, "__Entered collectCheckToJson() [Key : ", logKey, "]")

	// fmt.Println("[CollectAPI][sam2bulk] _INFO : collectCheckToJson Start [id : ", ci.agencyID, "]")
	err, count := ci.convertCollectData(ci.agencyID)
	if nil != err {
		Logger.WriteLog("error", 10, fmt.Errorf("Failed Convert Sam to Bulk::Convert::convertFile()::collectCheckToJson()::convertCollectData() : %v, samFile : %v, [Key : %v]", err, ci.agencyID, logKey))
	} else {

		err = ci.setCollectDoneDate(count)
		if nil != err {
			Logger.WriteLog("error", 10, fmt.Errorf("Failed Write Date to Done::Convert::convertFile()::addDone() : %v", err))
			return
		}

		Logger.WriteLog("collect", 10, "__Convert File Done [Key : ", logKey, "]")
	}

}
