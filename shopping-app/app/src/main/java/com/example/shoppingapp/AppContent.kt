package com.example.shoppingapp

import androidx.compose.runtime.*
import com.example.shoppingapp.data.models.Category
import io.realm.kotlin.Realm

@Composable
fun AppContent(realm: Realm) {
    var currentScreen by remember { mutableStateOf("categories") }
    var selectedCategory: Category? by remember { mutableStateOf(null) }

    when (currentScreen) {
        "categories" -> CategoryScreen(
            realm = realm,
            onCategoryClick = {
                selectedCategory = it
                currentScreen = "products"
            },
            onCartClick = { currentScreen = "cart" }
        )

        "products" -> selectedCategory?.let {
            ProductScreen(
                realm = realm,
                categoryId = it.id,
                onBack = { currentScreen = "categories" }
            )
        }

        "cart" -> CartScreen(
            realm = realm,
            onBack = { currentScreen = "categories" }
        )
    }
}