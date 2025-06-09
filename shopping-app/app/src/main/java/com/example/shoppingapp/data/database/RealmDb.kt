package com.example.shoppingapp.data.database

import com.example.shoppingapp.data.models.*
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration

object RealmDb {
    lateinit var realm: Realm

    fun init() {
        val config = RealmConfiguration.Builder(
            schema = setOf(Category::class, Product::class)
        ).deleteRealmIfMigrationNeeded().build()
        realm = Realm.open(config)

        realm.writeBlocking {
            if (query(Category::class).find().isEmpty()) {
                copyToRealm(Category().apply { id = "1"; name = "Category 1" })
                copyToRealm(Category().apply { id = "2"; name = "Category 2" })

                copyToRealm(Product().apply { id = "1"; name = "Product 1"; price = 499.99; categoryId = "1" })
                copyToRealm(Product().apply { id = "2"; name = "Product 2"; price = 199.99; categoryId = "1" })
                copyToRealm(Product().apply { id = "3"; name = "Product 3"; price = 39.99; categoryId = "2" })
            }
        }
    }

    fun close() {
        realm.close()
    }
}