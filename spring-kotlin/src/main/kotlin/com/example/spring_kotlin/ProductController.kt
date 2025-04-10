package com.example.spring_kotlin

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Lazy
import org.springframework.web.bind.annotation.*

@RestController
class ProductController @Autowired constructor(
    private val authServiceEager: AuthServiceEager,
    @Lazy private val authServiceLazy: AuthServiceLazy
) {

    private val products = listOf(
        Product(1, "Product 1", 2999.99),
        Product(2, "Product 2", 1299.49),
        Product(3, "Product 3", 199.99)
    )

    @PostMapping("eager/products")
    fun getProductsEager(@RequestParam username: String, @RequestParam password: String): Any {
        return if (authServiceEager.authorize(username, password)) {
            products
        } else {
            "Authorization failed. Please check your credentials."
        }
    }

    @PostMapping("lazy/products")
    fun getProductsLazy(@RequestParam username: String, @RequestParam password: String): Any {
        return if (authServiceLazy.authorize(username, password)) {
            products
        } else {
            "Authorization failed. Please check your credentials."
        }
    }
}