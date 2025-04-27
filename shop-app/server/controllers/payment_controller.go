package controllers

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"net/http"
	"server/models"
	"strconv"
	"unicode"
)

func validatePayment(paymentData models.Transaction) error {
	if paymentData.Customer.Name == "" || paymentData.Customer.Surname == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "Customer name and surname are required")
	}

	if paymentData.Customer.Email == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "Customer email is required")
	}

	if paymentData.Customer.CardNumber == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "Card number is required")
	}

	if len(paymentData.Customer.CardNumber) != 16 {
		return echo.NewHTTPError(http.StatusBadRequest, "Card number must be 16 digits long")
	}

	for _, char := range paymentData.Customer.CardNumber {
		if !unicode.IsDigit(char) {
			return echo.NewHTTPError(http.StatusBadRequest, "Card number must contain only digits")
		}
	}

	if paymentData.Total <= 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Total amount must be greater than 0")
	}

	if err := validateCart(paymentData.Cart); err != nil {
		return err
	}

	var calculatedTotal float64
	var productPrice float64
	for _, item := range paymentData.Cart.Items {
		for _, product := range models.Products {
			if product.Name == item.Product.Name {
				productPrice, _ = strconv.ParseFloat(product.Price, 64)
				break
			}
		}

		calculatedTotal += productPrice * float64(item.Quantity)
	}

	if paymentData.Total != calculatedTotal {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Total amount mismatch: expected %.2f, got %.2f", calculatedTotal, paymentData.Total))
	}

	return nil
}

func CompletePayment(c echo.Context) error {
	var paymentData models.Transaction

	if err := c.Bind(&paymentData); err != nil {
		return err
	}

	if err := validatePayment(paymentData); err != nil {
		return err
	}

	fmt.Println("paymentData received: ")
	fmt.Println("Customer:", paymentData.Customer.Name, paymentData.Customer.Surname)
	fmt.Println("Email:", paymentData.Customer.Email)
	fmt.Println("Total:", paymentData.Total)

	fmt.Println("Cart:")
	for _, item := range paymentData.Cart.Items {
		fmt.Printf("Product: %s, quantity: %d\n", item.Product.Name, item.Quantity)
	}

	return c.JSON(http.StatusOK, echo.Map{"message": "Payment proceed successfully"})
}
