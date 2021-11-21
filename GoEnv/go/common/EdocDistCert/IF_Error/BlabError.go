package IF_Error

import "log"

type BlabError struct {
	ErrCode string
	ErrMsg  string
	Err     error
}

type IBlabError interface {
	ToBlabError(inErr interface{})
	SetBlabError(errCode string, errMessage string)
	GetErrCode() string
	GetErrMsg() string
	GetError() error
}

func (be *BlabError) Error() string {
	return "ErrCode: " + be.ErrCode + ", ErrMessage: " + be.ErrMsg
}

func (be *BlabError) IsEmpty() bool {
	return be.ErrCode == ""
}

func (be *BlabError) IsNotEmpty() bool {
	return be.ErrCode != ""
}
func (be *BlabError) SetBlabError(errCode string, errMsg string) {
	be.ErrCode = errCode
	be.ErrMsg = errMsg
}

func (be *BlabError) GetError() error {
	return be.Err
}

func (be *BlabError) GetErrCode() string {
	return be.ErrCode
}

func (be *BlabError) GetErrMsg() string {
	return be.ErrMsg
}

func (be *BlabError) ToBlabError(inErr interface{}) {
	if inErr != nil {
		if ibe, ok := inErr.(IBlabError); ok {
			log.Println("BlabError Do")
			be.ErrCode = ibe.GetErrCode()
			be.ErrMsg = ibe.GetErrMsg()
			be.Err = ibe.GetError()
		} else if err, ok := inErr.(error); ok {
			log.Println("error Do")
			be.ErrCode = "SYS_ERROR"
			be.ErrMsg = err.Error()
			be.Err = err
		} else {
			be.ErrCode = "SYS_ERROR"
			be.ErrMsg = "Unknown System Error"
			be.Err = nil
		}
	} else {
		be.ErrCode = "SYS_ERROR"
		be.ErrMsg = "Unknown System Error"
		be.Err = nil
	}
}
