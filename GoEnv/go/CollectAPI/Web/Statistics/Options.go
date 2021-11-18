package Stats

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

func ByDocID_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func ByRequestID_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func ByGroupBy_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func ByTime_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func ByDMRegNum_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func ByName_Opts(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	SetOptionsHeader(w)
}

func SetOptionsHeader(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, X-Requested-With")
	w.Header().Set("Access-Control-Allow-Credentials", "true")
}
