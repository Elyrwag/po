package main

import (
	"echo-go/controllers"
	"echo-go/database"
	"github.com/labstack/echo/v4"
	"net/http"
)

func main() {
	database.InitDB()

	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})
	e.GET("/weather/:city", controllers.GetWeather)

	e.Logger.Fatal(e.Start(":8080"))
}
