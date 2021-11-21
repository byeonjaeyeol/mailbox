package IF_Error

import "log"

type KisaError struct {
	ErrCode string
	ErrMsg  string
	Err     error
}

type IKisaError interface {
	ToKisaError(inErr interface{})
	SetKisaError(errCode string, errMessage string)
	GetErrCode() string
	GetErrMsg() string
	GetError() error
}

func (ke *KisaError) Error() string {
	return "ErrCode: " + ke.ErrCode + ", ErrMessage: " + ke.ErrMsg
}

func (ke *KisaError) IsEmpty() bool {
	return ke.ErrCode == ""
}

func (ke *KisaError) IsNotEmpty() bool {
	return ke.ErrCode != ""
}
func (ke *KisaError) SetKisaError(errCode string, errMsg string) {
	ke.ErrCode = errCode
	ke.ErrMsg = errMsg
}

func (be *KisaError) GetError() error {
	return be.Err
}

func (ke *KisaError) GetErrCode() string {
	return ke.ErrCode
}

func (ke *KisaError) GetErrMsg() string {
	return ke.ErrMsg
}

func (ke *KisaError) ToKisaError(inErr interface{}) {
	if inErr != nil {
		if ike, ok := inErr.(IKisaError); ok {
			log.Println("KisaError Do")
			ke.ErrCode = ike.GetErrCode()
			ke.ErrMsg = ike.GetErrMsg()
			ke.Err = ike.GetError()
		} else if err, ok := inErr.(error); ok {
			log.Println("error Do")
			ke.ErrCode = "SYS_ERROR"
			ke.ErrMsg = err.Error()
			ke.Err = err
		} else {
			ke.ErrCode = "SYS_ERROR"
			ke.ErrMsg = "Unknown System Error"
			ke.Err = nil
		}
	} else {
		ke.ErrCode = "SYS_ERROR"
		ke.ErrMsg = "Unknown System Error"
		ke.Err = nil
	}
}
