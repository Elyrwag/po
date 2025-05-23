package tests

import (
	"bytes"
	"encoding/json"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"server/controllers"
	"server/models"
	"strconv"
	"testing"
)

// Test GET /api/products
func TestGetProducts_Positive(t *testing.T) {
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/api/products", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, controllers.GetProducts(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(t, "application/json", rec.Header().Get("Content-Type"))

		var resp []models.Product
		err := json.Unmarshal(rec.Body.Bytes(), &resp)
		assert.NoError(t, err)

		assert.Equal(t, models.Products, resp)
	}
}

func TestGetProducts_Negative(t *testing.T) {
	originalProducts := models.Products
	models.Products = nil

	t.Cleanup(func() {
		models.Products = originalProducts
	})

	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/api/products", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	err := controllers.GetProducts(c)
	if assert.Error(t, err) {
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusNotFound))
		assert.Contains(t, err.Error(), "No products found")
	}
}

// Test POST /api/submit-cart
func TestSubmitCart_Positive(t *testing.T) {
	cart := models.Cart{
		Items: []models.CartItem{
			{Product: models.Product{Name: "Produkt 1"}, Quantity: 1},
			{Product: models.Product{Name: "Produkt 2"}, Quantity: 5},
		},
	}
	body, _ := json.Marshal(cart)

	e := echo.New()
	req := httptest.NewRequest(http.MethodPost, "/api/submit-cart", bytes.NewBuffer(body))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, controllers.SubmitCart(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(t, "application/json", rec.Header().Get("Content-Type"))
		assert.Contains(t, rec.Body.String(), "Cart received successfully")
	}
}

func TestSubmitCart_Negative(t *testing.T) {
	e := echo.New()
	req := httptest.NewRequest(http.MethodPost, "/api/submit-cart", bytes.NewBuffer([]byte("")))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	err := controllers.SubmitCart(c)
	if assert.Error(t, err) {
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Cart cannot be empty")
	}
}

// Test POST /api/complete-payment
func TestCompletePayment_Positive(t *testing.T) {
	transaction := models.Transaction{
		Customer: models.Customer{
			Name:       "Test",
			Surname:    "Testman",
			Email:      "ttest@example.com",
			CardNumber: "1234567890123456",
		},
		Total: 10.00,
		Cart: models.Cart{
			Items: []models.CartItem{
				{Product: models.Product{Name: "Produkt 1"}, Quantity: 1},
			},
		},
	}
	body, _ := json.Marshal(transaction)

	e := echo.New()
	req := httptest.NewRequest(http.MethodPost, "/api/complete-payment", bytes.NewBuffer(body))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, controllers.CompletePayment(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(t, "application/json", rec.Header().Get("Content-Type"))
		assert.Contains(t, rec.Body.String(), "Payment proceed successfully")
	}
}

func TestCompletePayment_Negative(t *testing.T) {
	transaction := models.Transaction{
		Customer: models.Customer{
			Name:       "Test",
			Surname:    "Testman",
			Email:      "ttest@example.com",
			CardNumber: "1234567890123456",
		},
		Total: 1.00,
		Cart: models.Cart{
			Items: []models.CartItem{
				{Product: models.Product{Name: "Produkt 1"}, Quantity: 1},
			},
		},
	}
	body, _ := json.Marshal(transaction)

	e := echo.New()
	req := httptest.NewRequest(http.MethodPost, "/api/complete-payment", bytes.NewBuffer(body))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	err := controllers.CompletePayment(c)
	if assert.Error(t, err) {
		assert.Contains(t, err.Error(), strconv.Itoa(http.StatusBadRequest))
		assert.Contains(t, err.Error(), "Total amount mismatch")
	}
}
