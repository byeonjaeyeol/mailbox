package Blab

// BlabResult 게이트웨이 응답 기본 구조
type BlabResult struct {
	// resultCode 처리결과
	Code string `json:"code" example:"200" validate:"required"`
	// description 처리결과 설명
	Description string `json:"description,omitempty" example:"success"`
}

type IBlabResult interface {
	SetResult(code string, description string)
	GetCode() string
	GetDescription() string
}

func (br *BlabResult) SetResult(code string, description string) {
	br.Code = code
	br.Description = description
}

func (br *BlabResult) GetCode() string {
	return br.Code
}

func (br *BlabResult) GetDescription() string {
	return br.Description
}
