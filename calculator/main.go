package main

import (
	"github.com/ServiceComb/go-chassis"
	"github.com/ServiceComb/go-chassis/core/lager"
	"github.com/ServiceComb-samples/go-bmi/calculator/app"
)

func main() {
	chassis.RegisterSchema("rest", &app.CalculateBmi{})
	if err := chassis.Init(); err != nil {
		lager.Logger.Error("Init FAILED", err)
		return
	}
	chassis.Run()

}
