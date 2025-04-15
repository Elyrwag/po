package database

import (
	"echo-go/models"
	"fmt"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	var err error
	DB, err = gorm.Open(sqlite.Open("data.db"), &gorm.Config{})
	if err != nil {
		fmt.Println(err)
		return
	}

	migrateErr := DB.AutoMigrate(&models.Weather{})
	if migrateErr != nil {
		fmt.Println(migrateErr)
		return
	}
}
