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
fun CartScreen(realm: Realm, onBack: () -> Unit) {
    // updating in real-time
    val productsInCart by realm.query<Product>("quantityInCart > 0")
        .asFlow()
        .map{ it.list }
        .collectAsState(initial = emptyList())
    val totalPrice = productsInCart.sumOf { it.price * it.quantityInCart }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Koszyk", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(8.dp))

        LazyColumn(modifier = Modifier.weight(1f)) {
            items(productsInCart) { product ->
                Row(
                    modifier = Modifier.fillMaxWidth().padding(8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(product.name)
                        Text("${product.price} zł x ${product.quantityInCart}")
                        Text("Suma: %.2f zł".format(product.price * product.quantityInCart))
                    }

                    Row {
                        Button(onClick = {
                            realm.writeBlocking {
                                findLatest(product)?.apply { quantityInCart += 1 }
                            }
                        }) {
                            Text("+")
                        }

                        Spacer(modifier = Modifier.width(4.dp))
                        Button(
                            onClick = {
                                realm.writeBlocking {
                                    findLatest(product)?.apply { if (quantityInCart > 0) quantityInCart -= 1 }
                                }
                            },
                            enabled = product.quantityInCart > 0
                        ) {
                            Text("-")
                        }

                        Spacer(modifier = Modifier.width(4.dp))
                        Button(
                            onClick = {
                                realm.writeBlocking {
                                    findLatest(product)?.apply { quantityInCart = 0 }
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error)
                        ) {
                            Text("Usuń")
                        }
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "Suma koszyka: %.2f zł".format(totalPrice),
            modifier = Modifier.align(Alignment.End)
        )

        Spacer(modifier = Modifier.height(32.dp))
        Button(
            onClick = {
                realm.writeBlocking {
                    realm.query<Product>("quantityInCart > 0").find().forEach {
                        findLatest(it)?.apply { quantityInCart = 0 }
                    }
                }
            },
            modifier = Modifier.align(Alignment.CenterHorizontally),
            colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error)
        ) {
            Text("Wyczyść koszyk")
        }

        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onBack, modifier = Modifier.align(Alignment.CenterHorizontally)) {
            Text("Powrót")
        }
    }
}