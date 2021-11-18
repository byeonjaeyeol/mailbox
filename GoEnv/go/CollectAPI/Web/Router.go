package InterfaceWeb

import (
	"context"
	"fmt"
	"net/http"
	"sync"
	"time"

	"../Config"

	Controller "./Controller"

	"../../common/Logger"
	"../Authorization"
	"../Model"

	"github.com/julienschmidt/httprouter"
)

var instance *router
var once sync.Once

type router struct {
	router         *httprouter.Router
	staticResource *httprouter.Router

	webServer *http.Server
}

func GetInstance() *router {
	once.Do(func() {
		instance = &router{}
	})
	return instance
}

func Route() {
	go GetInstance().startRoute()
}

// API precheck : CheckAPIAuthor
func wrapHandlerFunc(handler httprouter.Handle) httprouter.Handle {

	return func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
		res := Model.NewResult()

		for {
			verRes := Authorization.CheckVersion(r)

			if verRes == 0 {
				res.SetResult("90000", "Authorization Failed.")
				break

			} else if verRes == 1 {
				return

			} else if verRes == 2 {
				return

			} else if verRes == 200 {
				// API Authorization
				if Authorization.CheckAPIAuthor(r) {
					handler(w, r, p)
					return

				} else {
					res.SetResult("90000", "Authorization Failed.")
					break
				}

			}
		}

		fmt.Fprint(w, res.ToString())
		return
	}
}

///////////////////////////////////////
//Router
///////////////////////////////////////
func (w *router) startRoute() {
	w.router = httprouter.New()

	// status - action
	w.router.GET("/", wrapHandlerFunc(Controller.ServerHealth))

	// check IF status
	w.router.GET("/status", Controller.GetStatus)

	// convert API
	w.router.POST("/convert", wrapHandlerFunc(Controller.ConvertWeb))
	w.router.POST("/collect", wrapHandlerFunc(Controller.CollectWeb))

	w.staticResource = httprouter.New()
	w.staticResource.ServeFiles("/*filepath", http.Dir(Config.GetValue("server.resource_path")))
	w.router.NotFound = w.staticResource

	servePortString := fmt.Sprintf(":%v", Config.GetValue("server.port"))
	w.webServer = &http.Server{
		Addr:    servePortString,
		Handler: w.router,
	}

	fmt.Println("[CollectAPI][Router] _INFO : Web::Router - Start Web Service :", servePortString)
	Logger.WriteLog("web", 10, "Web::Router - start web service :", servePortString)
	w.webServer.SetKeepAlivesEnabled(true)

	w.webServer.ListenAndServe()
}

// Stop : http server stop
func Stop() {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	fmt.Println("[BlabAgent][Router] _INFO : Web::Router - Stop Web Service")
	Logger.WriteLog("web", 10, "Web::Router - Stop web service :")
	err := GetInstance().webServer.Shutdown(ctx)
	if nil != err {
		Logger.WriteLog("error", 10, "Web::Router - Stop web service :", err)
	}
}
