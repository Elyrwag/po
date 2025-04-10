package com.example.spring_kotlin

import org.springframework.context.annotation.Lazy
import org.springframework.stereotype.Service

@Lazy
@Service
class AuthServiceLazy {
    private val validUser = "admin"
    private val validPassword = "admin"

    init {
        println("AuthServiceLazy init")
    }

    fun authorize(username: String, password: String): Boolean {
        return username == validUser && password == validPassword
    }
}
