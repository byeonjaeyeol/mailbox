package Validator

import (
	// ko_KR "github.com/go-playground/locales/ko_KR" // 한글 번역본 없음
	en "github.com/go-playground/locales/en"
	ut "github.com/go-playground/universal-translator"
	"gopkg.in/go-playground/validator.v9"
	"log"
	// ko_KR_translations "gopkg.in/go-playground/validator.v9/translations/ko_KR" // 한글 번역은 없음
	en_translations "gopkg.in/go-playground/validator.v9/translations/en"
)

type EdocDistCertValidatorType struct {
	v     *validator.Validate
	trans ut.Translator
}

var EdocDistCertValidator *EdocDistCertValidatorType

// var EdocDistCertValidator *validator.Validate

func InitEdocDistCertValidator() {
	cv := EdocDistCertValidatorType{}

	translator := en.New()
	uni := ut.New(translator, translator)

	// this is usually known or extracted from http 'Accept-Language' header
	// also see uni.FindTranslator(...)
	trans, found := uni.GetTranslator("en")
	if !found {
		log.Fatal("translator not found")
	}

	v := validator.New()

	if err := en_translations.RegisterDefaultTranslations(v, trans); err != nil {
		log.Fatal(err)
	}

	_ = v.RegisterTranslation("required", trans, func(ut ut.Translator) error {
		return ut.Add("required", "{0}은(는) 필수 항목입니다.", true) // see universal-translator for details
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("required", fe.Field())
		return t
	})

	_ = v.RegisterTranslation("datetimeYYYY-MM-DD HH24:MI:SS", trans, func(ut ut.Translator) error {
		return ut.Add("passwd", "{0} 형식이 잘못되었습니다. YYYY-MM-DD HH24:MI:SS 형식으로 입력해 주세요.", true) // see universal-translator for details
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("passwd", fe.Field())
		return t
	})

	_ = v.RegisterTranslation("myDatetime", trans, func(ut ut.Translator) error {
		return ut.Add("myDatetime", "{0} 형식이 잘못되었습니다. YYYY-MM-DD HH24:MI:SS 형식으로 입력해 주세요.", true) // see universal-translator for details
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("myDatetime", fe.Field())
		return t
	})

	err := v.RegisterValidation("myDatetime", func(fl validator.FieldLevel) bool {
		return len(fl.Field().String()) == 19
	})
	if err != nil {
		log.Printf("err=%v\n", err)
	}

	cv.v = v
	cv.trans = trans
	EdocDistCertValidator = &cv
}

func (cv *EdocDistCertValidatorType) ValidateStruct(s interface{}) error {
	return cv.v.Struct(s)
}

func (cv *EdocDistCertValidatorType) GetErrorMsg(err error) string {
	return err.(validator.ValidationErrors)[0].Translate(cv.trans)
}

func (cv *EdocDistCertValidatorType) LogError(err error) {
	log.Printf("EdocDistCertValidator: err=%+v\n", err)
	log.Println(err.(validator.ValidationErrors)[0].Translate(cv.trans))
}
