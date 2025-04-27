package models

type Customer struct {
	Name       string `json:"name"`
	Surname    string `json:"surname"`
	Email      string `json:"email"`
	CardNumber string `json:"cardNumber"`
}

type Transaction struct {
	Customer Customer `json:"customer"`
	Cart     Cart     `json:"cart"`
	Total    float64  `json:"total"`
}
