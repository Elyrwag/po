package models

type Product struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Price string `json:"price"`
}

var Products = []Product{
	{ID: 1, Name: "Produkt 1", Price: "10.00"},
	{ID: 2, Name: "Produkt 2", Price: "20.00"},
	{ID: 3, Name: "Produkt 3", Price: "30.00"},
}
