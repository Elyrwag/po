package controllers

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"net/http"
	"server/models"
)

func validateCart(cart models.Cart) error {
	if len(cart.Items) == 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Cart cannot be empty")
	}

	var productFound bool
	for i, item := range cart.Items {
		if item.Product.Name == "" {
			return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Item %d: Product name is required", i+1))
		}
		if item.Quantity <= 0 {
			return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Item %d: Quantity must be greater than 0", i+1))
		}

		productFound = false
		for _, product := range models.Products {
			if product.Name == item.Product.Name {
				productFound = true
				break
			}
		}

		if !productFound {
			return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Item %d: Product '%s' not found", i+1, item.Product.Name))
		}
	}

	return nil
}

func SubmitCart(c echo.Context) error {
	var cart models.Cart

	if err := c.Bind(&cart); err != nil {
		return err
	}

	if err := validateCart(cart); err != nil {
		return err
	}

	fmt.Println("cart received: ")
	for _, item := range cart.Items {
		fmt.Printf("Product: %s, quantity: %d\n", item.Product.Name, item.Quantity)
	}

	return c.JSON(http.StatusOK, echo.Map{"message": "Cart received successfully"})
}
