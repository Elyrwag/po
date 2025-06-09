package com.example.shoppingapp.data.models

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey
import java.util.UUID

class Product : RealmObject {
    @PrimaryKey var id: String = UUID.randomUUID().toString()
    var name: String = ""
    var price: Double = 0.0
    var categoryId: String = ""
    var quantityInCart: Int = 0
}