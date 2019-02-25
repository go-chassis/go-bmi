package main

import (
	"context"
	"fmt"
	"net/http"

	"flag"
	"github.com/go-chassis/go-chassis"
	"github.com/go-chassis/go-chassis/client/rest"
	"github.com/go-chassis/go-chassis/core"
	"github.com/go-chassis/go-chassis/core/lager"
	"io/ioutil"
)

func main() {
	http.HandleFunc("/", BmiPageHandler)
	http.HandleFunc("/calculator/bmi", BmiRequestHandler)

	if err := chassis.Init(); err != nil {
		lager.Logger.Errorf("Init FAILED", err.Error())
		return
	}

	port := flag.String("port", "8889", "Port web-app will listen")
	address := flag.String("address", "0.0.0.0", "Address web-app will listen")
	fullAddress := fmt.Sprintf("%s:%s", *address, *port)
	http.ListenAndServe(fullAddress, nil)
}

func BmiRequestHandler(w http.ResponseWriter, r *http.Request) {
	heightstr := r.URL.Query().Get("height")
	weightstr := r.URL.Query().Get("weight")

	requestURI := fmt.Sprintf("cse://calculator/bmi?height=%s&weight=%s", heightstr, weightstr)
	restInvoker := core.NewRestInvoker()
	req, _ := rest.NewRequest("GET", requestURI, nil)
	resp, _ := restInvoker.ContextDo(context.TODO(), req)

	w.Header().Set("content-type", "application/json")
	w.WriteHeader(resp.StatusCode)

	defer resp.Body.Close()
	body,err:=ioutil.ReadAll(resp.Body)
	if err!=nil {
		lager.Logger.Errorf("Read response body ERROR: %s", err.Error())
	}
	w.Write(body)
}

func BmiPageHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "external/index.html")
}
