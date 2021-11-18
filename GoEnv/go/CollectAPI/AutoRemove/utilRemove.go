package AutoRemove

import (
	"errors"
	"fmt"
	"strconv"

	json "../../common/JsonSerializer"
	"../Config"
)

type rmConfig struct {
	frequency   int
	StopChannel chan interface{}

	rmList []rmInst
}

type rmInst struct {
	removeTerm int
	removePath string
}

func (rc *rmConfig) rmInit() error {
	j, err := json.NewJsonMapFromBytes([]byte(Config.GetValue("remove")))
	if nil != err {
		return fmt.Errorf("AutoRemove::rmConfig()::AutoRemove Initialize Error : %v", err)
	}

	tmp, err := strconv.Atoi(Config.GetValue("remove.freq_hour"))
	if nil != err {
		return errors.New("AutoRemove frequency error : " + err.Error() + ", value : " + Config.GetValue("remove.freq_hour"))
	}
	rc.frequency = tmp

	for i := 0; i < j.Size("list"); i++ {
		instance := rmInst{}
		instance.removePath = j.Find(fmt.Sprintf("list.%v.path", i))

		tmp, _ := strconv.Atoi(j.Find(fmt.Sprintf("list.%v.term_day", i)))
		instance.removeTerm = tmp

		rc.rmList = append(rc.rmList, instance)
	}

	return nil
}
