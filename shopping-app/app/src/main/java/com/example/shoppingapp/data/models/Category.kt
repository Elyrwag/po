package com.example.shoppingapp.data.models

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey
import java.util.UUID

class Category : RealmObject {
    @PrimaryKey var id: String = UUID.randomUUID().toString()
    var name: String = ""
}