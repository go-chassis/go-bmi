package main

import (
	"github.com/go-chassis/go-chassis"
	"github.com/go-chassis/go-chassis/core/lager"
	"github.com/ServiceComb-samples/go-bmi/calculator/app"
)

func main() {
	chassis.RegisterSchema("rest", &app.CalculateBmi{})
	if err := chassis.Init(); err != nil {
		lager.Logger.Errorf("Init FAILED %s", err.Error())
		return
	}
	chassis.Run()

}
