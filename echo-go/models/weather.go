package models

import "gorm.io/gorm"

type Weather struct {
	gorm.Model
	CityName    string
	Temperature float64
	Humidity    int
	Condition   string
}
