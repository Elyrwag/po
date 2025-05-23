// 124 asserts

package controllers

import (
	"github.com/labstack/echo/v4"
	"github.com/mohae/deepcopy"
	"github.com/stretchr/testify/assert"
	"net/http"
	"server/models"
	"strconv"
	"testing"
)

func TestValidateCart(t *testing.T) {
	cart := models.Cart{Items: []models.CartItem{
		{Product: models.Product{Name: "Produkt 1"}, Quantity: 2},
	}}

	t.Run("Empty cart should return error", func(t *testing.T) {
		c := deepcopy.Copy(cart).(models.Cart) // just like in python, yay...
		c.Items = []models.CartItem{}

		err := validateCart(c)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Cart cannot be empty")
	})

	t.Run("Cart with empty product name should return error", func(t *testing.T) {
		c := deepcopy.Copy(cart).(models.Cart)
		c.Items[0].Product.Name = ""

		err := validateCart(c)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Product name is required")
	})

	t.Run("Cart with zero quantity should return error", func(t *testing.T) {
		c := deepcopy.Copy(cart).(models.Cart)
		c.Items[0].Quantity = 0

		err := validateCart(c)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Quantity must be greater than 0")
	})

	t.Run("Cart with negative quantity should return error", func(t *testing.T) {
		c := deepcopy.Copy(cart).(models.Cart)
		c.Items[0].Quantity = -20

		err := validateCart(c)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Quantity must be greater than 0")
	})

	t.Run("Valid cart should pass", func(t *testing.T) {
		err := validateCart(cart)
		assert.Nil(t, err)
		assert.NoError(t, err)
		assert.Equal(t, 1, len(cart.Items))
		assert.Equal(t, "Produkt 1", cart.Items[0].Product.Name)
		assert.Equal(t, 2, cart.Items[0].Quantity)
	})
}

func TestValidatePayment(t *testing.T) {
	transaction := models.Transaction{
		Customer: models.Customer{
			Name:       "Test",
			Surname:    "Testman",
			Email:      "ttest@example.com",
			CardNumber: "1234567890123456",
		},
		Cart: models.Cart{
			Items: []models.CartItem{
				{Product: models.Product{Name: "Produkt 1"}, Quantity: 2},
			},
		},
		Total: 20.00,
	}

	t.Run("Missing customer name should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.Name = ""

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Customer name and surname are required")
	})

	t.Run("Missing customer surname should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.Surname = ""

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Customer name and surname are required")
	})

	t.Run("Missing email should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.Email = ""

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Customer email is required")
	})

	t.Run("Valid email with special characters", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.Email = "test+1.mail-test@example.com"

		err := validatePayment(p)

		assert.Nil(t, err)
		assert.NoError(t, err)
		assert.Equal(t, "test+1.mail-test@example.com", p.Customer.Email)
	})

	t.Run("Missing card number should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.CardNumber = ""

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Card number is required")
	})

	t.Run("Too short card number should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.CardNumber = "123"

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Card number must be 16 digits long")
	})

	t.Run("Card number contains letters should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.CardNumber = "12345678abcd5678"

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Card number must contain only digits")
	})

	t.Run("Card number contains special characters should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.CardNumber = "1234+5-678!5/678"

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Card number must contain only digits")
	})

	t.Run("Total equal to zero should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Total = 0

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Total amount must be greater than 0")
	})

	t.Run("Negative total should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Total = -30

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Total amount must be greater than 0")
	})

	t.Run("Empty items list should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Cart.Items = []models.CartItem{}

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Cart cannot be empty")
	})

	t.Run("Non-existing product should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Cart.Items[0].Product.Name = "Car"

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Product 'Car' not found")
	})

	t.Run("Quantity zero should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Cart.Items[0].Quantity = 0

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Quantity must be greater than 0")
	})

	t.Run("Wrong total value (too much) should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Total = 999.99

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Total amount mismatch")
	})

	t.Run("Wrong total value (less than) should return error", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Total = 10.00

		err := validatePayment(p)

		assert.NotNil(t, err)
		assert.IsType(t, &echo.HTTPError{}, err)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Total amount mismatch")
	})

	t.Run("Long customer name and surname", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Customer.Name = "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch "
		p.Customer.Surname = "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch "

		err := validatePayment(p)

		assert.Nil(t, err)
		assert.NoError(t, err)
		assert.Contains(t, p.Customer.Name, "gogery")
		assert.Contains(t, p.Customer.Surname, "fair")
	})

	t.Run("Cart with two products should calculate total correctly", func(t *testing.T) {
		p := deepcopy.Copy(transaction).(models.Transaction)
		p.Cart.Items = []models.CartItem{
			{Product: models.Product{Name: "Produkt 1"}, Quantity: 1},
			{Product: models.Product{Name: "Produkt 2"}, Quantity: 2},
		}
		p.Total = 10.00 + 2*20.00

		err := validatePayment(p)

		assert.Nil(t, err)
		assert.NoError(t, err)
		assert.Equal(t, "Test", p.Customer.Name)
		assert.Equal(t, "Testman", p.Customer.Surname)
		assert.Equal(t, "ttest@example.com", p.Customer.Email)
		assert.Equal(t, "1234567890123456", p.Customer.CardNumber)
		assert.Equal(t, 2, len(p.Cart.Items))
		assert.Equal(t, "Produkt 1", p.Cart.Items[0].Product.Name)
		assert.Equal(t, 1, p.Cart.Items[0].Quantity)
		assert.Equal(t, "Produkt 2", p.Cart.Items[1].Product.Name)
		assert.Equal(t, 2, p.Cart.Items[1].Quantity)
		assert.Equal(t, 50.00, p.Total)
	})

	t.Run("Valid payment should pass", func(t *testing.T) {
		err := validatePayment(transaction)
		assert.Nil(t, err)
		assert.NoError(t, err)
		assert.Equal(t, "Test", transaction.Customer.Name)
		assert.Equal(t, "Testman", transaction.Customer.Surname)
		assert.Equal(t, "ttest@example.com", transaction.Customer.Email)
		assert.Equal(t, "1234567890123456", transaction.Customer.CardNumber)
		assert.Equal(t, 1, len(transaction.Cart.Items))
		assert.Equal(t, "Produkt 1", transaction.Cart.Items[0].Product.Name)
		assert.Equal(t, 2, transaction.Cart.Items[0].Quantity)
		assert.Equal(t, 20.00, transaction.Total)
	})
}
