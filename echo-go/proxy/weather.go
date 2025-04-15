package proxy

import (
	"echo-go/models"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
)

var apiKey = os.Getenv("API_KEY")
var apiURL = "http://api.openweathermap.org/data/2.5/weather"

func FetchWeatherData(city string) (*models.Weather, error) {
	url := apiURL + "?q=" + city + "&appid=" + apiKey + "&units=metric&lang=pl"

	response, err := http.Get(url)
	if err != nil {
		fmt.Println("Error fetching weather:", err)
		return nil, err
	}

	if response.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(response.Body)
		fmt.Println("API error:", response.StatusCode)
		fmt.Println("Response:", string(body))
		return nil, errors.New("error fetching weather")
	}

	var data models.WeatherResponse
	if err := json.NewDecoder(response.Body).Decode(&data); err != nil {
		fmt.Println("Decoding JSON error:", err)
		return nil, err
	}

	return &models.Weather{
		CityName:    city,
		Temperature: data.Main.Temp,
		Humidity:    data.Main.Humidity,
		Condition:   data.Weather[0].Description,
	}, nil
}
