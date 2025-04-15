package controllers

import (
	"echo-go/database"
	"echo-go/models"
	"echo-go/proxy"
	"github.com/labstack/echo/v4"
	"net/http"
)

func GetWeather(c echo.Context) error {
	city := c.Param("city")

	var weather models.Weather
	if err := database.DB.Where("city_name = ?", city).First(&weather).Error; err != nil {
		// Not in database, fetch from outside service
		weatherData, err := proxy.FetchWeatherData(city)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "Error fetching weather data")
		}

		database.DB.Create(weatherData)
		weather = *weatherData
	}

	return c.JSON(http.StatusOK, weather)
}
