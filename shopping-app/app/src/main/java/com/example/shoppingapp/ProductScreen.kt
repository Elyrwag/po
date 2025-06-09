package com.example.shoppingapp

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.Alignment
import com.example.shoppingapp.data.models.Product
import io.realm.kotlin.Realm
import io.realm.kotlin.ext.query
import kotlinx.coroutines.flow.map

@Composable
fun ProductScreen(realm: Realm, categoryId: String, onBack: () -> Unit) {
    // updating in real-time
    val products by realm.query<Product>("categoryId == $0", categoryId)
        .asFlow()
        .map{ it.list }
        .collectAsState(initial = emptyList())

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Produkty", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(8.dp))

        LazyColumn {
            items(products) { product ->
                Row(
                    modifier = Modifier.fillMaxWidth().padding(8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(product.name)
                        Text("${product.price} zł")
                        if (product.quantityInCart > 0) {
                            Text("W koszyku: ${product.quantityInCart}")
                        }
                    }

                    Row {
                        Button(onClick = {
                            realm.writeBlocking {
                                findLatest(product)?.apply { quantityInCart += 1 }
                            }
                        }) {
                            Text("+")
                        }
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onBack, modifier = Modifier.align(Alignment.CenterHorizontally)) {
            Text("Powrót")
        }
    }
}