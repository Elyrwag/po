package com.example.shoppingapp

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.Alignment
import com.example.shoppingapp.data.models.Category
import io.realm.kotlin.Realm
import io.realm.kotlin.ext.query

@Composable
fun CategoryScreen(realm: Realm, onCategoryClick: (Category) -> Unit, onCartClick: () -> Unit) {
    val categories = realm.query<Category>().find()

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Kategorie", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(8.dp))

        LazyColumn {
            items(categories) { category ->
                Button(
                    onClick = { onCategoryClick(category) },
                    modifier = Modifier.fillMaxWidth().padding(vertical=4.dp)
                ) {
                    Text(
                        text = category.name,
                        style = MaterialTheme.typography.bodyLarge
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onCartClick, modifier = Modifier.align(Alignment.CenterHorizontally)) {
            Text("Koszyk")
        }
    }
}