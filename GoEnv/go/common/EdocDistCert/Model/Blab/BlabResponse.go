package Blab

type IBlabResponseData interface {
}

// BlabResponse 공통 기본 응답 정보
type BlabResponse struct {
	// result 응답 정보
	Result BlabResult `json:"result" validate:"required"`
	// data 응답 세부 정보
	Data IBlabResponseData `json:"data,omitempty"`
}

/*
type IBlabResponse interface {
	SetResult(code string, description string, data IBlabResponseData)
	GetResult() BlabResult
	GetResultCode() string
	GetResultDescription() string
	GetData() IBlabResponseData
}
*/

func (br *BlabResponse) SetResult(code string, description string, data IBlabResponseData) {
	br.Result.Code = code
	br.Result.Description = description
	br.Data = data
}

func (br *BlabResponse) GetResultCode() string {
	return br.Result.Code
}

func (br *BlabResponse) GetResultDescription() string {
	return br.Result.Description
}

func (br *BlabResponse) GetData() IBlabResponseData {
	return br.Data
}
